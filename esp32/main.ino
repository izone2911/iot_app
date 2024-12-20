#include "secrets.h"
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "WiFi.h"
#include "time.h"
#include "DHT.h"

#define DHTPIN 4      // Digital pin connected to the DHT sensor
#define DHTTYPE DHT11 // DHT 11
#define AWS_IOT_PUBLISH_TOPIC "esp32/pub"

// NTP server to request epoch time
const char *ntpServer = "pool.ntp.org";

// Variable to save current epoch time
unsigned long epochTime;

// Function that gets current epoch time
unsigned long getTime()
{
    time_t now;
    struct tm timeinfo;
    if (!getLocalTime(&timeinfo))
    {
        // Serial.println("Failed to obtain time");
        return (0);
    }
    time(&now);
    return now;
}

float h; // humidity
float t; // temperature

// batch between each publish
int time_batch = 300000;

// time counter
int time_counter = 0;

// Object definition
DHT dht(DHTPIN, DHTTYPE);
WiFiClientSecure net = WiFiClientSecure();
PubSubClient client(net);

void connectAWS()
{
    // connect to WiFi
    WiFi.mode(WIFI_STA);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.println("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }
    Serial.println("Connected to Wi-Fi");

    // Configure WiFiClientSecure to use the AWS IoT device credentials
    net.setCACert(AWS_CERT_CA);
    net.setCertificate(AWS_CERT_CRT);
    net.setPrivateKey(AWS_CERT_PRIVATE);

    // Connect to the MQTT broker on the AWS endpoint we defined earlier
    client.setServer(AWS_IOT_ENDPOINT, 8883);

    // Create a message handler
    client.setCallback(messageHandler);
    Serial.println("Connecting to AWS IOT");
    while (!client.connect(THINGNAME))
    {
        Serial.print(".");
        delay(100);
    }
    if (!client.connected())
    {
        Serial.println("AWS IoT Timeout!");
        return;
    }

    // Subscribe to topics
    client.subscribe("check_outside");
    client.subscribe("change_time_outside");
    client.subscribe("home_request");

    Serial.println("AWS IoT Connected!");
}

void publishWeather()
{
    // Get data
    h = dht.readHumidity();
    t = dht.readTemperature();
    if (isnan(h) || isnan(t)) // Check if any reads failed and exit early (to try again).
    {
        Serial.println(F("Failed to read from DHT sensor!"));
        return;
    }

    StaticJsonDocument<200> doc;
    int randomValue1 = random(1, 3);
    int randomValue2 = random(1, 3);
    float adjustedTemperature = t + randomValue1;
    float adjustedHumidity = h + randomValue2;

    doc["id"] = "outside"; // esp32_outside
    doc["humidity"] = adjustedHumidity;
    doc["temperature"] = adjustedTemperature;

    epochTime = getTime();
    struct tm *timeinfo;
    timeinfo = localtime((time_t *)&epochTime);
    char formattedTime[25];
    sprintf(formattedTime, "%02d-%02d-%04d %02d:%02d:%02d",
            timeinfo->tm_mday,
            timeinfo->tm_mon + 1,
            timeinfo->tm_year + 1900,
            (timeinfo->tm_hour + 7) % 24,
            timeinfo->tm_min,
            timeinfo->tm_sec);

    doc["timestamp"] = formattedTime;

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer); // print to client
    client.publish(AWS_IOT_PUBLISH_TOPIC, jsonBuffer);

    Serial.print(formattedTime);
    Serial.print(" Id: outside ");
    Serial.print("Humidity: ");
    Serial.print(adjustedHumidity);
    Serial.print("%  Temperature: ");
    Serial.print(adjustedTemperature);
    Serial.println("°C");
}

void publishCheck()
{
    StaticJsonDocument<200> doc;
    char time_batch_str[10];
    sprintf(time_batch_str, "%d", time_batch);

    doc["running"] = true;
    doc["time"] = time_batch_str;

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer);
    client.publish("outside_running", jsonBuffer);
}

void publishChanged()
{
    StaticJsonDocument<200> doc;
    char time_batch_str[10];
    sprintf(time_batch_str, "%d", time_batch);

    doc["change_time"] = time_batch_str;

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer);
    client.publish("outside_changed", jsonBuffer);
}

void publishHomeWeather()
{
    // Get data
    h = dht.readHumidity();
    t = dht.readTemperature();
    if (isnan(h) || isnan(t)) // Check if any reads failed and exit early (to try again).
    {
        Serial.println(F("Failed to read from DHT sensor!"));
        return;
    }

    StaticJsonDocument<200> doc;
    int randomValue1 = random(1, 3);
    int randomValue2 = random(1, 3);
    float adjustedTemperature = t + randomValue1;
    float adjustedHumidity = h + randomValue2;

    doc["id"] = "outside"; // esp32_outside
    doc["humidity"] = adjustedHumidity;
    doc["temperature"] = adjustedTemperature;

    epochTime = getTime();
    struct tm *timeinfo;
    timeinfo = localtime((time_t *)&epochTime);
    char formattedTime[25];
    sprintf(formattedTime, "%02d-%02d-%04d %02d:%02d:%02d",
            timeinfo->tm_mday,
            timeinfo->tm_mon + 1,
            timeinfo->tm_year + 1900,
            (timeinfo->tm_hour + 7) % 24,
            timeinfo->tm_min,
            timeinfo->tm_sec);

    doc["timestamp"] = formattedTime;

    char jsonBuffer[512];
    serializeJson(doc, jsonBuffer); // print to client
    client.publish("esp32/pub_home_outside", jsonBuffer);

    Serial.print(formattedTime);
    Serial.print(" Id: outside ");
    Serial.print("Humidity: ");
    Serial.print(adjustedHumidity);
    Serial.print("%  Temperature: ");
    Serial.print(adjustedTemperature);
    Serial.println("°C");
}

void messageHandler(char *topic, byte *payload, unsigned int length)
{
    Serial.print("incoming: ");
    Serial.println(topic);

    StaticJsonDocument<200> doc;
    deserializeJson(doc, payload);
    // const char* message = doc["message"];
    // Serial.println(message);

    if (strcmp(topic, "check_outside") == 0)
    {
        publishCheck();
        Serial.println("Status: Healthy");
    }
    else if (strcmp(topic, "change_time_outside") == 0)
    {
        time_batch = atoi(doc["change_time"]);
        Serial.print("New time_batch set to: ");
        Serial.println(time_batch);
        publishChanged();
    }
    else if (strcmp(topic, "home_request") == 0)
    {
        publishHomeWeather();
    }
}

void setup()
{
    Serial.begin(115200);
    connectAWS();
    dht.begin();
    configTime(0, 0, ntpServer);
    randomSeed(analogRead(2));
}

void loop()
{
    time_counter += 1000;
    Serial.println(time_counter);
    if (time_counter == time_batch)
    {
        publishWeather();
        time_counter = 0;
    }
    client.loop();
    delay(1000);
}