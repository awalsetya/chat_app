import 'package:chat_app/ui/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageNode = FocusNode();

  final DatabaseReference root = FirebaseDatabase.instance.reference();
  final User user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _messageController.dispose();
    _messageNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference chatReference =
        root.child('/chats/${user.uid}').reference();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          FlatButton.icon(
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return SignInScreen();
              }), (route) => false);
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
            label: Text('Keluar'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: chatReference.onValue,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.active) {
                  final Map<dynamic, dynamic> data =
                      snapshot.data.snapshot.value;

                  if (data != null) {
                    final List<dynamic> chatList = data.values.toList();
                    return ListView.builder(
                      reverse: true,
                      //listview bilder untuk merubah data map menjadi list
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(top: 8.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            chatList[index]['text'].toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        );
                      },
                      itemCount: data.values.length,
                    );
                  }
                }
                return Container();
              },
            )),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _messageNode,
                    decoration: InputDecoration(hintText: 'Masukan pesan'),
                  ),
                ),
                FlatButton.icon(
                  textColor: Colors.blue,
                  onPressed: _onSend,
                  icon: Icon(Icons.send),
                  label: Text('Kirim'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSend() {
    final String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      //kirim ke firebase
      final User sender = FirebaseAuth.instance.currentUser;
      //hardcode
      final String receiver = sender.uid == 'aGNyTV8O4PZTkbHXp2dbYCpWLRm2'
          ? 'CV3QSigyl3cvSe7qXYAujMBaP3J2'
          : 'CV3QSigyl3cvSe7qXYAujMBaP3J2';
      final DatabaseReference chats =
          root.child('/chats/${sender.uid}/chats').reference();
      final String key = chats.push().key;

      root.update({
        //sender
        '/chats/${sender.uid}/chats/$key': {
          'text': message,
          'timestamp': DateTime.now().microsecondsSinceEpoch,
          'from': sender.uid,
        },
        '/chats/${sender.uid}/with': receiver,

        //receiver
        '/chats/${receiver}/chats/$key': {
          'text': message,
          'timestamp': DateTime.now().microsecondsSinceEpoch,
          'from': sender.uid,
        },
        '/chats/${receiver}/with': sender.uid,
      });
      _messageController.clear();
    }
  }
}
