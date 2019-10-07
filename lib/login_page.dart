import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_register_2/auth_provider.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  String _firstname;
  String _surname;
  FormType _formType = FormType.login;

  final formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });
    if (validateAndSave()) {
      try {
        final BaseAuth auth = AuthProvider.of(context).auth;
        if (_formType == FormType.login) {
          final String userId =
              await auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
          Fluttertoast.showToast(msg: 'Signed in');
        } else {
          final String userId = await auth.createUserWithEmailAndPassword(
              _email, _password, _firstname, _surname);
          print('Account created: $userId');
          Fluttertoast.showToast(msg: 'User registered');
        }
      } catch (e) {
        print('Error: $e');
        Fluttertoast.showToast(msg: '$e');
      }
    }
  }

  void changeToRegister() {
    formKey.currentState.reset();

    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      _formType = FormType.register;
    });
  }

  void changeToLogin() {
    formKey.currentState.reset();

    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) =>
                value.isEmpty ? 'Email can\'t be blank' : null,
            onSaved: (value) => _email = value.trim(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            key: passKey,
            obscureText: true,
            decoration: InputDecoration(labelText: "Password"),
            validator: (value) {
              var result = value.length < 4
                  ? "Password should have at least 4 characters"
                  : null;
              return result;
            },
            onSaved: (value) => _password = value.trim(),
          ),
        ),
      ];
    } else {
      return [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('firstname'),
            decoration: InputDecoration(labelText: 'Firstname'),
            validator: (value) =>
                value.isEmpty ? 'First name can\'t be blank' : null,
            onSaved: (value) => _firstname = value.trim(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('surname'),
            decoration: InputDecoration(labelText: 'Surname'),
            validator: (value) =>
                value.isEmpty ? 'Surname can\'t be blank' : null,
            onSaved: (value) => _surname = value.trim(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) =>
                value.isEmpty ? 'Email can\'t be blank' : null,
            onSaved: (value) => _email = value.trim(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            key: passKey,
            obscureText: true,
            decoration: InputDecoration(labelText: "Password"),
            validator: (value) {
              var result = value.length < 8
                  ? "Password should have at least 8 characters"
                  : null;
              return result;
            },
            onSaved: (value) => _password = value.trim(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(labelText: "Confirm Password"),
            validator: (confirmation) {
              if (confirmation != passKey.currentState.value) {
                return 'Passwords do not match';
              } else {
                return null;
              }
            },
            onSaved: (value) => _password = value.trim(),
          ),
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            color: Colors.brown[300],
            child: Text(
              'LOGIN',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: validateAndSubmit,
          ),
        ),
        FlatButton(
          child: Text(
            'Register',
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: changeToRegister,
        )
      ];
    } else {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            color: Colors.brown[300],
            child: Text(
              'REGISTER',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: validateAndSubmit,
          ),
        ),
        FlatButton(
          child: Text(
            'Already have an account? Login',
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: changeToLogin,
        )
      ];
    }
  }
}
