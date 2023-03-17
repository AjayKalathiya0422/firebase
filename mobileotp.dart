import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class mobileotp extends StatefulWidget {
  const mobileotp({Key? key}) : super(key: key);

  @override
  State<mobileotp> createState() => _mobileotpState();
}

class _mobileotpState extends State<mobileotp> {
  TextEditingController number = TextEditingController();
  TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
            children: [
          Container(padding: EdgeInsets.only(top: 50),
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: number,
              decoration: InputDecoration(hintText: "Enter Your Phone Number"),
            ),
          ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '+91${number.text}',
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {

                    setState(() {
                      very=verificationId;
                    });
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              }, child: Text("Enter Number")),

              SizedBox(height: 10,),

          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: otp,
              decoration: InputDecoration(hintText: "Otp"),
            ),
          ),
              ElevatedButton(onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                String smsCode = "${otp.text}";
                // Create a PhoneAuthCredential with the code
                PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: very, smsCode: smsCode);

                // Sign the user in (or link) with the credential
                await auth.signInWithCredential(credential);


              }, child: Text("Enter Otp")),

              SizedBox(height: 50,),

              ElevatedButton(onPressed: () {


                signInWithGoogle().then((value) => (value) {
                  print("===$value");
                });

              }, child: Text("Google Login")),
        ]),

      ),
    );
  }
  String very="";

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
