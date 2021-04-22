import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(
    MaterialApp(
      home: PageOne(),
    ),
  );
}

Future<Response> fetchAlbum() {
  return get(Uri.https('api.sampleapis.com', 'futurama/info'));
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Response>(
          future: fetchAlbum(),
          builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.toString());
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
