import 'package:curacare/pages/login_page.dart';
import 'package:curacare/services/authentication_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color.fromARGB(255, 18, 179, 39),
                                const Color.fromARGB(255, 31, 170, 73),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Curacare",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: Colors.grey[900],
                          ),
                        ),
                        Text(
                          "Your Health Companion",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อผู้ใช้',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "โปรดใส่ชื่อผู้ใช่";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "โปรดใส่อีเมล";
                    }
                    if (EmailValidator.validate(value)) {
                      return "โปรดใส่อีเมลให้ถูกต้อง ตัวอย่าง user@email.com";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "โปรดใส่รหัสผ่าน";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'ยืนยันรหัสผ่าน',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_reset),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "โปรดใส่รหัสผ่านอีกครั้ง";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!mounted) return;
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'โปรดกรอกรหัสผ่านทั้งสองช่องให้เหมือนกัน',
                            ),
                          ),
                        );
                      }

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('กำลังลงทะเบียน')),
                      );
                      final authRes = await AuthenticationService.signUp(
                        _emailController.text,
                        _passwordController.text,
                        _usernameController.text,
                      );
                      if (!mounted) return;
                      if (!authRes.ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authRes.message)),
                        );
                      }
                      if (!mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("สำเร็จ")));
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'ลงทะเบียน',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "มีบัญชีอยู่แล้ว? ",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
