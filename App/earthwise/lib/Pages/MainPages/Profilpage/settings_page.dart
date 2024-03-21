import 'package:flutter/material.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Datenbank/db.dart';
import 'package:earthwise/Server/internet.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Pages/Login/authentication.dart';
import 'package:earthwise/Server/webapi.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late User user;
  List<String> nameOfVariable = [];
  List<TextEditingController> pwdControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  TextEditingController controller = TextEditingController();
  late List<String> variable;
  late List<Widget> settings;
  String curPWD = "";
  String repPWD = "";

  @override
  Widget build(BuildContext context) {
    nameOfVariable = [
      "E-Mail",
      "Username",
      "Password",
    ];
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    variable = [
      user.mail,
      user.username,
      changePWToStars(8),
    ];
    settings = [
      SizedBox(height: MediaQuery.of(context).size.height * 0.012),
      ...variable.asMap().entries.map((entry) {
        int idx = entry.key;
        String value = entry.value;
        return settingItem(nameOfVariable[idx], value, idx);
      }).toList(),
      logoutButton(context),
      deleteAccountButton(),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, mainRoute, arguments: 3);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
      ),
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
        child: ListView.builder(
          itemCount: settings.length,
          itemBuilder: (context, index) => settings[index],
        ),
      ),
    );
  }

  /// Widget for displaying individual setting items.
  Widget settingItem(String title, String value, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        subtitle: Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        trailing: index == 0
            ? null
            : IconButton(
                iconSize: 30,
                icon: const Icon(Icons.edit,
                    color: Color.fromARGB(255, 152, 0, 163)),
                onPressed: () async {
                  if (await hasInternetConnection()) {
                    Navigator.pushNamed(context, changeUserRoute,
                        arguments: index);
                  } else {
                    noInternetPopUp(context, "Missing Internet connection!",
                        "You need a Internet-Connection to change your Data!");
                  }
                },
              ),
      ),
    );
  }

  /// Widget for logout button.
  Widget logoutButton(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: const Color.fromARGB(255, 255, 153, 0),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          leading: const Icon(Icons.logout, color: Colors.white),
          title: const Text("Logout",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          onTap: () {
            AuthService.signOut();
            Navigator.pushReplacementNamed(context, loginRoute);
          },
        ),
      ),
    );
  }

  /// Widget for delete account button.
  Widget deleteAccountButton() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.white),
          title: const Text("Delete Account",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          onTap: () async {
            deleteUserValidation(context);
          },
        ),
      ),
    );
  }

  /// Function for deleting the user.
  void deleteUserButton() async {
    if (await deleteUser(user.mail, user.password) == null) {
      DatabaseHelper.instance.deleteDb();
      AuthService.signOut();
      Navigator.pushReplacementNamed(context, loginRoute);
    }
  }

  /// Function for showing delete user confirmation dialog.
  Future deleteUserValidation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Deleting User",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text("Do you really want to delete your User?"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => deleteUserButton(),
                  child: const Text('Delete user'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Function to change password to asterisks.
  String changePWToStars(int pwLength) {
    String result = "";
    for (int i = 0; i < pwLength; i++) {
      result += "*";
    }
    return result;
  }
}
