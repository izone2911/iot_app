// ignore_for_file: unused_local_variable, unnecessary_string_escapes

import 'dart:convert';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:calendar_slider/calendar_slider.dart';
import 'package:weather/weather.dart';
import '../../network/network_handler.dart';
import '../../provider/_index.dart' as provider;
import './detail_world_weather.dart';

class WorldWeatherScreen extends StatefulWidget {
  const WorldWeatherScreen({super.key});

  @override
  State<WorldWeatherScreen> createState() => _WorldWeatherScreen();
}

class _WorldWeatherScreen extends State<WorldWeatherScreen> {
  List<dynamic> City = [
    {
      'cityUrl': "assets/images/cao_bang.jpg",
      'city': 'cao bang',
      'name': 'Cao Bằng'
    },
    {
      'cityUrl': "assets/images/ha_giang.jpg",
      'city': 'ha giang',
      'name': 'Hà Giang'
    },
    {
      'cityUrl': "assets/images/ha_long.jpg",
      'city': 'ha long',
      'name': 'Hạ Long'
    },
    {
      'cityUrl': "assets/images/ha_noi_02.jpg",
      'city': 'ha noi',
      'name': 'Hà Nội'
    },
    {
      'cityUrl': "assets/images/hai_phong.jpg",
      'city': 'hai phong',
      'name': 'Hải Phòng'
    },
    {
      'cityUrl': "assets/images/hcm.jpg",
      'city': 'thanh pho ho chi minh',
      'name': 'Thành phố Hồ Chí Minh'
    },
    {'cityUrl': "assets/images/hue_01.jpg", 'city': 'hue', 'name': 'Huế'},
    {
      'cityUrl': "assets/images/lang_son.jpg",
      'city': 'lang son',
      'name': 'Lạng Sơn'
    }
  ];

  static const openWeatherAPIKey = "2d30f5c52ed4aa970791329b3c5c03d1";
  late WeatherFactory ws;
  dynamic cityWeather;
  List<dynamic> valCity = [];

  bool isLoading = false;
/////////////////////////check parse double/////////////////////////
  bool canParseDouble(String value) {
    try {
      double.parse(value);
      return true; 
    } catch (e) {
      return false; 
    }
  }
////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    ws = WeatherFactory(openWeatherAPIKey);
  }

  Future<void> fetchWeatherData(String cityName) async {
    setState(() {
      isLoading = true;
    });

    cityWeather = await ws.currentWeatherByCityName(cityName);
    cityWeather = (cityWeather).toString();
    List<dynamic> tmpValCity = cityWeather.split(RegExp(r'[,\s]+'));
    valCity = [];

    for(int i=0; i<tmpValCity.length; i++){
      if(tmpValCity[i]=="Sunrise:") {
        valCity.add(tmpValCity[i+2].substring(0,8));
      }
      if(tmpValCity[i]=="Sunset:") {
        valCity.add(tmpValCity[i+2].substring(0,8));
      }
      if(tmpValCity[i]=="Temp:") {
        valCity.add(double.parse(tmpValCity[i+1]));
      }
      if(tmpValCity[i]=="(min):") {
        valCity.add(double.parse(tmpValCity[i+1]));
      }
      if(tmpValCity[i]=="(max):") {
        valCity.add(double.parse(tmpValCity[i+1]));
      }
      if(tmpValCity[i]=="speed") {
        String formattedNumber = (double.parse(tmpValCity[i+1])*3.6).toStringAsFixed(2);
        valCity.add(double.parse(formattedNumber));
      }
    }
    print(
        "---------------------------------${tmpValCity.length}--------------------------------");
    print(
        "---------------------------------${valCity}--------------------------------");

    

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Số lượng ảnh trên mỗi hàng
              crossAxisSpacing: 8.0, // Khoảng cách ngang giữa các ảnh
              mainAxisSpacing: 10.0, // Khoảng cách dọc giữa các ảnh
            ),
            itemCount: City.length,
            itemBuilder: (context, index) {
              return Card(
                  child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(
                        City[index]['cityUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(City[index]['name']),
                  ],
                ),
                onTap: () async{
                  await fetchWeatherData(City[index]['city']);
                  print(valCity);
                    detailCityWeather(context, City[index], valCity);
                },
              ));
            },
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
