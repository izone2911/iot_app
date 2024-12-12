class WeatherModel {
  double temperature, humidity;
  String timestamp,id;

  WeatherModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        temperature = json['temperature'],
        humidity = json['humidity'],
        timestamp = json['timestamp'];
}

class WeatherData {
  static final Map<String, List<WeatherModel>> _map = {};

  static Map<String, List<WeatherModel>> get map => _map;

  static void addWeatherItem(String key, dynamic item) {
    if (_map.containsKey(key)) {
      _map[key]!.add(item);
    } else {
      _map[key] = [item];
    }
  }
}