import serial, json
import paho.mqtt.client as paho

port = "/dev/ttyACM0"

# MQTT settings
MQTT_BROKER = "localhost"
MQTT_PORT = 1883
MQTT_USER = "emli05"
MQTT_PASS = "emli05"
MQTT_SUB = "emli05/servo_command"
MQTT_PUB = "emli05/wiper_and_rain"


ser = serial.Serial(port, 9600, timeout=1)
ser.close() # make sure it is closed just in case
ser.open()


def on_message(mosq, obj, msg): # write desired angle in json to serial
  wiper_json = json.dumps({"wiper_angle":int(msg.payload)})
  wiper_json = wiper_json.replace(" ","")
  #print(wiper_json)
  ser.write(wiper_json.encode())

client = paho.Client()
client.on_message = on_message
client.username_pw_set(MQTT_USER, MQTT_PASS)
client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.subscribe(MQTT_SUB, 0)


while client.loop() == 0:
  res_serial = ser.read_until(b"\r\n")
  if res_serial == b"":
    continue
  res_json = json.loads(res_serial.decode())
  if res_json == {"serial":"json_error"}:
    continue
  client.publish(MQTT_PUB, f"{res_json['wiper_angle']} {res_json['rain_detect']}")
  #print(res_json["wiper_angle"])

