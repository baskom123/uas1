import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Storage extends StatefulWidget {
  const Storage({super.key});

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menambah Item"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              // key: Key,
              child: Column(
            children: [
              TextField(),
              TextField(),
              IconButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    // Mengambil selvi
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    print('${file?.path}');
                    if (file == null) return;

                    // import dart:core

                    String uniqeFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    // Mengambil dari kamera
                    // imagePicker.pickImage(source: ImageSource.gallery);

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');

                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqeFileName);

                    // Menghendel error/sukses
                    try {
                      // store the file
                      await referenceImageToUpload.putFile(File(file.path));
                      // Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {}
                  },
                  icon: const Icon(Icons.camera_alt)),
            ],
          ))),
    );
  }
}
