import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pantry_app/app/landing_page.dart';
import 'package:pantry_app/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Pantry App',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const LandingPage(),
      ),
    );
  }
}
