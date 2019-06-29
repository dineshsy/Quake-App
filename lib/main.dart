import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';


void main() async {
  Map _data = await getQuakes();
  List _features= _data['features'];
   print(_data['features'][0]['properties']['place']);
  runApp(MaterialApp(
      home: Scaffold(
    appBar: AppBar(
      title: Text("Quakes"),
      backgroundColor: Colors.redAccent,
      centerTitle: true,
    ),
    body: Center(
        child: ListView.builder(
      itemCount: _features.length,
      padding: EdgeInsets.all(15.9),

      itemBuilder: (BuildContext context, int position) {

        var format = new DateFormat.yMMMd("en_US").add_jm();

        DateTime date = new DateTime.fromMillisecondsSinceEpoch(1486252500000,isUtc: true);
        var dateString = format.format(date);

        if (position.isOdd){
          return new Divider(height: 9.1,color: Colors.blueAccent,);
        }
        return Column(
          children: <Widget>[


            ListTile(
              title: Text("$dateString",
              style: TextStyle(
                fontWeight: FontWeight.w800
              ),),
              subtitle:  Text(" ${_features[position]['properties']['place']}"),
              leading: CircleAvatar(
                child: Text("${_features[position]['properties']['mag']}"),
              ),
              onTap: ()=>showOnTap(context,"Type:${_features[position]['properties']['type'].toString().toUpperCase()}"),
            ),
          ],
        );
      },
    )),
  )));
}
void showOnTap(BuildContext context,String s){

  var alert= AlertDialog(
    title: Text("Quakes"),
    content: Text(s),
    actions: <Widget>[
      FlatButton(onPressed: ()=> Navigator.pop(context), child: Text("OK"))
    ],
  );
  showDialog(context: context,builder:(context){
   return alert;
  });

}

Future<Map> getQuakes() async {
  String apiURL =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiURL);
  return json.decode(response.body);
}
