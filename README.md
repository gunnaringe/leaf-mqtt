# Leaf MQTT

This is forked from https://github.com/glynhudson/leaf-python-mqtt

It allows interaction with the Nissan Leaf API through MQTT.

The changes made from the forked version is to make it easier to use via Docker.

## Config
| Environment variable        | Description                | Default      |
| --------------------------- | -------------------------- | ------------ |
| NISSAN_USERNAME             | Your Nissan username       | _required_   |
| NISSAN_PASSWORD             | Your Nissan password       | _required_   |
| NISSAN_REGION_CODE          | Region code                | NE           |
| MQTT_HOST                   | MQTT host                  | localhost    |
| MQTT_PORT                   | MQTT port                  | 1883         |
| MQTT_USERNAME               | MQTT username              | _blank_      |
| MQTT_PASSWORD               | MQTT password              | _blank_      |
| MQTT_SECURE                 | MQTT enable TLS            | no           |
| MQTT_CONTROL_TOPIC          | Topic for control commands | leaf/control |
| MQTT_STATUS_TOPIC           | Topic for status updates   | leaf/status  |
| UPDATE_INTERVAL             | API update interval        | 15m          |

### Region
The default config is setup for Nissan Leaf cars in Europe with region code `NE`. Set region code to one of the following if you are in a different region:

```
NNA : USA
NE : Europe
NCI : Canada
NMA : Australia
NML : Japan
```

Note that there is another URL to use if you are in the UK, as described in https://github.com/glynhudson/leaf-python-mqtt

## Run
This image is hosted at Docker Hub: `gunnaringe/leaf-mqtt`

### Example: Publish to localhost MQTT server
```
docker run \
  -e network=host \
  -e NISSAN_USERNAME="username" \
  -e NISSAN_PASSWORD="password" \
gunnaringe/leaf-mqtt
```

## Usage

### Status

Every XX min the following status(s) are updated to MQTT sub topics:

```
leaf/status/last_updated
leaf/status/battery_percent
leaf/status/charging_status
leaf/status/connected
```

The raw json output from Nissan API request is posted to MQTT topic:

`leaf/status/raw`

These scheduled 'status' updates are polled from the Nissan API and not requested from the car. I.e. the last car status is returned. See the 'Control' section below for how to request an update from the car. Requesting the latest status from the API does not effect the car, eg. GSM telematics in the car are not activated.

**It's not recommended to poll the Nissan API more fequently then about 10-15min, be a good citizen :-)**

### Control

By default the following control MQTT topics are used

`leaf/control/update`

Publishing to the update control sub-topic will request and update from the car.

**Caution: this will activate the cars GSM telematic modem. Frequent polling is not recommended as it could drain the cars 12V aux battery**

`leaf/control/climate`

Publishing `on` to the `climate` control sub-topic will turn on the cars climate control. Publishing `off` will turn it off.
