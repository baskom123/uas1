import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas/login.dart';
import 'package:uas/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ScreenProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => DarkThemeProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }

  void getCurrentTheme() async {
    themeProvider.darkTheme =
        await themeProvider.darkThemePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      return themeProvider;
    }, child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, child) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: Styles.themeData(themeProvider.darkTheme, context),
        home: const MyLogin(),
        debugShowCheckedModeBanner: false,
      );
    }));
  }
}

class DarkThemePreferences {
  static const themeStatus = "ThemeStatus";

  setDark(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeStatus, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeStatus) ?? false;
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        primarySwatch: Colors.red,
        primaryColor: isDarkTheme ? Colors.black : Colors.white,
        indicatorColor:
            isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
        hintColor:
            isDarkTheme ? const Color(0xff280C0B) : const Color(0xffEECED3),
        highlightColor:
            isDarkTheme ? const Color(0xff372901) : const Color(0xffFCE192),
        hoverColor:
            isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
        focusColor:
            isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
        disabledColor: Colors.grey,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: isDarkTheme ? Colors.white : Colors.black,
          selectionColor: isDarkTheme
              ? Colors.white.withOpacity(0.5)
              : Colors.black.withOpacity(0.5),
          selectionHandleColor: isDarkTheme ? Colors.white : Colors.black,
        ),
        cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme
                ? const ColorScheme.dark()
                : const ColorScheme.light()),
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
        ));
  }
}
