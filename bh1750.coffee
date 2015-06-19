# #Plugin template

# This is an plugin template and mini tutorial for creating pimatic plugins. It will explain the 
# basics of how the plugin system works and how a plugin should look like.

# ##The plugin code

# Your plugin must export a single function, that takes one argument and returns a instance of
# your plugin class. The parameter is an envirement object containing all pimatic related functions
# and classes. See the [startup.coffee](http://sweetpi.de/pimatic/docs/startup.html) for details.
module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take 
  # a look at the dependencies section in pimatics package.json

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  # ###MyPlugin class
  # Create a class that extends the Plugin class and implements the following functions:
  class BH1750Plugin extends env.plugins.Plugin

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #  
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins` 
    #     section of the config.json file 
    #     
    # 
    init: (app, @framework, @config) =>
      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("BH1750Sensor", {
        configDef: deviceConfigDef.BH1750Sensor, 
        createCallback: (config, lastState) => 
          device = new BH1750Sensor(config, lastState)
          return device
      })

  class BH1750Sensor extends env.devices.TemperatureSensor
    _temperature: null

    constructor: (@config, lastState) ->
      @id = config.id
      @name = config.name
      @_temperature = lastState?.temperature?.value
      BH1750 = require 'bh1750'
      @sensor = new BH1750({
        address: config.address,
        device: config.device,
        command: 0x10,
        length: 2
      });
      Promise.promisifyAll(@sensor)

      super()

      @requestValue()
      setInterval( ( => @requestValue() ), @config.interval)

    requestValue: ->
      @sensor.readLight( (value) =>
        #if value isnt @_temperature
          @_temperature = value
          @emit 'temperature', value
        #else
        #  env.logger.debug("Sensor value (#{value}) did not change.")
      #).catch( (error) =>
      #  env.logger.error(
      #    "Error reading BH1750Sensor with address #{@config.address}: #{error.message}"
      #  )
      #  env.logger.debug(error.stack)
      )

    getTemperature: -> Promise.resolve(@_temperature)

  # Create a instance and return it to the framework
  myPlugin = new BH1750Plugin
  return myPlugin
