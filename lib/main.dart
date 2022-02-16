import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

Future fetchPeople() async {
  final response = await http.get(
    Uri.parse('https://api.json-generator.com/templates/Xp8zvwDP14dJ/data'),
    // Send authorization headers to the backend.
    headers: {
      "Authorization": "Bearer v3srs6i1veetv3b2dolta9shrmttl72vnfzm220z",
    },
  );

  final responseJson = jsonDecode(response.body);
  return responseJson;
}

var currentLatLng = LatLng(22.302711, 114.177216);

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Map',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SafeArea(
          child: Scaffold(
            body: FutureBuilder(
                future: fetchPeople(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: Text('Loading'));
                    case ConnectionState.none:
                      return Center(child: Text('No Connection'));
                    default:
                      var allData;
                      if (snapshot.hasData) {
                        allData = snapshot.data;
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: FlutterMap(
                            options: MapOptions(
                              center: currentLatLng,
                              zoom: 13.0,
                            ),
                            layers: [
                              TileLayerOptions(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c'],
                                attributionBuilder: (_) {
                                  return Text("© OpenStreetMap contributors");
                                },
                              ),
                              MarkerLayerOptions(
                                markers: [
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: currentLatLng,
                                    builder: (ctx) => Container(
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.redAccent,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: allData.length,
                                  itemBuilder: (context, index) {
                                    // print(
                                    //     allData[index]['location']['latitude']);
                                    // print(allData[index]['location']
                                    //     ['longitude']);
                                    return allData[index] != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              onTap: () => {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      var location = allData[
                                                                  index]
                                                              ['location'] ??
                                                          0.0;
                                                      var lat = location[
                                                              'latitude'] ??
                                                          22.3479143;
                                                      var lng = location[
                                                              'longitude'] ??
                                                          113.698436;
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        setState(() {
                                                          currentLatLng =
                                                              LatLng(lat, lng);
                                                        });
                                                      });
                                                      return Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        ListTile(
                                                                      leading:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              'ID'),
                                                                        ],
                                                                      ),
                                                                      title: Text(
                                                                          allData[index]
                                                                              [
                                                                              '_id']),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        ListTile(
                                                                      leading:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              'Name'),
                                                                        ],
                                                                      ),
                                                                      title: Text(allData[index]['name']
                                                                              [
                                                                              'first'] +
                                                                          ' ' +
                                                                          allData[index]['name']
                                                                              [
                                                                              'last']),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        ListTile(
                                                                      leading:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              'Email'),
                                                                        ],
                                                                      ),
                                                                      title: Text(
                                                                          allData[index]
                                                                              [
                                                                              'email']),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        ListTile(
                                                                      leading:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                              'Location (Lat/Lng)'),
                                                                        ],
                                                                      ),
                                                                      title: Text(lat
                                                                              .toString() +
                                                                          '/' +
                                                                          lng.toString()),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    })
                                              },
                                              leading: CircleAvatar(
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.amberAccent,
                                              ),
                                              title: Text(
                                                allData[index]['name']
                                                        ['first'] +
                                                    ' ' +
                                                    allData[index]['name']
                                                        ['last'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 30, 8, 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('No Data, Refresh App')
                                              ],
                                            ),
                                          );
                                  }))
                        ],
                      );
                  }
                }),
          ),
        ));
  }
}
