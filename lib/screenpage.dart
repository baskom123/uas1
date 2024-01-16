import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uas/authentication.dart';
import 'package:uas/home.dart';
import 'package:uas/login.dart';
import 'package:uas/pages/makanan.dart';
import 'package:uas/pages/minuman.dart';
import 'package:uas/pages/profile.dart';
import 'package:uas/provider.dart';
import 'package:provider/provider.dart';

class Screen extends StatefulWidget {
  const Screen({super.key, required this.email});
  final String email;

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int _currentIndex = 0;
  late AuthFirebase auth;

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void location() async {
    if (await Permission.locationWhenInUse.status.isGranted) {
      print("Location is Granted !!!");
    } else {
      var status = await Permission.accessMediaLocation.request();
      print(status);
      print("Location tidak dapat diakses!");
      if (status == PermissionStatus.granted) {
        print("Akses Location Diberikan !!");
      } else if (status == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
  }

  List navBar = ['Home', 'Minuman', 'Makanan'];
  List pages = [const HomePage(), const MinumanPage(), const MakananPage()];
  final TextEditingController searching = TextEditingController();

  String email = "";
  String name = "";
  String urlImg = "";

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenProvider>(context);
    final changeTheme = Provider.of<DarkThemeProvider>(context);
    auth.getUser().then((value) {
      email = value!.email!;
      name = value.displayName ?? "";
      urlImg = value.photoURL ?? "";
    });

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(15.0),
              decoration: const BoxDecoration(color: Colors.cyan),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        email: email,
                        name: name,
                        urlimg: urlImg,
                      ),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    prov.isLoginGoogle
                        ? CircleAvatar(
                            minRadius: 12,
                            maxRadius: 24,
                            backgroundImage: NetworkImage(urlImg),
                          )
                        : const CircleAvatar(
                            minRadius: 12,
                            maxRadius: 24,
                            child: Icon(Icons.person),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.email,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Pengaturan'),
                    trailing: const Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(changeTheme.darkTheme
                        ? Icons.nightlight
                        : Icons.light_mode),
                    title: Text(
                        changeTheme.darkTheme ? 'Dark Theme' : 'Light Theme'),
                    trailing: Switch(
                      value: changeTheme.darkTheme,
                      onChanged: (bool value) {
                        changeTheme.darkTheme = value;
                      },
                    ),
                  ),
                  // ListTile(
                  //   onTap: () {

                  //   },
                  //   leading: const Icon(Icons.book),
                  //   title: const Text('menu'),
                  //   trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  // ),
                  // ListTile(
                  //   onTap: (){
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ));
                  //   },
                  //   leading: const Icon(Icons.book),
                  //   title: const Text('test'),
                  //   trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  // )
                  //     ],
                  //   ),

                  // ),
                  // Container(
                  //   padding: const EdgeInsets.only(top: 160),
                  //   child: Align(
                  //     alignment: FractionalOffset.bottomCenter,
                  //     child: Column(children: [
                  //       const Divider(
                  //         thickness: 10,
                  //       ),
                  //       ListTile(
                  //         onTap: ((){}),
                  //         leading: ,
                  //       )
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: location, child: const Text("location")),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Log Out"),
                                content: const Text(
                                    "Apakah anda yakin ingin Log Out?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Kembali')),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        auth.signOut();
                                        auth.signOutFromGoogle();
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const MyLogin(),
                                        ),
                                      );
                                    },
                                    child: const Text('Iya'),
                                    // TextField(decoration: InputDecoration(
                                    //   border: OutlineInputBorder(), label: "sing-in-out"
                                    // ),),
                                  )
                                ],
                              ));
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text('Log Out'),
                  ),
                  ListTile(
                    leading: Icon(changeTheme.darkTheme
                        ? Icons.nightlight
                        : Icons.light_mode),
                    onTap: () {},
                    trailing: Switch(
                        value: changeTheme.darkTheme,
                        onChanged: (bool value) {
                          changeTheme.darkTheme = value;
                        }),
                    title: Text(
                        changeTheme.darkTheme ? 'Night Mode' : 'Light Mode'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.glassWater), label: 'Minuman'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.shrimp), label: 'Makanan')
        ],
      ),
    );
  }
}
