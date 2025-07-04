import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:convert';

import '../../core/theme/wave_clipper.dart';
import '../../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isLoading = false;
  String? errorMessage;


  // Theme Colors (same as login screen)
  final Color primaryColor = const Color(0xFF205072);
  final Color inputFillColor = const Color(0xFF2C6975);
  final Color textColor = Colors.black;
  final Color hintTextColor = const Color(0xFF2C6975).withOpacity(0.6);
  final TextEditingController dobCtrl = TextEditingController();
  DateTime? selectedDOB;
  bool showPassword = false;
  bool showConfirmPassword = false;



  // Form Controllers
  final firstNameCtrl=TextEditingController();
  final lastNameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  String? selectedGender;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  String? selectedRole;
  final List<String> roleOptions = ['Candidate', 'Recruiter'];


  void nextPage() {
    if (_currentPage < 2) {
      setState(() => _currentPage++);
      _pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _register();
    }
  }

  void prevPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _register() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final url = Uri.parse("http://192.168.0.22:8000/api/auth/register");

    // Validate form before sending request
    if (!_validateForm()) {
      setState(() => isLoading = false);
      return;
    }

    final Map<String, dynamic> requestBody = {
      "email": emailCtrl.text.trim(),
      "firstname": firstNameCtrl.text.trim(),
      "lastname": lastNameCtrl.text.trim(),
      "password": passwordCtrl.text.trim(),
      "dob": selectedDOB != null ? DateFormat('dd-MM-yyyy').format(selectedDOB!) : null,
      "contact": phoneCtrl.text.trim(),
      "gender": selectedGender?.toUpperCase(), // API expects "MALE"
      "address": addressCtrl.text.trim(),
      "userClass": selectedRole?.toUpperCase(), // "CANDIDATE" or "RECRUITER"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Registration successful!");
        Get.offNamed(AppRoutes.login); // navigate to login page
      } else {
        final responseBody = json.decode(response.body);
        Fluttertoast.showToast(
            msg: "Registration failed: ${responseBody['message'] ?? response.body}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Network error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }




  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      resizeToAvoidBottomInset: true, // change this
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: WaveClipper(showBottom: false),
              child: Container(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Text("Create an Account",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      )),
                  const SizedBox(height: 10),
                  _buildStepper(),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 500, // optional: consider making this responsive
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStepCard(_buildStep1()),
                        _buildStepCard(_buildStep3()),
                        _buildStepCard(_buildStep2()),
                      ],
                    ),
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      child: Text(errorMessage!,
                          style: GoogleFonts.poppins(
                              color: Colors.red, fontSize: 14)),
                    ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: isLoading ? null : prevPage,
                            child: Text("Back",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: isLoading
                                      ? primaryColor.withOpacity(0.5)
                                      : primaryColor,
                                )),
                          ),
                        ElevatedButton(
                          onPressed: isLoading ? null : nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : Text(
                                  _currentPage == 2 ? "Register" : "Next",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Add bottom spacing to prevent overflow
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = _currentPage == i;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: active ? 25 : 8,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(active ? 1 : 0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }

  Widget _buildStepCard(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.95),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
          ),
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return _buildStepTemplate("Basic Information", [
      _buildTextField(
          label: "First Name",
          hint: "Enter your first name",
          icon: Icons.person,
          controller: firstNameCtrl),
      _buildTextField(
          label: "Last Name",
          hint: "Enter your last name",
          icon: Icons.person,
          controller: lastNameCtrl),
      _buildDropdown(
        label: "Gender",
        hint: "Select your gender",
        options: genderOptions,
        icon: Icons.person,
        onChanged: (v) => setState(() => selectedGender = v),
      ),
      _buildTextField(
          label: "Email",
          hint: "you@example.com",
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          controller: emailCtrl),
    ]);
  }

  // Widget _buildStep2() {
  //   return _buildStepTemplate("Security & Address", [
  //     _buildTextField(
  //         label: "Password",
  //         hint: "At least 6 characters",
  //         icon: Icons.lock,
  //         isPassword: true,
  //         controller: passwordCtrl),
  //     _buildTextField(
  //         label: "Confirm Password",
  //         hint: "Re-enter your password",
  //         icon: Icons.lock,
  //         isPassword: true,
  //         controller: confirmPasswordCtrl),
  //   ]);
  // }

  Widget _buildStep2() {
    return _buildStepTemplate("Security & Address", [
      _buildTextField(
        label: "Password",
        hint: "At least 6 characters",
        icon: Icons.lock,
        isPassword: !showPassword,
        showToggle: true,
        controller: passwordCtrl,
        onTogglePassword: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
      ),
      _buildTextField(
        label: "Confirm Password",
        hint: "Re-enter your password",
        icon: Icons.lock,
        isPassword: !showConfirmPassword,
        showToggle: true,
        controller: confirmPasswordCtrl,
        onTogglePassword: () {
          setState(() {
            showConfirmPassword = !showConfirmPassword;
          });
        },
      ),
    ]);
  }


  Widget _buildStep3() {
    return _buildStepTemplate("Profile Details", [
      _buildTextField(
        label: "Date of Birth",
        hint: "Select your date of birth",
        icon: Icons.calendar_today,
        controller: dobCtrl,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              selectedDOB = pickedDate;
              dobCtrl.text = DateFormat('dd/MM/yyyy').format(pickedDate);
            });
          }
        },
      ),
      _buildTextField(
        label: "Contact Number",
        hint: "10-digit mobile number",
        icon: Icons.phone,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: phoneCtrl,
      ),
      _buildTextField(
        label: "Address",
        hint: "Your residential address",
        icon: Icons.home,
        controller: addressCtrl,
      ),

      // ✅ Add Role dropdown here
      _buildDropdown(
        label: "Role",
        hint: "Select your role",
        options: roleOptions,
        icon: Icons.person_outline,
        onChanged: (v) => setState(() => selectedRole = v),
      ),
    ]);
  }


  Widget _buildStepTemplate(String title, List<Widget> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ...fields,
      ],
    );
  }


  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool showToggle = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            onTap: onTap,
            cursorColor: textColor,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: textColor,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: hintTextColor,
                fontSize: 14,
              ),
              counterText: '',
              prefixIcon: Icon(icon, color: inputFillColor),
              suffixIcon: showToggle
                  ? IconButton(
                icon: Icon(
                  isPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onTogglePassword,
              )
                  : null,
              filled: true,
              fillColor: inputFillColor.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black26),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }


  bool _validateForm() {

    if (selectedRole == null) {
      _showToast("Please select your role");
      return false;
    }

    if (firstNameCtrl.text.trim().isEmpty) {
      _showToast("First name is required");
      return false;
    }

    if (lastNameCtrl.text.trim().isEmpty) {
      _showToast("Last name is required");
      return false;
    }

    if (selectedGender == null) {
      _showToast("Please select your gender");
      return false;
    }

    final email = emailCtrl.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      _showToast("Enter a valid email address");
      return false;
    }

    if (passwordCtrl.text.length < 6) {
      _showToast("Password must be at least 6 characters long");
      return false;
    }

    final strongPasswordRegex =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$');

    if (!strongPasswordRegex.hasMatch(passwordCtrl.text)) {
      _showToast("Password must contain uppercase, lowercase, and number");
      return false;
    }

    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      _showToast("Passwords do not match");
      return false;
    }

    if (selectedDOB == null) {
      _showToast("Please select your date of birth");
      return false;
    }

    if (phoneCtrl.text.length != 10 || !RegExp(r'^\d{10}$').hasMatch(phoneCtrl.text)) {
      _showToast("Enter a valid 10-digit phone number");
      return false;
    }

    if (addressCtrl.text.trim().isEmpty) {
      _showToast("Address cannot be empty");
      return false;
    }

    return true;
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      textColor: Colors.red,
    );
  }


  Widget _buildDropdown({
    required String label,
    required String hint,
    required List<String> options,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          DropdownButtonFormField2<String>(
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: inputFillColor.withOpacity(0.1),
              hintText: hint,
              hintStyle:
                  GoogleFonts.poppins(fontSize: 14, color: hintTextColor),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              prefixIcon: Icon(icon, color: textColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black26),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
            ),
            hint: Text(hint, style: GoogleFonts.poppins(fontSize: 14)),
            items: options
                .map((v) => DropdownMenuItem(
                    value: v,
                    child: Text(v, style: GoogleFonts.poppins(fontSize: 14))))
                .toList(),
            onChanged: onChanged,
            iconStyleData: IconStyleData(
              icon: Icon(Icons.keyboard_arrow_down, color: textColor),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              maxHeight: 200,
            ),
          ),
        ],
      ),
    );
  }
}
