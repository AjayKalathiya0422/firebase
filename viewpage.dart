import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  List temp = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     forviewdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView.builder(itemCount: temp.length,
        itemBuilder: (context, index) {
        return ListTile(
          subtitle: Text("${temp[index]["age"]}"),
          leading: CircleAvatar(radius: 30,
              backgroundImage: NetworkImage("${temp[index]["imagedta"]}")),
          title: Text("${temp[index]["name"]}"),);

      },),


    );
  }

  Future<void> forviewdata() async {

    DatabaseReference ref= FirebaseDatabase.instance.ref("RealtimeDatabase");
      DatabaseEvent dd = await ref.once();

      print("===${dd.snapshot.value}");

      Map map= dd.snapshot.value as Map;
      ref.onValue.listen((event) {
        temp.clear();
        map.forEach((key, value) {
          setState(() {
            temp.add(value);
          });
        });

      });

  }
}
