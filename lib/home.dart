import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'weather.dart';
import 'firestore.dart';
import 'weather_dis.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> favoriteCities = []; // List of favorite cities

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst); // Go back to login screen
  }

  Future<void> _loadFavoriteCities() async {
    final user = _auth.currentUser;

    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['favoriteCities'] != null) {
          setState(() {
            favoriteCities = List<Map<String, dynamic>>.from(data['favoriteCities']);
          });
        }
      }
    }
  }

  Future<void> _saveFavoriteCity(Map<String, dynamic> cityData) async {
    final user = _auth.currentUser;

    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);

      await userDoc.set({
        'favoriteCities': FieldValue.arrayUnion([cityData]),
      }, SetOptions(merge: true));

      setState(() {
        favoriteCities.add(cityData);
      });
    }
  }

  void _navigateToWeatherScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => WeatherScreen()),
    );

    // Add city to favorites if "Favorite This City" is pressed
    if (result != null) {
      _saveFavoriteCity(result);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFavoriteCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Your Favorite Cities",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: favoriteCities.isNotEmpty
                    ? ListView.builder(
                  itemCount: favoriteCities.length,
                  itemBuilder: (context, index) {
                    final cityData = favoriteCities[index];
                    return Card(
                      child: ListTile(
                        title: Text(cityData['city']),
                        subtitle: Text(
                          "Temperature: ${cityData['temperature']}°C\nCondition: ${cityData['condition']}",
                        ),
                      ),
                    );
                  },
                )
                    : Center(
                  child: Text(
                    "No favorite cities yet.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _navigateToWeatherScreen,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    "Check Weather",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        );
    }
}
