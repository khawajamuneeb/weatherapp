import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  Map<String, dynamic>? weatherData;

  final String apiKey = 'a74f69dc0f56df8b0e7eaa2440c8b8b5'; // Replace with your OpenWeatherMap API key.

  Future<void> fetchWeather(String city) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
        });
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('City not found!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch weather. Try again later.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching weather: $e')),
      );
    }
  }

  void _addToFavorites() {
    if (weatherData != null) {
      Navigator.pop(context, {
        'city': weatherData!['name'],
        'temperature': weatherData!['main']['temp'],
        'condition': weatherData!['weather'][0]['description'],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Weather Updates"),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: "Enter City Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => fetchWeather(_cityController.text.trim()),
                  child: Text("Check Weather"),
                ),
                SizedBox(height: 20),
                if (weatherData != null) ...[
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Weather in ${weatherData!['name']}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Temperature: ${weatherData!['main']['temp']}°C"),
                          Text("Condition: ${weatherData!['weather'][0]['description']}"),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _addToFavorites,
                            child: Text("Favorite This City"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            ),
        );
    }
}
