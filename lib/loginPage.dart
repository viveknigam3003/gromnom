import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'buildApp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.auth);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

/*
 Creating a new enumeration.
 Add new piece of state to tell if: 
 • The user is logging in or,
 • Creating a new account.
 */

enum FormType { login, register }

/*Underscores (_) are used to modify access to "private" 
i.e. not accessible from different files*/

enum AuthStatus { notSignedIn, signedIn }

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  FirebaseUser user;
  AuthStatus authStatus = AuthStatus.notSignedIn;
  String userString;
  var userId;

  @override
  void initState() {
    super.initState();
    //This method checks  the status of the user when we initially start the app
    widget.auth.currentUser().then((userId)
        //This is same as -
        // userId = await widget.auth.currentUser()
        {
      setState(() {
        authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  Future<String> getUserDataString() async {
    userString = await user.toString();
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
      print("login should work");
    });

    String time = DateTime.now().toString();

    Firestore.instance
        .collection("users")
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        print("Old user");
        print('${user.uid}');
        print('${docs.documents[0].data}');
      } else {
        print("New User");
        Firestore.instance
            .collection('users')
            .document('${user.email}')
            .setData(
                {'email': user.email, 'uid': user.uid, 'membersince': time});
      }
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  String _email;
  String _password;
  String _password2;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print(_email);
      print(_password);
      return true;
    } else {
      return false;
    }
  }

  int validatePassword(String p, String p2) {
    if (p != null && p2 != null) if (p == p2) {
      return 0;
    } else {
      return 1;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      //try{
      if (_formType == FormType.login) {
        print("login");
        FirebaseUser newUser =
            await widget.auth.signInWithEmailAndPassword(_email, _password);
        newUser == null
            ? print("Incorrect username or password")
            : setState(() {
                user = newUser;
              });
        _signedIn();
        //userId = null if username and password were incorrect

        print('Signed in: $user');
      } else if (_formType == FormType.register) {
        print("register");
        int x = validatePassword(_password, _password2);
        if (x == 0) {
          FirebaseUser newUser = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          setState(() {
            user = newUser;
          });
          print('Registered user: $user');
        } else {
          null;
        }
      }
    }
  }

  Future<String> awaitLogin() async {
    await AuthStatus.signedIn;
  }

  Future<String> loginWithGoogle() async {
    user = await widget.auth.signInWithGoogle();
    if (user != null) _signedIn();

    print('Registered user: $user');
  }

  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      print("routing to home");
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  List<Widget> title() {
    return [
      new SizedBox(
        height: 100,
      ),
      new Center(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/draftLogo.png'),
              backgroundColor: Colors.transparent,
              radius: 60,
            ),
            new SizedBox(
              height: 20,
            ),
            Text(
              " Welcome to",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'SFDisplay',
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              "Gromnom",
              style: TextStyle(
                color: Color(0xffEAB543),
                fontSize: 45,
                fontFamily: 'SFDisplay',
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
      new SizedBox(
        height: 40,
      ),
    ];
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [
        new TextFormField(
          decoration: InputDecoration(labelText: 'email'),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        new TextFormField(
            decoration: InputDecoration(labelText: 'password'),
            obscureText: true, //for hiding passwords
            validator: (value) =>
                value.isEmpty ? 'Password can\'t be empty' : null,
            onSaved: (value) => _password = value),
        new SizedBox(
          height: 20,
        ),
      ];
    } else {
      return [
        new TextFormField(
          decoration: InputDecoration(labelText: 'email'),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
        ),
        new TextFormField(
            decoration: InputDecoration(labelText: 'password'),
            obscureText: true, //for hiding passwords
            validator: (value) =>
                value.isEmpty ? 'Password can\'t be empty' : null,
            onSaved: (value) => _password = value),
        new TextFormField(
          decoration: InputDecoration(labelText: 'password'),
          obscureText: true, //for hiding passwords
          validator: (value) =>
              !identical(value, _password) ? 'Passwords don\'t match' : null,
          onSaved: (value) => validatePassword(_password, _password2),
        ),
        new SizedBox(
          height: 20,
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        Material(
          borderRadius: BorderRadius.circular(25),
          color: Color(0xffEAB543),
          child: new MaterialButton(
            child: new Text(
              'Login',
              style: TextStyle(
                color: Color(0xfff5f5f5),
                fontSize: 18,
                fontFamily: 'SFDisplay',
                fontWeight: FontWeight.w500,
              ),
            ),
            elevation: 6,
            onPressed: validateAndSubmit, //calls a function validateAndSave
          ),
        ),
        new SizedBox(
          height: 10,
        ),
        Material(
          color: Color(0xffEAB543),
          borderRadius: BorderRadius.circular(25),
          child: new MaterialButton(
            child: new Text(
              'Create an Account',
              style: TextStyle(
                color: Color(0xfff5f5f5),
                fontSize: 18,
                fontFamily: 'SFDisplay',
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: moveToRegister,
            elevation: 6,
          ),
        ),
        new SizedBox(
          height: 10,
        ),
        Container(
          height: 45,
          decoration: BoxDecoration(
            boxShadow: [
              new BoxShadow(
                  color: Color(0xfff5f5f5),
                  offset: new Offset(20.0, 25.0),
                  blurRadius: 35.0,
                  spreadRadius: 1.0)
            ],
          ),
          child: new GoogleSignInButton(
            onPressed: loginWithGoogle,
            borderRadius: 25,
            darkMode: false,
          ),
        )
      ];
    } else if (_formType == FormType.register) {
      return [
        Material(
          color: Color(0xffEAB543),
          borderRadius: BorderRadius.circular(25),
          child: new MaterialButton(
            child: new Text(
              'Create an Account',
              style: TextStyle(
                color: Color(0xfff5f5f5),
                fontSize: 18,
                fontFamily: 'SFDisplay',
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: validateAndSubmit, //calls a function validateAndSave
          ),
        ),
        new FlatButton(
          child: new Text('Already have an account? Login',
              style: TextStyle(color: Color(0xff7f8c8d))),
          onPressed: moveToLogin,
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: new Container(
                height: 1080,
                color: Color(0xffecf0f1),
                /**So that they dont go to the end and have a padding around them
             * Applies to all the children of this particular container.
             */
                padding: EdgeInsets.all(16),
                child: new Form(
                  /**
               * Declaring this formKey will store the value for the form
               * for validation.
              */
                  key: _formKey,
                  child: new Column(
                    
                    /**To change the position and alignment of the login bar */
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: title() + buildInputs() + buildSubmitButtons(),
                  ),
                )),
          ),
        );
      case AuthStatus.signedIn:
        return new FutureBuilder<String>(
          future: awaitLogin(), // a Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            //if (!snapshot.hasData) return Center(child: Text("Connecting"));

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return null;
              // case ConnectionState.waiting:
              //   return Scaffold(
              //     body: Center(child: new Text('Loading...')),
              //     backgroundColor: Colors.white,
              //   );
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return BuildApp(widget.auth, _signedOut, user);
            }
          },
        );
    }
  }
}
