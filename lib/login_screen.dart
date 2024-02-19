import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_launch_ecommerce/constants.dart';
import 'package:my_launch_ecommerce/homepage.dart';
import 'package:my_launch_ecommerce/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? username, password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedin = prefs.getBool('isLoggedIn') ?? false;
    // ignore: prefer_interpolation_to_compose_strings
    log("isLoggedin=" + isLoggedin.toString());
    if (isLoggedin) {
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return HomePage();
      }));
    }
  }

  //login api call and function
  login(String username, String password) async {
    // ignore: avoid_print
    print(username);

    // ignore: prefer_typing_uninitialized_variables
    var result;

    final Map<String, dynamic> logindatas = {
      'username': username,
      'password': password
    };

    final response = await http.post(
      Uri.parse("http://bootcamp.cyralearnings.com/login.php"),
      body: logindatas,
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      if (response.body.contains("success")) {
        log("login succesfully completed");
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString("username", username);
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      } else {
        log("login failed");
      }
    } else {
      result = {log(json.decode(response.body)["error"].toString())};
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const Text("Login with your username and password \n"),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 244, 242, 242),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: TextFormField(
                          onChanged: (text) {
                            username = text;
                          },
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration.collapsed(
                              hintText: "Username"),
                          // ignore: body_might_complete_normally_nullable
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your name";
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 244, 242, 242),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: TextFormField(
                          onChanged: (text) {
                            password = text;
                          },
                          obscureText: true,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration.collapsed(
                              hintText: "password"),
                          // ignore: body_might_complete_normally_nullable
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your password";
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: maincolor,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          // ignore: prefer_interpolation_to_compose_strings
                          log("name is " + username.toString());
                          login(username!, password!);
                        }
                      },
                      child: const Text("Login"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const RegistrationPage();
                        }));
                      },
                      child: const Text(
                        "Go to Register",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: maincolor),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
