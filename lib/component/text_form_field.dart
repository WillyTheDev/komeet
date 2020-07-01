import 'package:Komeet/component/background_gradient.dart';
import 'package:flutter/material.dart';

import 'package:email_validator/email_validator.dart';

class TextFieldEmail extends StatelessWidget {
  final Function onChanged;
  TextFieldEmail({@required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) {
            return "Please Enter something";
          } else if (EmailValidator.validate(value) == false) {
            return "E-mail is badly formated";
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: Colors.blueAccent,
            ),
            hintText: "E-mail",
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(width: 4.0, color: Colors.blueAccent)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2.0, color: Colors.red)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(width: 1.0, color: Colors.blueAccent))),
      ),
    );
  }
}

class TextFieldUsername extends StatefulWidget {
  final Function onChanged;
  IconData icon;
  TextFieldUsername({@required this.onChanged, @required this.icon});

  @override
  _TextFieldUsernameState createState() => _TextFieldUsernameState();
}

class _TextFieldUsernameState extends State<TextFieldUsername> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return "Please Enter something";
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      onChanged: widget.onChanged,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
          suffixIcon: Icon(
            widget.icon,
            color: widget.icon == Icons.clear
                ? Colors.grey
                : widget.icon == Icons.check_circle
                    ? Colors.green
                    : widget.icon == Icons.warning ? Colors.red : Colors.white,
          ),
          hintText: "Username",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(width: 4.0, color: Colors.blueAccent)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Colors.red)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(width: 1.0, color: Colors.blueAccent))),
    );
  }
}

class TextFieldPassword extends StatelessWidget {
  final Function onChanged;
  TextFieldPassword({@required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: TextFormField(
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty) {
            return "Please Enter something";
          } else if (value.length < 8) {
            return "Password is too short, 8 characters min.";
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.go,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.blueAccent,
            ),
            hintText: "Enter Password",
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(width: 4.0, color: Colors.blueAccent)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2.0, color: Colors.red)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(width: 1.0, color: Colors.blueAccent))),
      ),
    );
  }
}

class TextFieldConfirmPassword extends StatelessWidget {
  final Function onChanged;
  TextFieldConfirmPassword({@required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: TextFormField(
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty) {
            return "Please Enter something";
          } else if (value.length < 8) {
            return "Password is too short, 8 characters min.";
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.go,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.blueAccent,
            ),
            hintText: "Confirm Password",
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(width: 4.0, color: Colors.blueAccent)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2.0, color: Colors.red)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(width: 1.0, color: Colors.blueAccent))),
      ),
    );
  }
}
