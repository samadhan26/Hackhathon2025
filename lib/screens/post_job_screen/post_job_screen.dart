import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController companyCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController salaryCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController workTypeCtrl = TextEditingController();
  final TextEditingController skillsCtrl = TextEditingController();

  final String userId = "6867ddfaa76a7fdcf509ee10"; // Use SharedPreferences later

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Post a Job',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[700]),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        iconTheme: IconThemeData(color: Colors.teal[700]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField("Job Title", titleCtrl, Icons.work, validator: _validateRequired),
              _buildInputField("Company Name", companyCtrl, Icons.business, validator: _validateRequired),
              _buildInputField("Location", locationCtrl, Icons.location_on, validator: _validateRequired),
              _buildInputField("Salary (Optional)", salaryCtrl, Icons.currency_rupee, validator: _validateSalary),
              _buildInputField("Work Type", workTypeCtrl, Icons.access_time, validator: _validateRequired),
              _buildInputField("Skills Required", skillsCtrl, Icons.list_alt, validator: _validateRequired),
              _buildInputField("Job Description", descriptionCtrl, Icons.description,
                  maxLines: 5, validator: _validateRequired),
              const SizedBox(height: 16),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label,
      TextEditingController controller,
      IconData icon, {
        int maxLines = 1,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.teal[700], fontWeight: FontWeight.w500),
          prefixIcon: Icon(icon, color: Colors.teal[700]),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _submitJob,
        icon: _isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        )
            : const Icon(Icons.send, color: Colors.white),
        label: Text(
          _isLoading ? "Posting..." : "Submit",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.teal[700],
        ),
      ),
    );
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final jobData = {
      "userId": userId,
      "jobTitle": titleCtrl.text.trim(),
      "companyName": companyCtrl.text.trim(),
      "location": locationCtrl.text.trim(),
      "skills": skillsCtrl.text.trim(),
      "salary": int.tryParse(salaryCtrl.text.trim()) ?? 0,
      "worktype": workTypeCtrl.text.trim(),
      "jobDescription": descriptionCtrl.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.22:8000/api/upload/jd'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jobData),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showDialog("Success", "Your job has been posted successfully!");
        _formKey.currentState!.reset();
        titleCtrl.clear();
        companyCtrl.clear();
        locationCtrl.clear();
        salaryCtrl.clear();
        descriptionCtrl.clear();
        workTypeCtrl.clear();
        skillsCtrl.clear();
      } else {
        final responseData = jsonDecode(response.body);
        final errorMsg = responseData['message'] ?? "Something went wrong.";
        _showSnackBar("Error: $errorMsg");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Network error: ${e.toString()}");
    }
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateSalary(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final salary = int.tryParse(value.trim());
    if (salary == null || salary < 0) return 'Enter a valid salary';
    return null;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }
}
