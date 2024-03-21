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
  void initState() {
    fetchData();
    super.initState();
  }

  // Checks if User is logged in and if so navigates to the Homepage
  Future<void> fetchData() async {
    await AuthService.isUserLoggedIn().then((value) async {
      if (value) {
        await DatabaseHelper.instance.getUsers().then((value) {
          if (value.isNotEmpty) {
            User u = value[0];
            userProvider.setUser(u);
            Navigator.pushNamed(context, mainRoute);
          }
        });
      }
    });
  }

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
                        const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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

  // Builds the GuestWidet
  Widget guestWidget(String name) {
    return Column(
      children: [
        const Text(
          "Not a member?",
          style: TextStyle(
            fontSize: 17,
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

  // Validates email input format
  void checkMail() {
    validMail = mailController.text.contains(RegExp(r'@'));
  }

  // Validates password based on defined criteria
  void checkPassword() {
    passwordError.clear();
    if (pwdController.text.length < 8) {
      passwordError.add("Password must be at least 8 signs long!");
    }
    if (!containsUpperCase(pwdController.text)) {
      passwordError.add("Password must contain a big letter!");
    }
    if (!pwdController.text.contains(RegExp(r'\d'))) {
      passwordError.add("Password must contain a number!");
    }
    if (!pwdController.text
        .contains(RegExp(r'[!@#\$%^&*()_+,-./:;<=>?@[\]^_`{|}~]'))) {
      passwordError.add("Password must contain a special sign!");
    }
  }

  // Checks if a string contains an uppercase letter
  bool containsUpperCase(String str) {
    return RegExp(r'[A-Z]').hasMatch(str);
  }

  // Verifies login credentials and navigates on successful login
  Future<void> checkLogin(BuildContext context) async {
    if (await hasInternetConnection()) {
      checkPassword();
      checkMail();
      if (mailController.text.isNotEmpty &&
          pwdController.text.isNotEmpty &&
          passwordError.isEmpty) {
        String password = hashPassword(pwdController.text);
        String? message = await loginUser(mailController.text, password);
        if (message == null) {
          await AuthService.signIn();
          var p = await getUserData(mailController.text);
          var newUser = User(
            mail: mailController.text,
            password: password,
            username: p["username"],
            score: p["level"],
          );
          await DatabaseHelper.instance.insertUser(newUser);
          userProvider.setUser(newUser);
          Navigator.pushReplacementNamed(context, mainRoute);
        } else {
          // Show error popup
        }
      }
    } else {
      // Show no internet connection error
    }
  }

  // Hashes the password using SHA-256
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // Logs in a user as a guest
  void playAsGuest(BuildContext context) {
    AuthService.signOut();
    Navigator.pushReplacementNamed(context, mainRoute);
  }
}
