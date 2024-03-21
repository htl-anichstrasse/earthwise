import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Datenbank/db.dart';
import 'package:earthwise/Server/internet.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Server/webapi.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';

class ChangeUserPage extends StatefulWidget {
  const ChangeUserPage({super.key, required this.index});

  final int index;

  @override
  State<ChangeUserPage> createState() => _ChangeUserPageState();
}

class _ChangeUserPageState extends State<ChangeUserPage> {
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool validPassword2 = true;
  List<String> passwordError = [];
  bool hideUsername = true;
  String username = "";
  String password = "";
  String rePassword = "";
  String oldPassword = "";
  String usernameError = "";
  final List<String> changeUser = ["Username", "Password"];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User user;

  // The User can change his Username
  Widget changeUsername(int index) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          index == 1
              ? const Text("")
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ListTile(
                      title: const Text("Your current Username",
                          style: TextStyle(fontSize: 16)),
                      subtitle: Text(user.username,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Stack(
                  children: [
                    Padding(
                      padding: usernameError == ""
                          ? const EdgeInsets.only(left: 20)
                          : const EdgeInsets.only(left: 20, bottom: 15),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (usernameError != "") {
                            return usernameError;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            username = value;
                            checkUsername();
                          });
                        },
                        obscureText: index == 0 ? false : hideUsername,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.index == 1
                              ? "New Username"
                              : "Current Password",
                        ),
                      ),
                    ),
                    index == 0
                        ? const Text("")
                        : Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideUsername = !hideUsername;
                                });
                              },
                              icon: hideUsername
                                  ? const Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      Icons.remove_red_eye_sharp,
                                      color: Colors.black,
                                    ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // The User can change his Password

  Widget changePWD() {
    return Column(
      children: [
        changeUsername(1),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Stack(
                children: [
                  Padding(
                    padding: passwordError.isEmpty
                        ? const EdgeInsets.only(left: 20)
                        : const EdgeInsets.only(left: 20, bottom: 15),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (passwordError.isNotEmpty) {
                          String errors = "";
                          for (int i = 0; i < passwordError.length; i++) {
                            errors += passwordError[i];
                            if (i < passwordError.length - 1) {
                              errors += "\n";
                            }
                          }
                          return errors;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
                          checkPassword();
                        });
                      },
                      obscureText: hidePassword1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "New Password",
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword1 = !hidePassword1;
                        });
                      },
                      icon: hidePassword1
                          ? const Icon(
                              Icons.remove_red_eye,
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.remove_red_eye_sharp,
                              color: Colors.black,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Stack(
                children: [
                  Padding(
                    padding: validPassword2
                        ? const EdgeInsets.only(left: 20)
                        : const EdgeInsets.only(left: 20, bottom: 15),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) {
                        if (!validPassword2) {
                          return "Passwords aren't the sasme!";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          rePassword = value;
                          checkRePassword();
                        });
                      },
                      obscureText: hidePassword2,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Repeat new Password",
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword2 = !hidePassword2;
                        });
                      },
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    return Material(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            "Settings",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
          ),
          elevation: 14.0,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 9, 1, 132),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 10, 199, 196),
                Color.fromARGB(255, 4, 2, 104),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Change your ${changeUser[widget.index - 1]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 50),
                          widget.index == 1 ? changeUsername(0) : changePWD(),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: GestureDetector(
                              onTap: () {
                                onSave(widget.index);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 75,
                                margin: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment
                                        .topLeft, // Startpunkt des Verlaufs
                                    end: Alignment
                                        .bottomRight, // Endpunkt des Verlaufs
                                    colors: [
                                      Colors.pink,
                                      Colors.purple,
                                    ],
                                  ), // Farbe des Buttons
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ), // Rundung der Ecken
                                ),
                                child: Center(
                                  child: Text(
                                    "Change ${changeUser[widget.index - 1]}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Handles saving changes based on the selected index (username or password)
  void onSave(int index) {
    switch (index) {
      case 1:
        saveUsername();
        break; // Fixed missing break statement
      case 2:
        savePWD();
        break; // Fixed missing break statement
    }
  }

// Attempts to save the new username after validation
  saveUsername() async {
    checkUsername(); // Validates the new username
    if (usernameError.isEmpty) {
      // Checks if there's no error
      if (await hasInternetConnection()) {
        // Checks internet connectivity
        if (!(await setUsername(user.mail, username, user.password))) {
          // Displays error if the username couldn't be updated
          noInternetPopUp(
              context, "Server Error", "Your Username could not be changed!");
        } else {
          // Updates the username in the local database and UI
          setState(() {
            user.username = username;
            DatabaseHelper.instance.updateUser(user);
          });
          // Navigates to the main page and then to settings
          Navigator.pushNamed(context, mainRoute, arguments: 3);
          Navigator.pushNamed(context, settingsRoute);
        }
      } else {
        // Displays error when there's no internet connection
        noInternetPopUp(context, "No Internet",
            "You need Internet to change your Username");
      }
    }
  }

// Attempts to save the new password after validation
  savePWD() async {
    checkPassword(); // Validates the new password
    checkRePassword(); // Validates the repeated new password
    if (passwordError.isEmpty) {
      // Checks if there's no error
      if (await hasInternetConnection()) {
        // Checks internet connectivity
        String oldPwd = hashPassword(username); // Hashes the old password
        if (oldPwd == user.password) {
          // Verifies the old password
          String newPwd = hashPassword(password); // Hashes the new password
          if (!(await setPWD(user.mail, oldPwd, newPwd))) {
            // Displays error if the password couldn't be updated
            noInternetPopUp(context, "Server Error",
                "Your Password didn't change! Please try it again later.");
          } else {
            // Updates the password in the local database and UI
            setState(() {
              user.password = newPwd;
              DatabaseHelper.instance.updateUser(user);
            });
            Navigator.pop(context); // Returns to the previous page
          }
        } else {
          // Sets error message if the current password is incorrect
          usernameError = "Wrong current Password";
        }
      } else {
        // Displays error when there's no internet connection
        noInternetPopUp(context, "No Internet",
            "You need Internet to change your Password");
      }
    }
  }

// Validates the new password against a set of rules
  void checkPassword() {
    passwordError.clear(); // Clears previous errors
    // Adds an error if the password is less than 8 characters
    if (password.length < 8) {
      passwordError.add("Password must be at least 8 characters long!");
    }
    // Adds an error if the password doesn't contain an uppercase letter
    if (!containsUpperCase(password)) {
      passwordError.add("Password must contain an uppercase letter!");
    }
    // Adds an error if the password doesn't contain a digit
    if (!password.contains(RegExp(r'\d'))) {
      passwordError.add("Password must contain a number!");
    }
    // Adds an error if the password doesn't contain a special character
    if (!password.contains(RegExp(r'[!@#\$%^&*()_+,-./:;<=>?@[\]^_`{|}~]'))) {
      passwordError.add("Password must contain a special character!");
    }
  }

// Checks if a string contains at least one uppercase letter
  bool containsUpperCase(String str) {
    final hasUpperCase = RegExp(r'[A-Z]');
    return hasUpperCase.hasMatch(str);
  }

// Validates the repeated password to ensure it matches the new password
  void checkRePassword() {
    validPassword2 = rePassword == password;
  }

// Validates the new username against a minimum length requirement
  void checkUsername() {
    usernameError = "";
    if (username.length < 2) {
      usernameError = "This field must contain at least 2 characters!";
    }
  }

// Hashes a password using SHA-256
  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Encodes the password to bytes
    return sha256.convert(bytes).toString(); // Returns the hashed password
  }
}
