import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Datenbank/db.dart';
import 'package:earthwise/Server/internet.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Server/webapi.dart';
import 'package:earthwise/Pages/Login/authentication.dart';
import 'package:earthwise/router/route_constants.dart';
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
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                          const SizedBox(height: 50),
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
                                    : const EdgeInsets.only(
                                        left: 20, bottom: 15),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
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
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: validUsername
                                    ? const EdgeInsets.only(left: 20)
                                    : const EdgeInsets.only(
                                        left: 20, bottom: 15),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.always,
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
                                child: const Center(
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
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
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

// Logs out any current user and navigates to the main route as a guest.
  void playAsGuest(BuildContext context) {
    AuthService.signOut();
    Navigator.pushReplacementNamed(context, mainRoute);
  }

// Validates the password based on length, presence of uppercase letters, numbers, and special characters.
  void checkPassword() {
    passwordError = [];
    if (password.length < 8) {
      passwordError.add("Password must be at least 8 signs long!");
    }
    if (!containsUpperCase(password)) {
      passwordError.add("Password must contain a big letter!");
    }
    if (!password.contains(RegExp(r'\d'))) {
      passwordError.add("Password must contain a number!");
    }
    if (!password.contains(RegExp(r'[!@#\$%^&*()_+,-./:;<=>?@[\]^_`{|}~]'))) {
      passwordError.add("Password must contain a special sign!");
    }
  }

// Checks if the given string contains at least one uppercase letter.
  bool containsUpperCase(String str) {
    final hasUpperCase = RegExp(r'[A-Z]');
    return hasUpperCase.hasMatch(str);
  }

// Validates that the password confirmation matches the original password.
  void checkRePassword() {
    validPassword2 = true;
    if (rePassword != password) {
      validPassword2 = false;
      errors = true;
    }
  }

// Validates the email address to ensure it contains the "@" symbol.
  void checkMail() {
    validMail = true;
    if (!mail.contains('@')) {
      validMail = false;
      errors = true;
    }
  }

// Ensures the username is at least 2 characters long.
  void checkUsername() {
    validUsername = true;
    if (username.length < 2) {
      validUsername = false;
      errors = true;
    }
  }

// Hashes the password using SHA-256.
  String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert password to bytes
    return sha256.convert(bytes).toString(); // Hash bytes and convert to string
  }

// Conducts all checks and attempts user registration if validations pass.
  void checkRegistration() async {
    if (await hasInternetConnection()) {
      setState(() {
        errors = false;
        checkPassword();
        checkMail();
        checkRePassword();
        checkUsername();
      });

      if (passwordError.isEmpty && !errors) {
        password = hashPassword(password);
        String? message = await createUser(mail, username, password);
        if (message == null) {
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
