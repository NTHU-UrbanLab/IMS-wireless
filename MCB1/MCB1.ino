#include <TinyGPS++.h> // version 13.0.0
#include <SoftwareSerial.h> // version 0.0.33
#include "ClosedCube_TSYS01.h" // version 2019.3.23
#define TSYS01_I2C_ADDRESS  0x77
ClosedCube::Sensor::TSYS01 tsys01;
static const int RXPin = 3, TXPin = 4;
static const uint32_t GPSBaud = 9600;
TinyGPSPlus gps;
SoftwareSerial ss(RXPin, TXPin);

void setup()
{
  Serial.begin(115200);
  ss.begin(GPSBaud);
  tsys01.begin(0x77);
}

void loop(){
  while (ss.available() > 0)
    if (gps.encode(ss.read())) // Read signal from GPS module
    if (Serial.available() > 0) {
    int inByte = Serial.read();
    switch (inByte) {
    case 'g': {
      displayInfo(); // Print the result from GPS module
      displaytemp(); // Print the result from temperature module
      }
      break;
     }
    }
   }
void displayInfo(){
  Serial.print(F("Location: ")); 
  if (gps.location.isValid()){
    Serial.print(gps.location.lat(), 6); // Print the latitude with 6 digits precision
    Serial.print(F(","));
    Serial.print(gps.location.lng(), 6); // Print the longitude with 6 digits precision
  }
  else{
    Serial.print(F("INVALID")); // Show "INVALID" when GPS module is malfunctioned
  }
  Serial.print("                ");
}
void displaytemp(){  
  Serial.print("Temperature: ");
  Serial.print(tsys01.readTemperature());  // Print the reading from temparature sensor
  Serial.println("°C");
}
  
