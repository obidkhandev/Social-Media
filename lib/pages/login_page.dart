import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_socialmedia/components/my_button.dart';
import 'package:my_socialmedia/components/my_textfield.dart';
import 'package:my_socialmedia/helper/helper_functions.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login method
  void login() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    // try sing in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(
                height: 25,
              ),
              // appname
              const Text(
                "O b i d k h a n",
                style: TextStyle(fontSize: 20),
              ),
              // email textfield
              const SizedBox(
                height: 50,
              ),
              MyTextField(
                  hintText: 'Email',
                  obscureText: false,
                  controller: emailController),
              // password textfield
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                  hintText: 'Password',
                  obscureText: true,
                  controller: passwordController),
              // forgot password
              const SizedBox(
                height: 10
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot password',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
              // sing in button
              const SizedBox(
                height: 25,
              ),
              MyButton(text: 'Login', onTap: login),
              // don't have account? Register here
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      ' Register here',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
