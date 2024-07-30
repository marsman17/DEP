import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart'; // Added WebView import
import 'model.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    theme: ThemeData.dark(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Model> list = <Model>[];
  String? text;
  final url =
      "https://api.edamam.com/search?q=chicken&app_id=fe93e6c4&app_key=15096a11746e0d011d51e11037ec4cc3&from=0&to=100&calories=591-722&health=alcohol-free";

  Future<void> getApiData(String search) async {
    try {
      var response = await http.get(Uri.parse(search));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        json["hits"].forEach((e) {
          Model model = Model(
            url: e["recipe"]["url"],
            image: e["recipe"]["image"],
            source: e["recipe"]["source"],
            label: e["recipe"]["label"],
          );
          setState(() {
            list.add(model);
          });
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    getApiData(url); // Initial call with default URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text("Recipe")),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (v) {
                  text = v;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (text != null && text!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(search: text!),
                          ),
                        );
                      } else {
                        // Handle case where text is empty
                        print('Search text is empty');
                      }
                    },
                    icon: Icon(Icons.search),
                  ),
                  hintText: "Search for a Recipe",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  fillColor: Colors.green.withOpacity(0.04),
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebPage(
                            url: x.url ??
                                '', // Provide a default empty string if x.url is null
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(x.image.toString()),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                "Source: " + x.source.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebPage extends StatelessWidget {
  final String url;

  WebPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: url.isEmpty ? 'about:blank' : url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  String search;

  SearchPage({required this.search});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Model> list = <Model>[];

  Future<void> getApiData(String search) async {
    try {
      var response = await http.get(Uri.parse(search));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        json["hits"].forEach((e) {
          Model model = Model(
            url: e["recipe"]["url"],
            image: e["recipe"]["image"],
            source: e["recipe"]["source"],
            label: e["recipe"]["label"],
          );
          setState(() {
            list.add(model);
          });
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    getApiData(widget.search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text("Recipe")),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebPage(
                            url: x.url ??
                                '', // Provide a default empty string if x.url is null
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(x.image.toString()),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                "Source: " + x.source.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
