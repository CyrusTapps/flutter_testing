import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> posts = [];

  Future<void> fetchPosts() async {
    print('Starting fetchPosts function...'); // Terminal log
    debugPrint('Starting fetchPosts function...'); // Flutter debug log

    try {
      print('Making HTTP request...');
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      print('Response received with status: ${response.statusCode}');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        print(
            'Successfully decoded JSON data. Found ${decodedData.length} posts');
        print('First post title: ${decodedData[0]['title']}');

        setState(() {
          posts = decodedData;
          print('State updated with new posts');
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred during fetch: $e');
      debugPrint('Error stack trace: ${StackTrace.current}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Placeholder Posts'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: fetchPosts,
            child: const Text('Fetch Posts'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(post['title']),
                    subtitle: Text(post['body']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
