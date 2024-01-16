// import 'package:flutter/material.dart';
// import 'package:tugas_1d/authentication.dart';
// import 'package:tugas_1d/login.dart';

// class Detail extends StatefulWidget {
//   const Detail({super.key});

//   @override
//   State<Detail> createState() => _DetailState();
// }

// class _DetailState extends State<Detail> {
//   late AuthFirebase auth;

//   @override
//   void initState() {
//     super.initState();
//     auth = AuthFirebase();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('About'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   auth.signOut();
//                   auth.signOutFromGoogle();
//                 });
//                 Navigator.pushReplacement(context,
//                     MaterialPageRoute(builder: (context) => const MyLogin()));
//               },
//               icon: const Icon(Icons.logout))
//         ],
//       ),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('Vantur_211111221'),
//               Image.asset(
//                 'assets/1.jpg',
//                 width: 200,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
