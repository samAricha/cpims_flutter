// main.dart
import 'package:flutter/material.dart';
import 'dart:io'; // for using HttpClient
import 'dart:convert';

import 'api_service.dart'; // for using json.decode()

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Api request',
      home: LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The list that contains information about photos
  List _loadedPhotos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Api requests'),
        ),
        body: SafeArea(
            child: _loadedPhotos.isEmpty
                ? Center(
              child: ElevatedButton(
                onPressed: () async {
                  const apiUrl = 'https://jsonplaceholder.typicode.com/photos';
                  final photos = await ApiService.fetchPhotos(apiUrl);
                  setState(() {
                    _loadedPhotos = photos;
                  });
                },
                child: const Text('Load Photos'),
              ),
            )
            // The ListView that displays photos
                : ListView.builder(
              itemCount: _loadedPhotos.length,
              itemBuilder: (BuildContext ctx, index) {
                return ListTile(
                  leading: Image.network(
                    _loadedPhotos[index]["thumbnailUrl"],
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  title: Text(_loadedPhotos[index]['title']),
                  subtitle:
                  Text('Photo ID: ${_loadedPhotos[index]["id"]}'),
                );
              },
            )));
  }
}




class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}
class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "UserName"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: ()  async {
                      if (_formKey.currentState!.validate()) {
                        // if (usernameController.text == "testhealthit" && passwordController.text == "T3st@987654321") {

                          const loginApiUrl = 'https://dev.cpims.net/api/token/';
                          var username = usernameController.text;
                          var password = passwordController.text;

                          try {
                            final loginData = await ApiService.login(loginApiUrl, username, password);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(loginData.toString()),
                              ),
                            );

                            // Navigator.of(BuildContext as BuildContext).pushReplacement(MaterialPageRoute(
                            //   builder: (context) => HomePage(),
                            // ));
                          } catch (e) {
                            // Handle error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('An error occurred: $e'),
                              ),
                            );
                          }



                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //         content: Text('Invalid Credentials')),
                        //   );
                        // }


                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill input')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}