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
  final String synopsis;
  final String yearsAired;

  Info(this.id, this.creators, this.synopsis, this.yearsAired);

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
      json['synopsis'],
      json['yearsAired'],
    );
  }
}

class Creator {
  final String name;
  final String url;

  Creator(this.name, this.url);

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      json['name'],
      json['url'],
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data.synopsis,
                    style: TextStyle(
                      fontFamily: "Roboto",
                    ),
                  ),
                  Text(snapshot.data.yearsAired),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.creators.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Text(snapshot.data.creators[index].name),
                          FlatButton(
                              onPressed: () {
                                launch(snapshot.data.creators[index].url);
                              },
                              child: Text("Click me")),
                        ],
                      );
                    },
                  ),
                  Text(snapshot.data.id.toString()),
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
