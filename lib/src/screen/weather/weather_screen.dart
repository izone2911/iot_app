// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quanlyhoctap/src/network/lazy_loading_widget.dart';

import '../../provider/_index.dart' show ButtonWeatherProvider, WeatherProvider, AlertData;
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
    fetchWeatherData(selectedDateString);
  }

  Future<void> fetchWeatherData(String date) async {
    setState(() {
      isLoading = true; // Bắt đầu loading
    });

    await weatherProvider.getWeatherDataWithDay(date);
    updateSpots(date);

    setState(() {
      isLoading = false; // Kết thúc loading
    });
  }

/////////////////////////////////////////////////Update Spots Data/////////////////////////////////////////////////
  void updateSpots(String date) {
    final AlertData alertData = Provider.of(context, listen: false);
    alertData.changeAlertDataNoNotify('old', weatherProvider.listItem[date] ?? []);
    
    spotsTemperatureInside = (weatherProvider.listItem[date]
            ?.map((item) {
              if (item['id'] == 'inside') {
                return FlSpot(
                    double.parse(item['timestamp'].substring(11, 13)) +
                        double.parse(item['timestamp'].substring(14, 16)) / 60,
                    item['temperature'].toDouble());
              } else {
                return FlSpot(-60.0, -60.0);
              }
            })
            .where((spot) => spot != FlSpot(-60.0, -60.0))
            .cast<FlSpot>()
            .toSet()
            .toList()) ??
        [];

    spotsHumidityInside = (weatherProvider.listItem[date]
            ?.map((item) {
              if (item['id'] == 'inside') {
                return FlSpot(
                    double.parse(item['timestamp'].substring(11, 13)) +
                        double.parse(item['timestamp'].substring(14, 16)) / 60,
                    item['humidity'].toDouble());
              } else {
                return FlSpot(-60.0, -60.0);
              }
            })
            .where((spot) => spot != FlSpot(-60.0, -60.0))
            .cast<FlSpot>()
            .toSet()
            .toList()) ??
        [];

    spotsTemperatureOutside = (weatherProvider.listItem[date]
            ?.map((item) {
              if (item['id'] == 'outside') {
                return FlSpot(
                    double.parse(item['timestamp'].substring(11, 13)) +
                        double.parse(item['timestamp'].substring(14, 16)) / 60,
                    item['temperature'].toDouble());
              } else {
                return FlSpot(-60.0, -60.0);
              }
            })
            .where((spot) => spot != FlSpot(-60.0, -60.0))
            .cast<FlSpot>()
            .toSet()
            .toList()) ??
        [];

    spotsHumidityOutside = (weatherProvider.listItem[date]
            ?.map((item) {
              if (item['id'] == 'outside') {
                return FlSpot(
                    double.parse(item['timestamp'].substring(11, 13)) +
                        double.parse(item['timestamp'].substring(14, 16)) / 60,
                    item['humidity'].toDouble());
              } else {
                return FlSpot(-60.0, -60.0);
              }
            })
            .where((spot) => spot != FlSpot(-60.0, -60.0))
            .cast<FlSpot>()
            .toSet()
            .toList()) ??
        [];

    spotsTemperatureInside.sort((a, b) => a.x.compareTo(b.x));
    spotsHumidityInside.sort((a, b) => a.x.compareTo(b.x));
    spotsTemperatureOutside.sort((a, b) => a.x.compareTo(b.x));
    spotsHumidityOutside.sort((a, b) => a.x.compareTo(b.x));
    setState(() {});
  }
/////////////////////////////////////////////////Update Spots Data/////////////////////////////////////////////////

/////////////////////////////////////////////////Spots Data/////////////////////////////////////////////////
  List<FlSpot> spotsTemperatureInside = List.generate(8, (index) {
    return const FlSpot(1.0, 1.00);
  });

  List<FlSpot> spotsHumidityInside = List.generate(8, (index) {
    return const FlSpot(1.0, 1.00);
  });

  List<FlSpot> spotsTemperatureOutside = List.generate(8, (index) {
    return const FlSpot(1.0, 1.00);
  });

  List<FlSpot> spotsHumidityOutside = List.generate(8, (index) {
    return const FlSpot(1.0, 1.00);
  });
