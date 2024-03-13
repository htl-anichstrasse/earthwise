import 'package:flutter/material.dart';
import 'package:maestro/Models/user.dart';
import 'package:maestro/Server/db.dart';
import 'package:maestro/Server/user_provider.dart';
import 'package:maestro/pages/Login/authentication.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late User user;
  List<String> nameOfVariable = [];
  TextEditingController controller = TextEditingController();
  late List<String> variable;
  late List<Widget> settings;

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
            Navigator.pop(context);
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
                onPressed: () => openPopUpWindow(getPopUpWindow(index), index),
              ),
      ),
    );
  }

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
          onTap: () {
            // Implementieren Sie die Logik zum Löschen des Kontos hier
          },
        ),
      ),
    );
  }

  Widget getPopUpWindow(int index) {
    switch (index) {
      case 1:
        return changeUsernamePopUp();
      case 2:
        return changePasswordPopUp();
    }
    return const Column();
  }

  Future openPopUpWindow(Widget popUpWindow, int index) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.black,
        content: getPopUpContent(popUpWindow, index),
      ),
    );
  }

  Widget getPopUpContent(Widget popUpWindow, int index) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: popUpWindow,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.white, width: 1),
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                            ),
                            color: Colors.black,
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              minimumSize: MaterialStateProperty.all(
                                  const Size.fromHeight(50)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Quit",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.white, width: 1),
                            left: BorderSide(color: Colors.white, width: 1),
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30.0),
                            ),
                            color: Colors.black,
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              minimumSize: MaterialStateProperty.all(
                                  const Size.fromHeight(50)),
                            ),
                            onPressed: () {
                              onSave(index);
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onSave(int index) {
    String value = controller.text;
    user.username = value;

    DatabaseHelper.instance.updateUser(user);
  }

  Widget changeUsernamePopUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Change Username",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        const SizedBox(height: 20, width: double.infinity),
        const Text(
          "New Username",
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: "Username",
              hintStyle: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget changePasswordPopUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Change Password",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Current Password",
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          onSubmitted: (tQuestionController) {},
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "New Password",
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          onSubmitted: (tQuestionController) {},
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Repeat Password",
          style: TextStyle(color: Colors.white),
        ),
        TextField(
          // controller: flagQuestionController,
          onSubmitted: (tQuestionController) {},
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  String changePWToStars(int pwLength) {
    String result = "";
    for (int i = 0; i < pwLength; i++) {
      result += "*";
    }
    return result;
  }
}
