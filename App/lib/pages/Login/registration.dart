import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:maestro/Models/user.dart';
import 'package:maestro/Server/db.dart';
import 'package:maestro/Server/internet.dart';
import 'package:maestro/Server/user_provider.dart';
import 'package:maestro/Server/webapi.dart';
import 'package:maestro/pages/Login/authentication.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool validPassword2 = true;
  bool validUsername = true;
  bool validMail = true;
  List<String> passwordError = [];
  String username = "";
  String password = "";
  String rePassword = "";
  String mail = "";
  bool errors = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    return Material(
      child: Scaffold(
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
                          const Text(
                            "Registration",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "New here?",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(height: 50),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: validMail
                                          ? const EdgeInsets.only(left: 20)
                                          : const EdgeInsets.only(
                                              left: 20, bottom: 15),
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        validator: (value) {
                                          if (!validMail) {
                                            return "Dieses Feld muss @ enthalten!";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            mail = value;
                                            checkMail();
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Mail",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: validUsername
                                          ? const EdgeInsets.only(left: 20)
                                          : const EdgeInsets.only(
                                              left: 20, bottom: 15),
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        validator: (value) {
                                          if (!validUsername) {
                                            return "Dieses Feld muss min. 2 Zeichen enthalten!";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            username = value;
                                            checkUsername();
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Username",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: passwordError.isEmpty
                                        ? const EdgeInsets.only(left: 20)
                                        : const EdgeInsets.only(
                                            left: 20, bottom: 15),
                                    child: TextFormField(
                                      autovalidateMode: AutovalidateMode.always,
                                      validator: (value) {
                                        if (passwordError.isNotEmpty) {
                                          String errors = "";
                                          for (int i = 0;
                                              i < passwordError.length;
                                              i++) {
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
                                        hintText: "Password",
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
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: validPassword2
                                        ? const EdgeInsets.only(left: 20)
                                        : const EdgeInsets.only(
                                            left: 20, bottom: 15),
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
                                        hintText: "Repeat Password",
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
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: GestureDetector(
                              onTap: () {
                                checkRegistration();
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
                                child: const Card(
                                  margin: EdgeInsets.all(0),
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                      ),
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
                guestWidget("Login"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget guestWidget(String name) {
    return Column(
      children: [
        const Text(
          "Not a member?",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            width: double.infinity,
            height: 65,
            margin: const EdgeInsets.only(
              bottom: 16,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, // Startpunkt des Verlaufs
                end: Alignment.bottomRight, // Endpunkt des Verlaufs
                colors: [
                  Colors.pink,
                  Colors.purple,
                ],
              ), // Farbe des Buttons
              borderRadius: BorderRadius.circular(
                20,
              ), // Rundung der Ecken
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      playAsGuest(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.all(20)),
                    child: const Text(
                      "Play as Guest",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, loginRoute);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(20)),
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void playAsGuest(BuildContext context) {
    AuthService.signOut();
    Navigator.pushReplacementNamed(context, mainRoute);
  }

  void checkPassword() {
    passwordError = [];

    if (password.length < 8) {
      passwordError.add("Das Passwort muss min. 8 Zeichen lang sein");
    }
    if (!containsUpperCase(password)) {
      passwordError.add("Das Passwort muss min. 1 Großbuchstaben haben");
    }

    if (!password.contains(RegExp(r'\d'))) {
      passwordError.add("Das Passwort muss min. 1 Zahl haben");
    }
    if (!password.contains(RegExp(r'[!@#\$%^&*()_+,-./:;<=>?@[\]^_`{|}~]'))) {
      passwordError.add("Das Passwort muss min. 1 Sonderzeichen haben");
    }
  }

  bool containsUpperCase(String str) {
    final hasUpperCase = RegExp(r'[A-Z]');
    return hasUpperCase.hasMatch(str);
  }

  void checkRePassword() {
    validPassword2 = true;
    if (rePassword != password) {
      validPassword2 = false;
      errors = true;
    }
  }

  void checkMail() {
    validMail = true;
    if (!mail.contains('@')) {
      validMail = false;
      errors = true;
    }
  }

  void checkUsername() {
    validUsername = true;
    if (username.length < 2) {
      validUsername = false;
      errors = true;
    }
  }

  String hashPassword(String password) {
    // Encodes the password string into UTF-8 bytes.
    var bytes = utf8.encode(password);
    // Computes the SHA-256 hash of the password bytes and converts it to a string.
    return sha256.convert(bytes).toString();
  }

  void checkRegistration() async {
    if (await hasInternetConnection()) {
      setState(() {
        errors = false;
        checkPassword();
        checkMail();
        checkRePassword();
        checkUsername();
      });
      checkPassword();
      if (passwordError.isEmpty && !errors) {
        password = hashPassword(password);
        String? message = await createUser(mail, username, password);
        if (message == null) {
          password = hashPassword(password);
          var newUser = User(
              mail: mail, password: password, username: username, score: 0);
          await DatabaseHelper.instance.insertUser(newUser);
          userProvider.setUser(newUser);
          AuthService.signIn();
          Navigator.pushReplacementNamed(context, mainRoute);
        } else {
          noInternetPopUp(context, "Registrierung fehlgeschlagen", message);
        }
      }
    } else {
      noInternetPopUp(context, "Fehlende Internetverbindung",
          "Sie benötigen eine Internetverbindung um sich anzumelden!");
    }
  }
}
