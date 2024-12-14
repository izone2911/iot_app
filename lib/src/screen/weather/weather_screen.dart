// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanlyhoctap/src/network/lazy_loading_widget.dart';

import '../../provider/_index.dart' show WeatherProvider;
import '../../network/network_widget.dart';
import 'package:calendar_slider/calendar_slider.dart';
import 'package:fl_chart/fl_chart.dart';

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
          return FlSpot(double.parse(item['timestamp'].substring(11, 13)),
              item['temperature'].toDouble());
        }).toList()) ??
        [];

    spotsHumidity = (weatherProvider.listItem[date]?.map((item) {
          return FlSpot(double.parse(item['timestamp'].substring(11, 13)),
              item['humidity'].toDouble());
        }).toList()) ??
        [];

    spotsTemperature.sort((a, b) => a.x.compareTo(b.x));
    spotsHumidity.sort((a, b) => a.x.compareTo(b.x));
    setState(() {}); // Cập nhật trạng thái
  }

  List<FlSpot> spotsTemperature = List.generate(8, (index) {
    return const FlSpot(1.0, 1.00);
  });

  List<FlSpot> spotsHumidity = List.generate(8, (index) {
    return const FlSpot(1.0, 1.00);
  });

  @override
  Widget build(BuildContext context) {
    weatherProvider = Provider.of(context, listen: false);
    // ignore: unused_local_variable
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 231, 246),
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
                    child: SizedBox(
                      height: 300,
                      width: 2000,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 50,
                          minX: 0,
                          maxX: 23,
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
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      return value.toInt()>9? Text('${value.toInt()}:00 h') : Text('0${value.toInt()}:00 h');
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

                            LineChartBarData(
                              spots: spotsTemperature,
                              isCurved: true,
                              color: Colors.red,
                              dotData: FlDotData(
                                show: true, // Hiển thị các điểm
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: Colors.red,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(show: false),
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
                    child: SizedBox(
                      height: 300,
                      width: 2000,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 100,
                          minX: 0,
                          maxX: 23,
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
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      return value.toInt()>9? Text('${value.toInt()}:00 h') : Text('0${value.toInt()}:00 h');
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
                              spots: spotsHumidity,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.red,
                            ),

                            LineChartBarData(
                              spots: spotsHumidity,
                              isCurved: true,
                              color: Colors.red,
                              dotData: FlDotData(
                                show: true, // Hiển thị các điểm
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: Colors.red,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ))
                : const SizedBox.shrink(),
          ),
        ],
      ),
    ));
  }
}
