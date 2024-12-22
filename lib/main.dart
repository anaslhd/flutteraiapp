import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutteraiapp/Screens/ajouterarticle.page.dart';
import 'package:flutteraiapp/Screens/home.page.dart';
import 'package:flutteraiapp/Screens/login.page.dart';
import 'package:flutteraiapp/Screens/profile.page.dart';
import 'package:flutteraiapp/firebase_options.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform ); // Ensure Firebase is initialized
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      //theme: ThemeData(colorScheme:ColorScheme.fromSeed(seedColor: )),
      debugShowCheckedModeBanner: false,
      title: "emsi ",
      //home: HomePage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home':(context) =>HomePage(),
        '/add':(context)=>AjouterArticlePage(),
        '/profile':(context)=>ProfilePage()
     
      },
    );
  }
}
