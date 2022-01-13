// ignore_for_file: prefer_const_constructors, avoid_print, prefer_final_fields, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_login/screens/homeScreen.dart';

enum LoginScreen { SHOW_MOBILE_FORM_WIDGET, SHOW_OTP_FORM_WIDGET }

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  LoginScreen currentState = LoginScreen.SHOW_MOBILE_FORM_WIDGET;
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationID = "";

  void SignOut() async {
    await auth.signOut();
  }

  void signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async {
    try {
      final authCred = await auth.signInWithCredential(phoneAuthCredential);

      if (authCred.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some Error Occured. Try Again Later')));
    }
  }

  showMobilePhoneWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Text(
          "Verify Your Phone Number",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              controller: phoneController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Your PhoneNumber"),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ElevatedButton(
              onPressed: () async {
                await auth.verifyPhoneNumber(
                    phoneNumber: "+91${phoneController.text}",
                    verificationCompleted: (phoneAuthCredential) async {},
                    verificationFailed: (verificationFailed) {
                      print(verificationFailed);
                    },
                    codeSent: (verificationID, resendingToken) async {
                      setState(() {
                        currentState = LoginScreen.SHOW_OTP_FORM_WIDGET;
                        this.verificationID = verificationID;
                      });
                    },
                    codeAutoRetrievalTimeout: (verificationID) async {});
              },
              child: Text("Send OTP")),
        ),
        SizedBox(
          height: 16,
        ),
        Spacer()
      ],
    );
  }

  showOtpFormWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Text(
          "ENTER YOUR OTP",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              controller: otpController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter Your OTP"),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                  verificationId: verificationID, smsCode: otpController.text);
              signInWithPhoneAuthCred(phoneAuthCredential);
            },
            child: Text("Verify")),
        SizedBox(
          height: 16,
        ),
        Spacer()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentState == LoginScreen.SHOW_MOBILE_FORM_WIDGET
          ? showMobilePhoneWidget(context)
          : showOtpFormWidget(context),
    );
  }
}
