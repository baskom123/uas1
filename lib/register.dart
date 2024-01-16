import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'login.dart';

class Registrasi1 extends StatefulWidget {
  const Registrasi1({super.key});

  @override
  State<Registrasi1> createState() => _Registrasi1State();
}

class _Registrasi1State extends State<Registrasi1> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  late AuthFirebase auth; 

  bool? userNameEmpty;
  bool? isEmailEmpty;
  bool? isPasswordEmpty;

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
  }

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Oke'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('CoffeShope'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                const Text(
                  'Daftar Gratis Sekarang!!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                const Text(
                  "Daftar Akunmu!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          label: const Text("username"),
                          errorText: isEmailEmpty == true
                              ? 'Alamat Email harus di isi'
                              : null,
                          labelStyle: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _pass,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          errorText: isPasswordEmpty == true
                              ? 'Kata Sandi harus di isi'
                              : null,
                          label: const Text("Kata Sandi"),
                          labelStyle: const TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _confirmpass,
                        obscureText: !isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          errorText: isPasswordEmpty == true
                              ? 'Ketik Ulang Kata Sandi Harus Diisi'
                              : null,
                          label: const Text('Confirm Password'),
                          labelStyle: const TextStyle(color: Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: _toggleConfirmPasswordVisibility,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _pass.text;
                        if (email.isEmpty) {
                          setState(() {
                            isEmailEmpty = true;
                          });
                          return;
                        }
                        if (password.isEmpty) {
                          setState(() {
                            isEmailEmpty = true;
                          });
                        }
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);

                          await auth.addUserData(userCredential.user!.uid,
                              email, email.split('@')[0], "",null);

                          if (context.mounted) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyLogin()));
                          }
                        } on FirebaseAuthException catch (e) {
                          displayMessage(e.code);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.black),
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
