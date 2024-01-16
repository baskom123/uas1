import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uas/authentication.dart';
import 'package:uas/provider.dart';
import 'package:uas/register.dart';
import 'package:uas/screenpage.dart';
import 'package:provider/provider.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool _isPasswordVisible = false;
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void showSnackBar(BuildContext context) {
    var snackBar = const SnackBar(
      content: Text("Akun Anda Berhasil Masuk!"),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late AuthFirebase auth;

  String emailUser = "";

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenProvider>(context);
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: const Text("CoffeShop"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 0, top: 50),
            ),
            const Text(
              "Selamat Datang Kembali",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25,
                height: 3,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Masukkan Akunmu!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintText: "Alamat Email",
                      helperStyle: TextStyle(color: Colors.black12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: _password,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: "Kata Sandi",
                      hintStyle: const TextStyle(color: Colors.black12),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 3),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    final userId = await auth.login(email, password);
                    setState(() {
                      auth.getUser().then((value) {
                        emailUser = value!.email.toString();
                      });
                    });

                    if (userId != null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Screen(
                                    email: emailUser,
                                  )));

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Login Sukses')));
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Email or Password is Wrong')));
                    }
                  },
                  // ignore: sort_child_properties_last
                  child: const Text(
                    "Masuk Akun",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10.0)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 0, top: 20),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Registrasi1(),
                          ));
                    },
                    child: const Text(
                      "Tidak Punya Akun?Klik untuk Mendaftar",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    )),
                const SizedBox(height: 15),
                const Text(
                  "Atau Masuk dengan",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 13),
                  width: double.infinity,
                  child: IconButton(
                      onPressed: () async {
                        final result = await auth.signInWithGoogle();
                        if (result != null) {
                          prov.isLoginGoogle = true;
                          setState(() {
                            auth.getUser().then((value) {
                              emailUser = value!.email.toString();
                            });
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Screen(
                                        email: emailUser,
                                      )));
                        } else {
                          prov.isLoginGoogle = true;
                          setState(() {
                            auth.getUser().then((value) {
                              emailUser = value!.email.toString();
                            });
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Screen(email: emailUser)));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login Success')));
                        }
                      },
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        color: Colors.green,
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
