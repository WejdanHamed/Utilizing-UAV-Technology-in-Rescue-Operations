#include <TinyGPS++.h>
#include "ThingSpeak.h"
#include <WiFi.h>

float latitude , longitude;
String lat_str , lng_str;
// repace your wifi username and password
char ssid[] = "HW-4G-MobileWiFi-0A16";   // your network SSID (name)
char pass[] = "38274726";   // your network password
unsigned long myChannelNumber = 996013;
const char * myWriteAPIKey = "224U18W9TBLXTAKN";

// The TinyGPS++ object
TinyGPSPlus gps;
WiFiClient client;


void setup()
{
  Serial.begin(115200);
  Serial2.begin(9600);
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, pass);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.print("Netmask: ");
  Serial.println(WiFi.subnetMask());
  Serial.print("Gateway: ");
  Serial.println(WiFi.gatewayIP());
  ThingSpeak.begin(client);
}

void loop()
{
  while (Serial2.available() > 0) {
    if (gps.encode(Serial2.read()))
    {
      if (gps.location.isValid())
      {
        latitude = gps.location.lat();
        lat_str = String(latitude , 6);
        longitude = gps.location.lng();
        lng_str = String(longitude , 6);
        Serial.print("Latitude = ");
        Serial.println(lat_str);
        Serial.print("Longitude = ");
        Serial.println(lng_str);
        ThingSpeak.setField(1, lat_str);
        ThingSpeak.setField(2, lng_str);
        ThingSpeak.writeFields(myChannelNumber, myWriteAPIKey);
      }
      delay(1000);
      Serial.println();
    }
  }
}
