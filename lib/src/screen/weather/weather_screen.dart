// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanlyhoctap/src/network/lazy_loading_widget.dart';

import '../../provider/_index.dart' show WeatherProvider;
import '../../network/network_widget.dart';
import 'package:clean_calendar/clean_calendar.dart';
import 'package:calendar_slider/calendar_slider.dart';
import 'package:fl_chart/fl_chart.dart';

// class WeatherScreen extends StatelessWidget {
//   WeatherScreen({super.key});

//   late WeatherProvider weatherProvider;

//   @override
//   Widget build(BuildContext context) {
//     weatherProvider = Provider.of(context, listen: false);

//     return NetworkWidget<WeatherProvider>(
//       onReload: () => weatherProvider.getWeatherDataWithDay("08-12-2024"),
//       child: Scaffold(
//         bottomNavigationBar: ElevatedButton(
//           onPressed: () => weatherProvider.getWeatherDataWithDay("08-12-2024"),
//           child: const Text("Press Me!"),
//         ),
//         body: Center(
//           child: ListView.builder(
//             itemCount: weatherProvider.listItem["08-12-2024"]?.length != null ? (weatherProvider.listItem["08-12-2024"]?.length) : 0,
//             itemBuilder: (context, index) => Container(
//               height: 140,
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 // mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     '$index  : Thời gian',
//                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     weatherProvider.listItem["08-12-2024"]![index].timestamp,
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                   Text(
//                     'Nhiệt độ: ${weatherProvider.listItem["08-12-2024"]![index].temperature.toString()}°C',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     'Độ ẩm: ${weatherProvider.listItem["08-12-2024"]![index].humidity.toString()}%',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore: must_be_immutable

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late WeatherProvider weatherProvider;

  DateTime selectedDate = DateTime.now();

  String selectedDateString = DateTime.now().toString().substring(8, 10) +
      '-' +
      DateTime.now().toString().substring(5, 7) +
      '-' +
      DateTime.now().toString().substring(0, 4);

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedDateString = DateTime.now().toString().substring(8, 10) +
        '-' +
        DateTime.now().toString().substring(5, 7) +
        '-' +
        DateTime.now().toString().substring(0, 4);
    weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    // weatherProvider
    //     .getWeatherDataWithDay(selectedDateString);

    fetchWeatherData(selectedDateString);
  }

  Future<void> fetchWeatherData(String date) async {
    setState(() {
      isLoading = true; // Bắt đầu loading
    });

    await weatherProvider.getWeatherDataWithDay(date);
    updateSpots(date);

    setState(() {
      isLoading = false; // Bắt đầu loading
    });
  }

  void updateSpots(String date) {
    spotsTemperature = (weatherProvider.listItem[date]?.map((item) {
          print(item['humidity'].toDouble().runtimeType);
          print(double.parse(item['timestamp'].substring(11, 13)) * 3600 +
              double.parse(item['timestamp'].substring(14, 16)) * 60 +
              double.parse(item['timestamp'].substring(17, 19)));
          return FlSpot(
              double.parse(item['timestamp'].substring(11, 13) + "." + item['timestamp'].substring(14, 16)),
              item['humidity'].toDouble()
              );
          // double.parse(item['timestamp'].substring(11,13))*60*60+double.parse(item['timestamp'].substring(14,16))*60+double.parse(item['timestamp'].substring(17,19))
        }).toList()) ??
        [];
    setState(() {}); // Cập nhật trạng thái
  }

  List<FlSpot> spotsTemperature = List.generate(8, (index) {
    return const FlSpot(1.0, 1.00);
  });

  @override
  Widget build(BuildContext context) {
    weatherProvider = Provider.of(context, listen: false);
    // ignore: unused_local_variable
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
      child: Column(
        children: [
          CalendarSlider(
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 100)),
            lastDate: DateTime.now().add(const Duration(days: 100)),
            onDateSelected: (date) async {
              String tmp = date.toString().substring(8, 10) +
                  '-' +
                  date.toString().substring(5, 7) +
                  '-' +
                  date.toString().substring(0, 4);
              await fetchWeatherData(tmp);

              selectedDate = date;
              selectedDateString = selectedDate.toString().substring(8, 10) +
                  '-' +
                  selectedDate.toString().substring(5, 7) +
                  '-' +
                  selectedDate.toString().substring(0, 4);

              setState(() {
                // spots = (weatherProvider.listItem[tmp]?.map((item) {
                //       return FlSpot(item['humidity'].toDouble(),
                //           item['temperature'].toDouble());
                //     }).toList()) ??
                //     [];

                selectedDate = date;
                selectedDateString = tmp;
              });
            },
            backgroundColor: const Color.fromARGB(255, 147, 198, 240),
            selectedTileBackgroundColor: const Color.fromARGB(255, 0, 89, 162),
            monthYearButtonBackgroundColor:
                const Color.fromARGB(255, 0, 112, 107),
          ),

          const SizedBox(height: 20),
          isLoading == true
              ? const CircularProgressIndicator()
              : const SizedBox.shrink(),

          weatherProvider.listItem[selectedDateString]?.length == 0 &&
                  isLoading == false
              ? Text(
                  'Không có dữ liệu ngày $selectedDateString', // Hiển thị ngày
                  style: const TextStyle(fontSize: 18),
                )
              : const SizedBox.shrink(),

          const SizedBox(height: 20),
          Expanded(
            child: weatherProvider.listItem[selectedDateString]?.length != 0 &&
                    isLoading == false
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(5),
                    // height: height * 0.5,
                    child: Container(
                      height: 300,
                      width: 2000,
                      child: LineChart(
                        LineChartData(
                          baselineX: 0,
                          baselineY: 0,
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return const Text('');
                                    })),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return const Text('');
                                    })),
                            // bottomTitles: AxisTitles(
                            //     sideTitles: SideTitles(
                            //         showTitles: true,
                            //         reservedSize: 40,
                            //         getTitlesWidget: (value, meta) {
                            //           return Text('${value.toString()}');
                            //         })),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              left: BorderSide(
                                  width: 2,
                                  color: Colors.black), // Đường trục Y
                              bottom: BorderSide(
                                  width: 2,
                                  color: Colors.black), // Đường trục X
                            ),
                          ),
                          gridData: const FlGridData(show: true),
                          lineBarsData: [
                            // The red line
                            LineChartBarData(
                              spots: spotsTemperature,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ))
                : const SizedBox.shrink(),
          ),


          const SizedBox(height: 20),
          Expanded(
            child: weatherProvider.listItem[selectedDateString]?.length != 0 &&
                    isLoading == false
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(5),
                    // height: height * 0.5,
                    child: Container(
                      height: 300,
                      width: 2000,
                      child: LineChart(
                        LineChartData(
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return const Text('');
                                    })),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return const Text('');
                                    })),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Text('${(value/3600).toInt()}:');
                                    })),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              left: BorderSide(
                                  width: 2,
                                  color: Colors.black), // Đường trục Y
                              bottom: BorderSide(
                                  width: 2,
                                  color: Colors.black), // Đường trục X
                            ),
                          ),
                          gridData: const FlGridData(show: true),
                          lineBarsData: [
                            // The red line
                            LineChartBarData(
                              spots: spotsTemperature,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ))
                : const SizedBox.shrink(),
          )



          // const SizedBox(height: 20),
          // weatherProvider.listItem[selectedDateString]?.length != 0 && isLoading == false
          //     ?
          //     SafeArea(
          //         child: Container(
          //         padding: const EdgeInsets.all(5),
          //         height: height * 0.5,
          //         child: LineChart(
          //           LineChartData(
          //             titlesData: FlTitlesData(
          //               rightTitles: AxisTitles(
          //                   sideTitles: SideTitles(
          //                       showTitles: true,
          //                       reservedSize: 40,
          //                       getTitlesWidget: (value, meta) {
          //                         return const Text('');
          //                       })),
          //               topTitles: AxisTitles(
          //                   sideTitles: SideTitles(
          //                       showTitles: true,
          //                       reservedSize: 40,
          //                       getTitlesWidget: (value, meta) {
          //                         return const Text('');
          //                       })),
          //               bottomTitles: AxisTitles(
          //                   sideTitles: SideTitles(
          //                       showTitles: true,
          //                       reservedSize: 40,
          //                       getTitlesWidget: (value, meta) {
          //                         return Text('${value/36000}');
          //                       })),
          //             ),
          //             borderData: FlBorderData(
          //               show: true,
          //               border: const Border(
          //                 left: BorderSide(
          //                     width: 2, color: Colors.black), // Đường trục Y
          //                 bottom: BorderSide(
          //                     width: 2, color: Colors.black), // Đường trục X
          //               ),
          //             ),
          //             gridData: const FlGridData(show: true),
          //             lineBarsData: [
          //               // The red line
          //               LineChartBarData(
          //                 spots: spotsTemperature,
          //                 isCurved: true,
          //                 barWidth: 3,
          //                 color: Colors.red,
          //               ),
          //             ],
          //           ),
          //         ),
          //       )
          //     )
          //     :const SizedBox.shrink(),
        ],
      ),
    ));
  }
}
