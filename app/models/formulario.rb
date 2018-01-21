require 'savon'
class Formulario 
  attr_reader :prueba

  def initialize(info)
    wsdl = 'https://evolution-epx.com:8030/ePxExternalSRV.asmx?wsdl'
    client = Savon.client(wsdl: wsdl)
    message_data = {
      typeDocument: 1,
      keys: 1,
      values: info
    }
    response = client.call(:radicate, message: message_data)
    @prueba = response
    puts "HOLAAA -- #{@prueba}"
  end
end