import 'package:CAC2020/screens/home/center.dart';
import 'package:CAC2020/screens/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  TextStyle headerStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25);

  GoogleMapController _controller;
  Position position;
  Widget _child;

  Future<void> getPermission() async {
    if (await Permission.location.request().isDenied) {
      await Permission.location.request();
    }
  }

  getCurrentLocation() async {
    return getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // setState(() {
    //   latData = geoposition.latitude.toString();
    //   longData = geoposition.longitude.toString();
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  Future<List<dynamic>> getData() async {
    List<dynamic> data = [];

    Position pos = await getCurrentPosition();

    data.add(pos);

    return data;
  }

  GoogleMapController controller;

  Set<Marker> finalMarkers = {};

  setMarkers(GoogleMapController controller) async {
    this.controller = controller;
    List<Marker> markers = [];
    QuerySnapshot documents =
        await Firestore.instance.collection("centers").getDocuments();
    List<DocumentSnapshot> docs = documents.documents;

    for (DocumentSnapshot i in docs) {
      double lat = i.data["lat"];

      double long = i.data["long"];
      markers.add(Marker(
        markerId: MarkerId(i.documentID),
        position: LatLng(lat, long),
        onTap: () {
          setState(() {
            double index = double.parse(i.documentID + ".0") - 1;
            scrollController.jumpTo(
                scrollController.position.maxScrollExtent * index / 4.0);
            // scrollController.jumpTo(double.parse(i.documentID + ".0") - 1);
          });
        },
        infoWindow: InfoWindow(
            title: i.data["centerName"],
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CenterPage(i.data, i.documentID, 1)));
            }),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }

    setState(() {
      finalMarkers = Set<Marker>.of(markers);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: CustomDrawer(),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getData(),
        builder: (contest, data) {
          if (data.data != null) {
            print(data.data.first.latitude.toString() +
                " " +
                data.data.first.longitude.toString());
            return Stack(children: [
              GoogleMap(
                  onMapCreated: setMarkers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        data.data.first.latitude, data.data.first.longitude),
                    zoom: 11,
                  ),
                  markers: finalMarkers),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                        icon: Icon(Icons.menu),
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Text("Explore", style: headerStyle)),
                      buildFloatingSearchBar(context),
                    ],
                  ),
                ),
              ),
              // color: Colors.white,
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                      child: Text("Centers near you",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        // color: Colors.white,
                        padding: EdgeInsets.all(5),
                        width: double.infinity,
                        height: 150,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('centers')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                controller: scrollController,
                                itemCount: snapshot.data.documents.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => CenterPage(
                                                snapshot
                                                    .data.documents[index].data,
                                                snapshot.data.documents[index]
                                                    .documentID,
                                                1))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: centerCard(
                                          snapshot.data
                                              .documents[index]["centerName"]
                                              .toString(),
                                          snapshot.data.documents[index]["city"]
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ))
                  ],
                ),
              ),
            ]);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Widget buildFloatingSearchBar(BuildContext context) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height / 2,
    child: FloatingSearchBar(
      hint: 'Search for a center...',
      showDrawerHamburger: false,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      openAxisAlignment: 0.0,

      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection("centers").getDocuments(),
              builder: (context, data) {
                if (data.hasData) {
                  List<DocumentSnapshot> centers = data.data.documents;
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: autocompCenters(centers));
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        );
      },
    ),
  );
}

List<Widget> autocompCenters(List<DocumentSnapshot> data) {
  List<Widget> widgets = [];
  for (var i in data) {
    widgets.add(ListTile(
      title: Text(i.data["centerName"]),
    ));
  }
  return widgets;
}

Widget centerCard(String centerName, String centerLoc) {
  return Container(
    padding: EdgeInsets.all(10),
    width: 225,
    height: 120,
    decoration: BoxDecoration(
      // image: DecorationImage(image: AssetImage("background.jpg")),
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(centerName,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(centerLoc, style: TextStyle(color: Colors.grey, fontSize: 15)),
      ],
    ),
  );
}
