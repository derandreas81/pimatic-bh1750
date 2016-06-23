module.exports = {
  title: "pimatic-ping device config schemas"
  BH1750Sensor: {
    title: "BH1750Sensor config options"
    type: "object"
    extensions: ["xLink"]
    properties:
      device:
        description: "device file to use, for example /dev/i2c-1"
        type: "string"
        default:"/dev/i2c-1"
      address:
        description: "the address of the sensor 35 for 0x23"
        type: "integer"
        default: "35"
      interval:
        interval: "Interval in ms so read the sensor"
        type: "integer"
        default: "10000"
  }
}
