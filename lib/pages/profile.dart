
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas/textBox.dart';

class Profile extends StatefulWidget {
  final String email;
  final String name;
  final String urlimg;

  const Profile(
      {super.key,
      required this.email,
      required this.name,
      required this.urlimg});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userData = FirebaseFirestore.instance.collection('users');

    Future<void> editField(String field) async {
      String newValue = "";
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Colors.grey[800],
                title: Text(
                  "Edit $field",
                  style: const TextStyle(color: Colors.white10),
                ),
                content: TextField(
                  autofocus: true,
                  style: const TextStyle(color: Colors.white10),
                  decoration: InputDecoration(
                    hintText: "Enter new $field",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    newValue = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cencel'),
                  ),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(newValue),
                      child: const Text('Save'))
                ],
              ));
      if (newValue.trim().isNotEmpty) {
        await userData.doc(currentUser!.uid).update({field: newValue});
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('profile Setting'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Icon(
                  Icons.person,
                  size: 75,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  currentUser.email.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'My Detail',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                TextBox(
                  text: userData['username'],
                  nameSection: 'username',
                  onPressed: () => editField('username'),
                ),
                TextBox(
                  text: userData['bio'],
                  nameSection: 'bio',
                  onPressed: () => editField('bio'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
