import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import '../../provider/_index.dart' as provider;
import 'package:provider/provider.dart';

void detailCityWeather(BuildContext context, dynamic item, dynamic cityWeather) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text('${item['name']}'),
          content: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(50),
                ),
                elevation: 4,
                child: Container(
                  // alignment: Alignment.centerLeft,
                  height: height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child:Image.asset(
                  item['cityUrl'],
                  fit: BoxFit.cover,
                )),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text('Nhiệt độ trung bình:'),
                  Spacer(),
                  Text('${cityWeather[0]}°C',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 242, 66, 21)
                  ))
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text('Nhiệt độ thấp nhất:'),
                  Spacer(),
                  Text('${cityWeather[1]}°C',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 242, 66, 21)
                  ),)
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text('Nhiệt độ cao nhất:'),
                  Spacer(),
                  Text('${cityWeather[2]}°C',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 242, 66, 21)
                  ))
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text('Tốc độ gió:'),
                  Spacer(),
                  Text('${cityWeather[5]} km/h',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 242, 66, 21)
                  ))
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text('Mặt trời lên lúc:'),
                  Spacer(),
                  Text(cityWeather[3],
                  style: TextStyle(
                    color: const Color.fromARGB(255, 242, 66, 21)
                  ))
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text('Mặt trời lặn lúc:'),
                  Spacer(),
                  Text(cityWeather[4],
                  style: TextStyle(
                    color: const Color.fromARGB(255, 242, 66, 21)
                  ))
                ],
              ),
            ],
          ),
        );
      });
}
