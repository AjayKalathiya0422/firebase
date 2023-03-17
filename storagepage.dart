import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart';

class storagepage extends StatefulWidget {
  const storagepage({Key? key}) : super(key: key);

  @override
  State<storagepage> createState() => _storagepageState();
}

class _storagepageState extends State<storagepage> {
  String imagepath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Center(
          child: Container(
            margin: EdgeInsets.all(60),
            child: InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();

                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    imagepath = image!.path;
                  });
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(File(imagepath)),
                )),
          ),
        ),
        Container(
          height: 50,
          width: 150,
          child: ElevatedButton(
              onPressed: () async {
                final storageRef = FirebaseStorage.instance.ref();
                final spaceRef = storageRef
                    .child("RJ/images${Random().nextInt(100000)}.jpg");
                       await spaceRef.putFile(File(imagepath));
                      spaceRef.getDownloadURL().then((value) async {
                        print("$value");
                        DatabaseReference ref= FirebaseDatabase.instance
                            .ref("RealtimeDatabase")
                            .push();
                        String? id=ref.key;

                        await ref.set({
                          "id":id,
                          "name": "John",
                          "age": 18,
                          "imagedta":value,
                          }
                          ).then((value) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                              return firebassepage();
                            },));
                        });

                      });
              },
              child: Center(
                  child: Text(
                "Submit data",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ))),
        )
      ]),
    );
  }
}
