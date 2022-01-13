import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:phone_login/screens/loginScreen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("YOU ARE SIGNED IN SUCCESSFULLY!")),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
          child: const Icon(Icons.logout)),
    );
  }
}
