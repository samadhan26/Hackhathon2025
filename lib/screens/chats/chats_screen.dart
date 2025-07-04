import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [];
  final TextEditingController messageCtrl = TextEditingController();
  late stt.SpeechToText speech;
  late FlutterTts flutterTts;
  bool isListening = false;
  final String openAIApiKey = dotenv.env['OPEN_AI_API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    flutterTts = FlutterTts();
  }

  Future<void> _listen() async {
    if (!isListening) {
      bool available = await speech.initialize();
      if (available) {
        setState(() => isListening = true);
        speech.listen(onResult: (result) {
          setState(() {
            messageCtrl.text = result.recognizedWords;
          });
        });
      }
    } else {
      setState(() => isListening = false);
      speech.stop();
    }
  }

  Future<void> _sendMessage() async {
    final text = messageCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(Message(text: text, isUser: true)); // User message
      messageCtrl.clear();
    });

    final response = await _getIntentFromOpenAI(text); // Bot response
    setState(() {
      messages.add(Message(
          text: response, isUser: false)); // Bot message (isUser: false)
    });
  }

  Future<String> _getIntentFromOpenAI(String input) async {
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    final prompt = '''
You are a smart Resume Assistant. Classify the user message into a structured intent.
Return JSON like:
{"intent": "resume_search", "parameters": {"keywords": "developer, Java, full-stack"}}

Supported intents:
- resume_search
- resume_build
- resume_update
- resume_feedback
- unknown

Message: "$input"
''';

    try {
      final res = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIApiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": prompt
            }, // system message with instructions
            {"role": "user", "content": input} // user message input
          ],
          "temperature": 0,
        }),
      );

      if (res.statusCode != 200) {
        return 'Sorry, I couldn’t reach the server. Please try again later.';
      }

      final decoded = jsonDecode(res.body);
      final content = decoded['choices'][0]['message']['content'];

      // Print raw response for development
      debugPrint('[OpenAI Raw Response] $content');

      final Map<String, dynamic> intentResponse = jsonDecode(content);
      final String intent = intentResponse['intent'] ?? 'unknown';
      final Map<String, dynamic> params =
          Map<String, dynamic>.from(intentResponse['parameters'] ?? {});

      // Intent-to-response mapping for Resume-related intents
      final Map<String, String Function(Map<String, dynamic>)> responseMap = {
        'resume_search': (p) =>
            'Searching for resumes matching ${p['keywords']}...',
        'resume_build': (_) =>
            'Let me help you build a new resume. What role are you looking for?',
        'resume_update': (_) =>
            'I see you want to update your resume. What changes would you like to make?',
        'resume_feedback': (_) =>
            'I will provide feedback on your resume. Please upload the document.',
      };

      // If intent is known, return mapped response
      if (responseMap.containsKey(intent)) {
        return responseMap[intent]!(params);
      }

      return 'I couldn’t understand that. Could you rephrase it?';
    } catch (e) {
      if (kDebugMode) print('Intent parsing error: $e');
      return 'Something went wrong while processing your request.';
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F3F6),
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Resume Assistant",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];

                  debugPrint('[Message Debug] Message: ${msg.text}');
                  debugPrint(
                      '[Message Debug] From: ${msg.isUser ? "User" : "System"}');
                  debugPrint(
                      '[Message Debug] Aligning message to: ${msg.isUser ? "Right" : "Left"}');

                  return Row(
                    mainAxisAlignment: msg.isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!msg.isUser) // Avatar on left for bot
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, top: 6),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              'https://ui-avatars.com/api/?name=HR+Bot&background=FFFFFF&color=000&size=256',
                            ),
                          ),
                        ),
                      Flexible(
                        child: Align(
                          alignment: msg.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: msg.isUser
                                  ? const Color(0xFF1565C0)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft:
                                    Radius.circular(msg.isUser ? 16 : 6),
                                bottomRight:
                                    Radius.circular(msg.isUser ? 6 : 16),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Text(
                              msg.text,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color:
                                    msg.isUser ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (msg.isUser) // Avatar on right for user
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 6),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              'https://ui-avatars.com/api/?name=Vishwajit+Kumar&background=FFFFFF&color=000&size=256',
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.blue,
                    ),
                    onPressed: _listen,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F1F5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: messageCtrl,
                        style: GoogleFonts.poppins(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: "Ask me anything about resumes...",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon:
                          const Icon(Icons.send, size: 18, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