/////////////////////////////////////////////////Spots Data/////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    weatherProvider = Provider.of(context, listen: false);
    // ignore: unused_local_variable
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Consumer<ButtonWeatherProvider>(
        builder: (context, buttonWeatherProvider, child) {
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
                    selectedDateString =
                        selectedDate.toString().substring(8, 10) +
                            '-' +
                            selectedDate.toString().substring(5, 7) +
                            '-' +
                            selectedDate.toString().substring(0, 4);

                    setState(() {
                      selectedDate = date;
                      selectedDateString = tmp;
                    });
                  },
                  backgroundColor: const Color.fromARGB(255, 147, 198, 240),
                  selectedTileBackgroundColor:
                      const Color.fromARGB(255, 0, 89, 162),
                  monthYearButtonBackgroundColor:
                      const Color.fromARGB(255, 0, 112, 107),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: width,
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  buttonWeatherProvider.getData['button_inside']
                                      ? buttonWeatherProvider
                                          .getData['color_active']
                                      : buttonWeatherProvider
                                          .getData['color_inactive'],
                            ),
                            onPressed: () {
                              if (!buttonWeatherProvider
                                  .getData['button_inside']) {
                                buttonWeatherProvider.addData(
                                    'button_inside', true);
                                buttonWeatherProvider.addData(
                                    'button_outside', false);
                              }
                            },
                            child: Text("Trong nhà",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: buttonWeatherProvider
                                            .getData['button_inside']
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: buttonWeatherProvider
                                            .getData['button_inside']
                                        ? 17
                                        : 14))),
                      ),
                      Container(
                          width: width * 0.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.only(left: 5, right: 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonWeatherProvider
                                        .getData['button_outside']
                                    ? buttonWeatherProvider
                                        .getData['color_active']
                                    : buttonWeatherProvider
                                        .getData['color_inactive'],
                              ),
                              onPressed: () {
                                if (!buttonWeatherProvider
                                    .getData['button_outside']) {
                                  buttonWeatherProvider.addData(
                                      'button_outside', true);
                                  buttonWeatherProvider.addData(
                                      'button_inside', false);
                                }
                              },
                              child: Text("Ngoài trời",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: buttonWeatherProvider
                                              .getData['button_outside']
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: buttonWeatherProvider
                                              .getData['button_outside']
                                          ? 17
                                          : 14)))),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                isLoading == true
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
//////////////////////////////////Chart Inside/////////////////////////////////////////////
                spotsTemperatureInside.length == 0 &&
                        isLoading == false &&
                        buttonWeatherProvider.getData['button_inside']
                    ? Text("Không có dữ liệu ngày $selectedDateString")
                    : SizedBox.shrink(),

                spotsTemperatureInside.length != 0 &&
                        isLoading == false &&
                        buttonWeatherProvider.getData['button_inside']
                    ? Container(
                        width: width,
                        height: 470, // giảm bé nếu bị tràn viền
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 211, 231, 248),
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(children: [
                            SizedBox(height: 10),
                            Text(
                              "Biểu đồ nhiệt độ trong nhà",
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 130, 74),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: height * 0.3,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 194, 221, 244),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
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
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          topTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  interval: 1,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return Text(
                                                        '${value.toInt()} h');
                                                  })),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: const Border(
                                            
                                            bottom: BorderSide(
                                                width: 2,
                                                color: Colors
                                                    .black), // Đường trục X
                                          ),
                                        ),
                                        gridData: const FlGridData(show: true),
                                        lineBarsData: [

                                          LineChartBarData(
                                            spots: spotsTemperatureInside,
                                            isCurved: true,
                                            color: Colors.red,
                                            dotData: FlDotData(
                                              show: true, // Hiển thị các điểm
                                              getDotPainter: (spot, percent,
                                                  barData, index) {
                                                return FlDotCirclePainter(
                                                  radius: 6,
                                                  color: const Color.fromARGB(255, 255, 17, 0),
                                                  strokeWidth: 2,
                                                  strokeColor: Colors.white,
                                                );
                                              },
                                            ),
                                            belowBarData:
                                                BarAreaData(show: true),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Biểu đồ độ ẩm trong nhà",
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 130, 74),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: height * 0.3,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 194, 221, 244),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
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
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          topTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  interval: 1,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return Text(
                                                        '${value.toInt()} h');
                                                  })),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: const Border(
                                            // Đường trục Y
                                            bottom: BorderSide(
                                                width: 2,
                                                color: Colors
                                                    .black), // Đường trục X
                                          ),
                                        ),
                                        gridData: const FlGridData(show: true),
                                        lineBarsData: [

                                          LineChartBarData(
                                            spots: spotsHumidityInside,
                                            isCurved: true,
                                            color: Colors.red,
                                            dotData: FlDotData(
                                              show: true, // Hiển thị các điểm
                                              getDotPainter: (spot, percent,
                                                  barData, index) {
                                                return FlDotCirclePainter(
                                                  radius: 6,
                                                  color: Colors.red,
                                                  strokeWidth: 2,
                                                  strokeColor: Colors.white,
                                                );
                                              },
                                            ),
                                            belowBarData:
                                                BarAreaData(show: true),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ]),
                        ),
                      )
                    : SizedBox.shrink(),

