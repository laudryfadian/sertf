import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sertf/helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nohpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Username",
                    ),
                    controller: usernameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Name",
                    ),
                    controller: namaController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Password",
                    ),
                    obscureText: true,
                    controller: passwordController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "No HP",
                    ),
                    keyboardType: TextInputType.number,
                    controller: nohpController,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  register();
                },
                child: const Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  register() async {
    try {
      var dbUser = FirebaseFirestore.instance.collection('users');

      var userCek = await dbUser
          .where('username', isEqualTo: usernameController.text)
          .get()
          .then((value) => value.size > 0 ? true : false);

      if (!userCek) {
        await dbUser.add({
          'username': usernameController.text,
          'nama': namaController.text,
          'password': passwordController.text,
          'nohp': nohpController.text,
        });
        if (mounted) {
          Helpers().showSnackBar(context, 'Register Successful', Colors.green);
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          Helpers()
              .showSnackBar(context, 'Register Fail, try again', Colors.red);
        }
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        Helpers().showSnackBar(context, e.message.toString(), Colors.red);
      }
    }
  }
}
