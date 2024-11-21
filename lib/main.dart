import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'loginScreen.dart';
import 'home.dart';
import 'RegistrationScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase for web or other platforms
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyAqY-fX6OQOfOeDtdLpWVKoZaJhha1bcx0",
          authDomain: "weatherapp-d2af4.firebaseapp.com",
          projectId: "weatherapp-d2af4",
          storageBucket: "weatherapp-d2af4.appspot.com", // Corrected storage bucket URL
          messagingSenderId: "646958215349",
          appId: "1:646958215349:web:aab2c71d99d9262180cefc",
          measurementId: "G-2JYXG1MR1K",
        ),
      );
    } else {
      await Firebase.initializeApp(); // For mobile platforms
    }
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegistrationScreen(),
          '/home': (context) => HomeScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue, // Define a consistent theme
        ),
        );
    }
}
