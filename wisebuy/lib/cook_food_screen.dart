import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CookFoodScreen extends StatefulWidget {
  @override
  _CookFoodScreenState createState() => _CookFoodScreenState();
}

class _CookFoodScreenState extends State<CookFoodScreen> {
  final TextEditingController _whatToCookController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _maleAdultsController = TextEditingController();
  final TextEditingController _femaleAdultsController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void dispose() {
    _whatToCookController.dispose();
    _countryController.dispose();
    _maleAdultsController.dispose();
    _femaleAdultsController.dispose();
    _childrenController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  String _response = '';

  Future<String> sendMessageToChatGpt(String cook, String country, String male,
      String female, String childcnt, String instruct) async {
    Uri uri =
        Uri.parse("https://cook-api-production-fac5.up.railway.app/cook_api");

    Map<String, dynamic> body = {
      "cook": cook,
      "country": country,
      "male": male,
      "female": female,
      "childcnt": childcnt,
      "instruct": instruct
    };

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    Map<String, dynamic> parsedResponse = json.decode(response.body);

    String reply = parsedResponse['event_description'];
    return reply;
  }

  void onSendMessage() {
    String cook = _whatToCookController.text;
    String country = _countryController.text;
    String male = _maleAdultsController.text;
    String female = _femaleAdultsController.text;
    String childcnt = _childrenController.text;
    String instruct = _instructionsController.text;

    sendMessageToChatGpt(cook, country, male, female, childcnt, instruct)
        .then((response) {
      setState(() {
        _response = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _whatToCookController,
                  decoration: InputDecoration(
                    labelText: 'What to cook?',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: 'Your Country?',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _maleAdultsController,
                        decoration: InputDecoration(
                          labelText: 'How many male adults?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _femaleAdultsController,
                        decoration: InputDecoration(
                          labelText: 'How many female adults?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _childrenController,
                        decoration: InputDecoration(
                          labelText: 'How many children?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _instructionsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Any specific Instructions?',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: onSendMessage,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900],
                    ),
                    child: Text('Build AI generated cart'),
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    'Note : Let AI think 5-10 seconds!',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  _response,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
