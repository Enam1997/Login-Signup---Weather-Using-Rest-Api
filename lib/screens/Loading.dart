import 'package:accelx/models/weather.dart';
import 'package:accelx/screens/Weather.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:simple_location_picker/simple_location_result.dart';

class Loading extends StatefulWidget {
  final Map<String, dynamic> sendSelectedLocation;
  const Loading(this.sendSelectedLocation);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String apiKey = "1ad9a4351d0e9f5ab30bf0f24ee0ad17";
  SimpleLocationResult arguments;
  getData({lat, lon}) async {
    String latitude = lat == null ? "23.623776" : lat.toString();
    String longitude = lon == null ? "90.500040" : lon.toString();

    Response response = await get(
        "http://api.openweathermap.org/data/2.5/weather?units=metric&lat=$latitude&lon=$longitude&appid=$apiKey");
    Map data = jsonDecode(response.body);

    final Map<String, dynamic> sendData = {"weatherData" : WeatherData.fromJson(data),"selectedLocation": arguments};
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Weather(sendData)),
    );
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () => {
      widget.sendSelectedLocation != null ? getData(lat: widget.sendSelectedLocation["latitude"], lon: widget.sendSelectedLocation["longitude"]) :  getData()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [LottieBuilder.asset("assets/loading.json")],
        ));
  }
}
