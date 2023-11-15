import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

import 'package:firebase_database/firebase_database.dart';

class Addphto extends StatefulWidget {
  const Addphto({super.key});

  @override
  State<Addphto> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Addphto> {
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage; // Store the picked image file
  String downloadURL = '';
  Future<void> _getImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        print('image path    ${_pickedImage?.path}');
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        print(_pickedImage?.path);
      });
    }
  }

  Future uploadFile() async {
    if (_pickedImage == null) return;
    final fileName = basename(_pickedImage!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);

      // Set the content type to 'image/jpeg' explicitly
      final metadata =
          firebase_storage.SettableMetadata(contentType: 'image/jpeg');

      await ref.putFile(
        _pickedImage!,
        metadata,
      );
      downloadURL = await ref.getDownloadURL();
      print(downloadURL);
      addUser();
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // Future<void> uplod_to_databadse() async {
  //   try {
  //     final databaseRef = FirebaseDatabase.instance.ref();
  //     final newImageRef = databaseRef.child('images').push();
  //     await newImageRef.set({
  //       'url': downloadURL,
  //       'name': name.text,
  //       'age': age.text,
  //     });
  //     print('Data uploaded successfully');
  //   } catch (e) {
  //     print('Error uploading data: $e');
  //   }
  // }
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    return users
        .doc(name.text)
        .set({'full_name': name.text, 'age': age.text, 'url': downloadURL})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Photo'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text(
                    'Enter user\nDetails!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),
                  color: Color.fromARGB(255, 2, 88, 142),
                ),
                height: 150,
                width: 150,
                child: Stack(
                  children: [
                    _pickedImage != null
                        ? SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.file(File(_pickedImage!.path),
                                fit: BoxFit.scaleDown),
                          )
                        : Center(
                            child: Text(
                              "No Image Selected",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(25)),
                            color: Colors.black38),
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Select an Image"),
                                    content: Text(
                                        "Choose an image from your gallery or take a photo"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _getImageFromGallery();
                                        },
                                        child: Text("Gallery"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _getImageFromCamera();
                                        },
                                        child: Text("Camera"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.add_a_photo_rounded,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'name',
                    border: OutlineInputBorder(),
                  ),
                  controller: name,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'age',
                    border: OutlineInputBorder(),
                  ),
                  controller: age,
                ),
              ),
              SizedBox(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {
                        uploadFile();
                      },
                      child: Text('Save')))
            ],
          ),
        ),
      ),
    );
  }
}
