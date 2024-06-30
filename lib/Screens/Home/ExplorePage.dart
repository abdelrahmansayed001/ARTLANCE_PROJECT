import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Screens/Home/ExplorePageTabs.dart';
import 'package:gp/Screens/Home/SearchResults.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'SettingsPage.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ImagePicker picker = ImagePicker();
  File? pickedImage;
  TextEditingController searchController = TextEditingController();
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> imageResults = [];
  List<Map<String, dynamic>> searchResults = [];
  
  submitSearch() async {
    var parameter = {
      'query': searchController.text,
    };
    var url = Uri.http(
        "10.0.2.2:8080", 'api/v1/clients/search/freelancers', parameter);

    var token = await storage.read(key: 'token');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    searchResults = [];
    var jsonResponse = await jsonDecode(response.body);
    for (int i = 0; i < jsonResponse.length; i++) {
      var name, type,username;
      name = await getNameByID(jsonResponse[i]);
      type = await getTypeByID(jsonResponse[i]);
      username = await getUsernameByID(jsonResponse[i]);
      searchResults.add(
        {
          'id': '${jsonResponse[i]}',
          'name': name,
          'type': type,
          'username': username

        },
      );
    }
  }

  getUsernameByID(String id) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/freelancers/$id');
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    var username = await jsonResponse['username'];
    return username;
  }


  getNameByID(String id) async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/freelancers/$id");
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    var name = await jsonResponse['fullName'];
    return name;
  }

  getTypeByID(String id) async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/freelancers/$id");
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    var type = await jsonResponse['freelancerType'];
    return type;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 75,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: CupertinoSearchTextField(
                    controller: searchController,
                    padding: const EdgeInsets.all(10.0),
                    placeholder: 'Search..',
                    itemColor: Colors.black,
                    onSubmitted: (str) async {
                      submitSearch();
                      Future.delayed(const Duration(seconds: 2)).then(
                        (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SearchResults(searchResults: searchResults),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(left: 5.0),
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed(SettingsPage.routeName);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Expanded(child: ExplorePageTabs()),
        ],
      ),
    );
  }
}
