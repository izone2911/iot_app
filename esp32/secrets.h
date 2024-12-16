#include <pgmspace.h>

#define SECRET
#define THINGNAME "your-thing-name" // change this

const char WIFI_SSID[] = "your-wifi-ssid";               // change this
const char WIFI_PASSWORD[] = "your-wifi-password";       // change this
const char AWS_IOT_ENDPOINT[] = "your-aws-iot-endpoint"; // change this

// Amazon Root CA 1
static const char AWS_CERT_CA[] PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----

-----END CERTIFICATE-----
)EOF";

// Device Certificate
static const char AWS_CERT_CRT[] PROGMEM = R"KEY(
-----BEGIN CERTIFICATE-----

-----END CERTIFICATE-----
)KEY";

// Device Private Key
static const char AWS_CERT_PRIVATE[] PROGMEM = R"KEY(
-----BEGIN RSA PRIVATE KEY-----

-----END RSA PRIVATE KEY-----
)KEY";