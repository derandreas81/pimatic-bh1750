module.exports = {
  title: "pimatic-ping device config schemas"
  BH1750Sensor: {
    title: "BH1750Sensor config options"
    type: "object"
    extensions: ["xLink"]
    properties:
      device:
        description: "device file to use, for example /dev/i2c-0"
        type: "string"
      address:
        description: "the address of the sensor"
        type: "integer"
      interval:
        interval: "Interval in ms so read the sensor"
        type: "integer"
        default: 10000
  }
}
