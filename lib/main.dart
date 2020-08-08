import 'dart:convert';

//import 'package:autocomplete/backendservice.dart';
import 'package:autocomplete/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("TypeHead App"),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: true,
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontStyle: FontStyle.italic),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'What are you looking for?'),
              ),
              suggestionsCallback: (pattern) async {
              // Here you can call http call

                print("Pattern:$pattern");


                if (pattern.length == 3) {
//                  return await BackendService.getSuggestions(pattern);
//                return await Future List<List> getUsers(pattern);
                return await loadUsers(pattern);
                }else{
                  return null;
                }


              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                );
              },
              onSuggestionSelected: (suggestion) {
// This when someone click the items
                print(suggestion);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<List<User>> loadUsers(String jsonString) async {

    var users = [];
    try {
      final response = await http.get("https://jsonplaceholder.typicode.com/users");
      if (response.statusCode == 200) {
        users = json.decode(response.body).cast<Map<String, dynamic>>();
        print('Users: ${users.length}');
//        return users.map<User>((json) => User.fromJson(json)).toList();
        setState(() {
//          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }

    return users.map<User>((json) => User.fromJson(json)).toList();
  }


}