//////////////////////////////////Chart Inside/////////////////////////////////////////////
///
///
//////////////////////////////////Chart Outside/////////////////////////////////////////////
                spotsTemperatureOutside.length == 0 &&
                        isLoading == false &&
                        buttonWeatherProvider.getData['button_outside']
                    ? Text("Không có dữ liệu ngày $selectedDateString")
                    : SizedBox.shrink(),

                spotsTemperatureOutside.length != 0 &&
                        isLoading == false &&
                        buttonWeatherProvider.getData['button_outside']
                    ? Container(
                        width: width,
                        height: 470,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 211, 231, 248),
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(children: [
                            SizedBox(height: 10),
                            Text(
                              "Biểu đồ nhiệt độ ngoài trời",
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 130, 74),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: height * 0.3,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 194, 221, 244),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
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
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          topTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  interval: 1,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return Text(
                                                        '${value.toInt()} h');
                                                  })),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: const Border(
                                            // Đường trục Y
                                            bottom: BorderSide(
                                                width: 2,
                                                color: Colors
                                                    .black), // Đường trục X
                                          ),
                                        ),
                                        gridData: const FlGridData(show: true),
                                        lineBarsData: [

                                          LineChartBarData(
                                            spots: spotsTemperatureOutside,
                                            isCurved: true,
                                            color: Colors.red,
                                            dotData: FlDotData(
                                              show: true, // Hiển thị các điểm
                                              getDotPainter: (spot, percent,
                                                  barData, index) {
                                                return FlDotCirclePainter(
                                                  radius: 6,
                                                  color: Colors.red,
                                                  strokeWidth: 2,
                                                  strokeColor: Colors.white,
                                                );
                                              },
                                            ),
                                            belowBarData:
                                                BarAreaData(show: true),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Biểu đồ độ ẩm ngoài trời",
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 130, 74),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: height * 0.3,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 194, 221, 244),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
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
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          topTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return const Text('');
                                                  })),
                                          bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  interval: 1,
                                                  getTitlesWidget:
                                                      (value, meta) {
                                                    return Text(
                                                        '${value.toInt()} h');
                                                  })),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: const Border(
                                            // Đường trục Y
                                            bottom: BorderSide(
                                                width: 2,
                                                color: Colors
                                                    .black), // Đường trục X
                                          ),
                                        ),
                                        gridData: const FlGridData(show: true),
                                        lineBarsData: [

                                          LineChartBarData(
                                            spots: spotsHumidityOutside,
                                            isCurved: true,
                                            color: Colors.red,
                                            dotData: FlDotData(
                                              show: true, // Hiển thị các điểm
                                              getDotPainter: (spot, percent,
                                                  barData, index) {
                                                return FlDotCirclePainter(
                                                  radius: 6,
                                                  color: Colors.red,
                                                  strokeWidth: 2,
                                                  strokeColor: Colors.white,
                                                );
                                              },
                                            ),
                                            belowBarData:
                                                BarAreaData(show: true),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ]),
                        ),
                      )
                    : SizedBox.shrink(),
//////////////////////////////////Chart Outside/////////////////////////////////////////////

              ],
            ),
          ));
    });
  }
}
