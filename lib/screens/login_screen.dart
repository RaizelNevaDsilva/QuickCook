import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import '../utils/app_theme.dart';
import '../utils/app_colors.dart' as app_colors;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signInWithEmailPassword(
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
                    Icon(Icons.restaurant_menu,
                        size: 60,
                        color: app_colors.AppColors.orange),

                    const SizedBox(height: 14),

                    Text(
                      "QuickCook",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: qc.text1,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Login to continue",
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

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          if (_emailController.text.isEmpty) return;
                          await _authService.sendPasswordResetEmail(
                              email: _emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Reset email sent")),
                          );
                        },
                        child: Text("Forgot password?",
                            style: TextStyle(
                                color:
                                    app_colors.AppColors.orange)),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              app_colors.AppColors.orange,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("Login",
                                style:
                                    TextStyle(color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New here?",
                            style: TextStyle(color: qc.text3)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const SignupScreen()),
                            );
                          },
                          child: Text("Sign Up",
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
  }) {
    final qc = context.qc;

    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: TextStyle(color: qc.text1),
      validator: (v) => v!.isEmpty ? "Required" : null,
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
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: qc.text3,
                ),
                onPressed: () => setState(
                    () => _obscurePassword = !_obscurePassword),
              )
            : null,
      ),
    );
  }
}