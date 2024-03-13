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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool validMail = true;

  final TextEditingController mailController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  List<String> passwordError = [];
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
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
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Welcome back!",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        const SizedBox(height: 75),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: validMail
                                  ? const EdgeInsets.only(left: 20)
                                  : const EdgeInsets.only(left: 20, bottom: 15),
                              child: TextFormField(
                                controller: mailController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "E-Mail"),
                                autovalidateMode: AutovalidateMode.always,
                                validator: (value) {
                                  if (!validMail) {
                                    return "Dieses Feld muss @ enthalten!";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    mailController.text = value;
                                    checkMail();
                                  });
                                },
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
                                      String errors = "";
                                      for (int i = 0;
                                          i < passwordError.length;
                                          i++) {
                                        errors += passwordError[i];
                                        if (i < passwordError.length - 1) {
                                          errors += "\n";
                                        }
                                      }
                                      if (errors != "") {
                                        return errors;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        pwdController.text = value;
                                        checkPassword();
                                      });
                                    },
                                    obscureText: hidePassword,
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
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: hidePassword
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
                          child: GestureDetector(
                            onTap: () {
                              checkLogin(context);
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
                              child: const Center(
                                child: Text(
                                  "Login",
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
                      ],
                    ),
                  ),
                ),
              ),
              guestWidget("Register"),
              const SizedBox(height: 20),
            ],
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
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                        Navigator.pushReplacementNamed(
                            context, registrationRoute);
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

  void checkMail() {
    validMail = true;

    if (!mailController.text.contains(RegExp(r'@'))) {
      validMail = false;
    }
  }

  void checkPassword() {
    passwordError = [];
    if (pwdController.text.length < 8) {
      passwordError.add("Das Passwort muss min. 8 Zeichen lang sein");
    }
    if (!containsUpperCase(pwdController.text)) {
      passwordError.add("Das Passwort muss min. 1 Großbuchstaben haben");
    }
    if (!pwdController.text.contains(RegExp(r'\d'))) {
      passwordError.add("Das Passwort muss min. 1 Zahl haben");
    }
    if (!pwdController.text
        .contains(RegExp(r'[!@#\$%^&*()_+,-./:;<=>?@[\]^_`{|}~]'))) {
      passwordError.add("Das Passwort muss min. 1 Sonderzeichen haben");
    }
  }

  bool containsUpperCase(String str) {
    final hasUpperCase = RegExp(r'[A-Z]');
    return hasUpperCase.hasMatch(str);
  }

  Future<void> checkLogin(BuildContext context) async {
    User newUser =
        User(username: "Luca", password: "idk", mail: "@d", score: 999);
    await DatabaseHelper.instance.insertUser(newUser);
    userProvider.setUser(newUser);
    AuthService.signIn();

    Navigator.pushReplacementNamed(context, mainRoute);
    if (await hasInternetConnection()) {
      setState(() {
        checkPassword();
        checkMail();
      });

      if (mailController.text.isNotEmpty &&
          pwdController.text.isNotEmpty &&
          passwordError.isEmpty) {
        String password = hashPassword(pwdController.text);

        String? message = await loginUser(mailController.text, password);
        if (message == null) {
          AuthService.signIn();
          var p = await getUserData(mailController.text);
          var newUser = User(
            mail: mailController.text,
            password: pwdController.text,
            username: p["username"],
            score: p["level"],
          );
          await DatabaseHelper.instance.insertUser(newUser);
          userProvider.setUser(newUser);
          Navigator.pushReplacementNamed(context, mainRoute);
        } else {
          noInternetPopUp(context, "Login Fehlgeschlagen", message);
        }
      }
    } else {
      noInternetPopUp(context, "Fehlende Internetverbindung",
          "Sie benötigen eine Internetverbindung um sich anzumelden!");
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Daten in Byte umwandeln
    return sha256.convert(bytes).toString();
  }

  void playAsGuest(BuildContext context) {
    AuthService.signOut();
    Navigator.pushReplacementNamed(context, mainRoute);
  }
}
