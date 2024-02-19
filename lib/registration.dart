import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_launch_ecommerce/constants.dart';
import 'package:my_launch_ecommerce/login_screen.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String? name, phone, address, username, password;
  final GlobalKey<FormState> _regformkey = GlobalKey<FormState>();

  //registration function and api call
  registration(String name, phone, address, username, password) async {
    final Map<String, dynamic> loginData = {
      'name': name,
      'phone': phone,
      'address': address,
      'username': username,
      'password': password
    };

    final response = await http.post(
      Uri.parse("http://bootcamp.cyralearnings.com/registration.php"),
      body: loginData,
    );

    // ignore: avoid_print
    print(response.statusCode);

    if (response.statusCode == 200) {
      if (response.body.contains("success")) {
        // ignore: avoid_print
        print("Registration successfully completed");
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }));
      } else {
        // ignore: avoid_print
        print("registration failed");
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Register Account",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const Text("Complete your details \n"),
              const SizedBox(
                height: 20,
              ),
              Form(
                  key: _regformkey,
                  child: Column(
                    children: [
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
                                name = text;
                                // ignore: avoid_print
                                print(name);
                              },
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration.collapsed(
                                  hintText: "Name"),
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter your name";
                                }
                              },
                            )),
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
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                phone = text;
                                // ignore: avoid_print
                                print(phone);
                              },
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration.collapsed(
                                  hintText: "Phone Number"),
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter your phone number";
                                } else if (value.length > 10 ||
                                    value.length < 10) {
                                  return "Please enter valid phone number";
                                }
                              },
                            )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 244, 242, 242),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Center(
                                child: TextFormField(
                              maxLines: 4,
                              onChanged: (text) {
                                address = text;
                                // ignore: avoid_print
                                print(address);
                              },
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration.collapsed(
                                  hintText: "Address"),
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter your address";
                                }
                              },
                            )),
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
                                username = text;
                                // ignore: avoid_print
                                print(username);
                              },
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration.collapsed(
                                  hintText: "Username"),
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter your username";
                                }
                              },
                            )),
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
                                // ignore: avoid_print
                                print(password);
                              },
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration.collapsed(
                                  hintText: "password"),
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter your password";
                                }
                              },
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: maincolor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                if (_regformkey.currentState!.validate()) {
                                  // ignore: prefer_interpolation_to_compose_strings
                                  log("name is " + name.toString());
                                  registration(name!, phone, address, username,
                                      password);
                                }
                              },
                              child: const Text("Register")),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Do you have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 16,
                          color: maincolor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
