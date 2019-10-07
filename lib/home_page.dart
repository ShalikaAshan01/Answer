import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'auth.dart';
import 'auth_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userId;
  BaseAuth auth;

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      Fluttertoast.showToast(msg: 'Signed out');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        setState(() {
          userId = user.uid;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Text(
            userId == null ? 'Loading...': 'Welcome $userId',
            style: TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }
}
