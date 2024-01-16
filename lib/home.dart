import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas/detailscreen.dart';
import 'package:uas/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenProvider>(context);
    final changeTheme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        body: Center(
      child: FutureBuilder(
          future: prov.initalizeMenus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('tidak ada data');
            } else {
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                        child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: prov.isSearching
                          ? prov.searchResults.length
                          : prov.menus.length,
                      itemBuilder: (context, index) {
                        final menu = prov.isSearching
                            ? prov.searchResults[index]
                            : prov.menus[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Detailpage(menu: menu.name),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(menu.img),
                                    // fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 5,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: changeTheme.darkTheme
                                        ? Colors.grey
                                        : Colors.black12,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      menu.name,
                                      style: TextStyle(
                                        color: changeTheme.darkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )),
                  ],
                ),
              );
            }
          }),
    ),);
  }
}
