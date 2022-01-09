import 'package:accelx/login.dart';
import 'package:accelx/models/weather.dart';
import 'package:accelx/screens/Loading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_location_picker/simple_location_picker_screen.dart';
import 'package:simple_location_picker/simple_location_result.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Weather extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const Weather(this.arguments);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  WeatherData weather;
  SimpleLocationResult selectedLocation;
  Map<String, dynamic> sendSelectLocation;

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Map arguments = ModalRoute.of(context).settings.arguments;
    weather = widget.arguments["weatherData"];
    selectedLocation = widget.arguments["selectedLocation"];

    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Loading(sendSelectLocation)),
        );
        return null;
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  padding: EdgeInsets.all(12),
                  color: Colors.black,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    weather.name,
                                    style: GoogleFonts.lato(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    DateFormat("EEE, d LLL")
                                        .format(DateTime.now()),
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  double latitude = selectedLocation != null
                                      ? selectedLocation.latitude
                                      : 23.623776;
                                  double longitude = selectedLocation != null
                                      ? selectedLocation.longitude
                                      : 90.500040;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SimpleLocationPicker(
                                                initialLatitude: latitude,
                                                initialLongitude: longitude,
                                                appBarTitle: "Select Location for Weather",
                                                zoomLevel: 7,
                                                appBarColor: Colors.black,
                                                markerColor: Colors.black,
                                              ))).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedLocation = value;
                                        // Navigator.pushReplacementNamed(
                                        //     context, "/loading",
                                        //     arguments: selectedLocation);
                                       sendSelectLocation = {"latitude" : selectedLocation.latitude.toString(),"longitude": selectedLocation.longitude.toString()};
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Loading(sendSelectLocation)),
                                        );
                                      });
                                    }
                                  });
                                })
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: Column(children: [
                          Transform.scale(
                              scale: 1.6,
                              child: SvgPicture.asset(
                                  "assets/svgs/${weather.icon}.svg")),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                weather.temperature.toString(),
                                style: GoogleFonts.lato(
                                  fontSize: 65,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "°C",
                                style: GoogleFonts.lato(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Text(
                            weather.condition,
                            style: GoogleFonts.lato(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Feels like ${weather.feelsLike}°C",
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  FontAwesome5Solid.eye,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text("Visibility",
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                "${weather.visibility} km",
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  Ionicons.ios_water,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text("Humidity",
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                "${weather.humidity}%",
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  FontAwesome5Solid.wind,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text("Wind Speed",
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                "${weather.windSpeed.floor()} km/hr",
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15.0)),
                    child: Text(
                      "LogOut",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: Color(0xffe0061e),
                    onPressed: () {
                      signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login()),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
