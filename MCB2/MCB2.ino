// Reference: https://learn.adafruit.com/adafruit-rfm69hcw-and-rfm96-rfm95-rfm98-lora-packet-padio-breakouts/rfm9x-test
int x[5400][3]; // Create a matrix to store data
#include "DHT.h" // version 1.4.3
#include <SPI.h> // version 1.59
#include <RH_RF95.h> // version 1.59
#define DHTPIN 3 
#define DHTTYPE DHT22 

#define RFM95_CS 10
#define RFM95_RST 9
#define RFM95_INT 2
#define RF95_FREQ 900.0
RH_RF95 rf95(RFM95_CS, RFM95_INT);
DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(115200); // Set baud rate
  dht.begin();
  pinMode(RFM95_RST, OUTPUT);
  digitalWrite(RFM95_RST, HIGH);
  analogReadResolution(12); // Set analog resolution
  pinMode(8, OUTPUT); // Set pin mode
  //Serial.println("Arduino LoRa TX Test!");

  // manual reset
  digitalWrite(RFM95_RST, LOW);
  delay(10);
  digitalWrite(RFM95_RST, HIGH);
  delay(10);

  while (!rf95.init()) {
   // Serial.println("LoRa radio init failed");
    while (1);
  }
  //Serial.println("LoRa radio init OK!");
  if (!rf95.setFrequency(RF95_FREQ)) {
  //Serial.println("setFrequency failed");
  while (1);
  }
  //Serial.print("Set Freq to: "); 
  //Serial.println(RF95_FREQ);
  
  rf95.setTxPower(23, false);
}

void loop() {
  float q = dht.readHumidity();
  float f = dht.readTemperature();
  digitalWrite(8, HIGH); // Close ion gate in most of the time
  if (Serial.available() > 0) { 
    int inByte = Serial.read();
    int a[5400][1];
    int b[5400][1];
    char t[10];
    char h[10];
    switch (inByte) {
    case '1': // Low resolving power mode
    digitalWrite(8, LOW); 
    delayMicroseconds(550); // Open ion gate for 330 microsecond
    digitalWrite(8, HIGH);
    for(int i=0;i<5400;i++){ // Record drift time and the voltage of detector 
      x[i][0]=micros();    
      x[i][1]=analogRead(A1);
    }
    for(int j=0;j<100;j++){ // Record more data 
      digitalWrite(8, LOW);
      delayMicroseconds(550); // Open ion gate for 330 microsecond
      digitalWrite(8, HIGH);
    for(int i=0;i<5400;i++){ // Record drift time and the voltage of detector
      x[i][0]=micros();    
      x[i][2]=analogRead(A1);
    }
    for(int i=0;i<5400;i++){ // Sum up datas
      x[i][1]=x[i][1]+x[i][2];
    }
    }
    for(int i=0;i<5400;i++){// Report the drift time and average voltage
      Serial.print(x[i][0]-x[0][0]);
      Serial.print(",");
      Serial.print(x[i][1]/100);      
      Serial.print("\n");
      delay(5);
    }
     for(int i=1260;i<2340;i++){
      a[i][0] = x[i][0]-x[0][0];
      b[i][0] = x[i][1]/100;
      itoa(a[i][0],t,10);
      itoa(b[i][0],h,10);
      rf95.send((uint8_t*)t,10);
      rf95.send((uint8_t*)h,10);
      rf95.waitPacketSent();
      uint8_t buf[RH_RF95_MAX_MESSAGE_LEN];
      uint8_t len = sizeof(buf);
      delay(10); 
    }
    break;

    case '3':
    Serial.print(q ,1);
    Serial.println("%");
    Serial.print("\n");
    Serial.print(f,1);
    break;
   }
}
}
