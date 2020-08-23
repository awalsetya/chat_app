import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Sign In'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Masukan Email'),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Password',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Masukan kata sandi',
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Align(
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () {},
                child: Text('Masuk'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
