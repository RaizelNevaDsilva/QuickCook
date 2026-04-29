import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';
import '../utils/app_colors.dart' as app_colors;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signUpWithEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _authService.getErrorMessage(e));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final qc = context.qc;

    return Scaffold(
      backgroundColor: qc.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: qc.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(Icons.person_add,
                        size: 60,
                        color: app_colors.AppColors.orange),

                    const SizedBox(height: 14),

                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: qc.text1,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Join QuickCook today",
                      style: TextStyle(color: qc.text3),
                    ),

                    const SizedBox(height: 20),

                    if (_errorMessage != null)
                      Text(_errorMessage!,
                          style: const TextStyle(color: Colors.red)),

                    const SizedBox(height: 10),

                    _buildField(
                      context,
                      controller: _emailController,
                      hint: "Email",
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 14),

                    _buildField(
                      context,
                      controller: _passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 14),

                    _buildField(
                      context,
                      controller: _confirmPasswordController,
                      hint: "Confirm Password",
                      icon: Icons.lock_outline,
                      isConfirm: true,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              app_colors.AppColors.orange,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("Create Account",
                                style:
                                    TextStyle(color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                            style: TextStyle(color: qc.text3)),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Login",
                              style: TextStyle(
                                  color: app_colors
                                      .AppColors.orange)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isConfirm = false,
  }) {
    final qc = context.qc;

    return TextFormField(
      controller: controller,
      obscureText: isPassword || isConfirm
          ? (isConfirm ? _obscureConfirmPassword : _obscurePassword)
          : false,
      style: TextStyle(color: qc.text1),
      validator: (v) {
        if (v!.isEmpty) return "Required";
        if (isConfirm && v != _passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: qc.text3),
        prefixIcon: Icon(icon, color: qc.text3),
        filled: true,
        fillColor: qc.bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffixIcon: (isPassword || isConfirm)
            ? IconButton(
                icon: Icon(
                  (isConfirm
                          ? _obscureConfirmPassword
                          : _obscurePassword)
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: qc.text3,
                ),
                onPressed: () {
                  setState(() {
                    if (isConfirm) {
                      _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                    } else {
                      _obscurePassword = !_obscurePassword;
                    }
                  });
                },
              )
            : null,
      ),
    );
  }
}