import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    MaterialApp(
      home: PageOne(),
    ),
  );
}

class Info {
  final int id;
  final List<Creator> creators;

  Info(this.id, this.creators);

  factory Info.fromJson(Map<String, dynamic> json) {
    final creators = <Creator>[];
    final jsonCreators = json['creators'] as List;
    for (int i = 0; i < jsonCreators.length; i++) {
      final creator = Creator.fromJson(jsonCreators[i]);
      creators.add(creator);
    }
    return Info(
      json['id'],
      creators,
    );
  }
}

class Creator {
  final String name;

  Creator(this.name);

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      json['name'],
    );
  }
}

Future<Info> fetchAlbum() async {
  final response = await get(Uri.https('api.sampleapis.com', 'futurama/info'));
  final list = jsonDecode(response.body) as List;
  return Info.fromJson(list[0]);
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Info>(
          future: fetchAlbum(),
          builder: (BuildContext context, AsyncSnapshot<Info> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.creators.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(snapshot.data.creators[index].name),
                      FlatButton(
                          onPressed: () {
                            launch("https://www.google.pl");
                          },
                          child: Text("Click me"))
                    ],
                  );
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
