#include <SPI.h>
#include <Ethernet.h>
#include <PubSubClient.h>

#define CLIENT_NAME "arduinoX"
#define CLIENT_ID   "0: "
#define GREETING    "0: Hello world"
byte mac[]     = {  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0x01 };
byte ip[]      = { 192, 168, 192,  66 };
byte gateway[] = { 192, 168, 192, 254 };
byte netmask[] = { 255, 255, 255,   0 };
byte server[]  = { 192, 168, 192,  17 };

void callback(
  char* topic,
  byte* payload,
  int   length) {

  Serial.print("Received: ");
  for (int index = 0;  index < length;  index ++) {
    Serial.print(payload[index]);
  }
  Serial.println();
}

PubSubClient client(server, 1883, callback);

void setup_mqtt() {
  Ethernet.begin(mac, ip, gateway, netmask);

  if (client.connect(CLIENT_NAME)) {
    client.publish("test/1", GREETING);
    client.subscribe("test/2");
  }
}

unsigned long timeLater = 0;

void loop_mqtt() {
  char buffer[] = "Send: ?";

  client.loop();

  if (Serial.available()) {
    buffer[6] = Serial.read();
    client.publish("test/1", buffer);
  }

  unsigned long timeNow = millis();

  if (timeNow >= timeLater) {
    timeLater = timeNow + 5000;

    int value = analogRead(0);
    globalString.begin();
    globalString  = CLIENT_ID;
    globalString += value;
    client.publish("test/1", globalBuffer);
  }
}
