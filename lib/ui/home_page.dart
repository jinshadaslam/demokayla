import 'dart:io';

import 'package:demokayla/ui/addphoto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _home_pageState();
}

class _home_pageState extends State<Home_page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsers() {
    try {
      return firestore.collection('users').snapshots();
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')));
      return Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    String? userEmail = user?.email;
    String? userId = user?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Addphto()),
              );
            },
            icon: Icon(Icons.add_a_photo),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Email: $userEmail'),
            Text('User ID: $userId'),
            Container(
              // color: Colors.black38,
              height: 500,
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: getMyUsers(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final users = snapshot.data?.docs ?? [];
                    return Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final userData =
                              users[index].data() as Map<String, dynamic>;
                          final imageURL = userData['url'];

                          return ListTile(
                            leading: Image.network(
                                imageURL), // Display the user's image
                            title: Text(userData[
                                'full_name']), // Display other user data
                            subtitle: Text(userData['age']),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
