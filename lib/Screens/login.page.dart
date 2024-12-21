import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _keyform = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passvisble = false;

  Future<void> SignIn() async {
    print("SignIn method started");

    if (_keyform.currentState == null || !_keyform.currentState!.validate()) {
      print("Form validation failed");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please correct the errors in the form.")),
      );
      return;
    }

    print("Form validation passed, showing dialog");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      print("Attempting Firebase sign-in with email: ${_emailController.text.trim()}");

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.of(context).pop(); // Close the loading dialog

      print("Firebase sign-in successful");

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful")),
        );
        Navigator.pushReplacementNamed(context,'/home');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      print("FirebaseAuthException: ${e.code}");
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = "No user found for that email";
          print("Aucun utilisateur avec ce login");
          break;
        case 'wrong-password':
          message = "Wrong password provided";
          print("mot de passe erroné");
          break;
        default:
          message = "An error occurred. Please try again.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      print("Unexpected error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred.")),
      );
    }
  }

  String? _validatoremail(String? value) {
    if (value == null || value.isEmpty)
      return 'Veuillez Saisir votre login';
    final _emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    final regexp = RegExp(_emailPattern);
    if (!regexp.hasMatch(value)) return 'Entrer un email de login valide';
    return null;
  }

  String? _validatorpwd(String? value) {
    if (value == null || value.isEmpty) return 'Entrer un Password';
    if (value.length < 6) return 'Entrez au moins 6 caracteres';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Anas Clothing App",
            style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _keyform,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.purple, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              // Email TextField
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Login',
                  labelStyle: TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.red),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validatoremail,
              ),
              SizedBox(height: 20),

              // Password TextField
              TextFormField(
                obscureText: !_passvisble,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.red),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passvisble = !_passvisble;
                      });
                    },
                    icon: Icon(_passvisble
                        ? Icons.visibility
                        : Icons.visibility_off, color: Colors.red),
                  ),
                ),
                validator: _validatorpwd,
              ),
              SizedBox(height: 30),

              // SignIn Button
              ElevatedButton(
                onPressed: () {
                  SignIn();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
                ),
                child: const Text(
                  "Se connecter",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
