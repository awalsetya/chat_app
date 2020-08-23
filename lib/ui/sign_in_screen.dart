import 'package:chat_app/ui/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // controllers textField
  final TextEditingController _emailController =
      TextEditingController(text: 'awal@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'awal123');

  // focusnode
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  //state
  bool _isLoading = false;

  @override
  void initState() {
    //cek user
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final User user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ChatScreen();
        }), (route) => false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailNode.dispose();
    _passwordNode.dispose();

    super.dispose();
  }

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
              controller: _emailController,
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
              controller: _passwordController,
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
                onPressed: _isLoading ? null : _onSignIn,
                child: Text('Masuk'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSignIn() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      setState(() {
        _isLoading = true;
      });
      final UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setState(() {
        _isLoading = false;
      });
      if (credential != null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ChatScreen();
        }), (route) => false);
      }
      print(credential);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }
}
