rp = require('request-promise')
urlencode = require('urlencode');
SMSProvider = require('./SMSProvider')

module.exports = (Promise, options) ->

  class MobilantSMSProvider extends SMSProvider
    constructor: (options) ->
      if typeof options is 'undefined'
        throw new Error 'Must pass options'

      if typeof options.authToken is 'undefined'
        throw new Error 'Must set authToken'

      if typeof options.fromNumber is 'undefined'
        throw new Error 'Must set fromNumber'

    sendSMSMessage: (toNumber, message) ->
      msgLength = (160 - message.length)

      if msgLength == 160 then throw new Error "Message is empty"
      if msgLength < 0 then throw new Error "Message is over 160 characters!"

      message = urlencode(message).replace(/%20/g,'+')

      uri = 'https://gw.mobilant.net/?key=' + options.authToken + '&to=' + toNumber + '&message=' + message + '&route=directplus&from=' + options.fromNumber

      opt = {
        method: "GET"
        uri: uri
      }

      return rp(opt)

  provider = new MobilantSMSProvider(options)

  # Pass back the message method
  return provider
