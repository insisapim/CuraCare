import 'package:curacare/app.dart';
import 'package:curacare/pages/homepage.dart';
import 'package:curacare/pages/login_page.dart';
import 'package:curacare/services/authentication_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter username";
                  }
                  return null;
                },
                controller: _usernameController,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !EmailValidator.validate(value)) {
                    return "Please enter email";
                  }
                  return null;
                },
                controller: _emailController,
              ),
              TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password";
                  }
                  return null;
                },
                controller: _passwordController,
              ),
              TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter confirm password";
                  }
                  return null;
                },
                controller: _confirmPasswordController,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Password and confirm password must be the same",
                          ),
                        ),
                      );
                      return;
                    }
                    if (!mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("กำลังลงทะเบียน")));

                    final res = await AuthenticationService.signUp(
                      _emailController.text,
                      _passwordController.text,
                      _usernameController.text,
                    );
                    if (!mounted) return;
                    if (!res.ok) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(res.message)));
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("สำเร็จ")));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  }
                },
                child: const Text("ลงทะเบียน"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
