require 'savon'
require 'base64'
class Formulario 
  attr_reader :attr_response

  def initialize(data_wsdl)
    name = "#{data_wsdl[:name]} #{data_wsdl[:last_name]}"
    surname = "#{data_wsdl[:last_name]} #{data_wsdl[:second_last_name]}"
    email = data_wsdl[:mail][0]
    phone = data_wsdl[:phone][0]
    description = data_wsdl[:description]
    address = data_wsdl[:address]
    neighbor = data_wsdl[:neighbor]
    predial = data_wsdl[:predial]
    lot = data_wsdl[:lot]
    neighborhood = data_wsdl[:neighborhood]
    urbanization = data_wsdl[:urbanization]
    id_type = data_wsdl[:id_type]
    id_number = data_wsdl[:id_number]

    data_file = data_wsdl[:copy_doc_id]
    encoded_string = encode_file_base64(data_file.tempfile)

    secundary_file = data_wsdl[:receipt_canceled] 
    encoded_secundary_file = secundary_file ? encode_file_base64(secundary_file.tempfile) : ''
    
    wsdl = 'https://evolution-epx.com:8027/ePxExternalSRV.asmx?wsdl'
    client = Savon.client(wsdl: wsdl)
    message_data = {
      :type_document => data_wsdl[:code_number], 
      :keys => [-1, -2, 10, 11], 
      :values => ["4", "4.1", "Nombre", "Apellido"],
      #:keys => [-1, -2, 10, 11, -4, 1053, 2083, 1021, 2060, 1014, 3039, 3040, 3041, 2047, 2048], 
      #:values => ["4", "4.1", name, surname, email, phone, description, address, neighbor, predial, lot, neighborhood, urbanization, id_type, id_number],
      :doc_file => encoded_string,
      :doc_fileName => data_file.original_filename,
      :annex_files => {
        "Annex" => [
          {
            "FileName" => secundary_file ? secundary_file.original_filename : '',
            "Base64File" => encoded_secundary_file
          }
        ]
      },
      :area_Code => 1001,
      :sender => {
        'TypeId' => data_wsdl[:id_type],
        'Id' => data_wsdl[:id_number],
        'Name' => data_wsdl[:name],
        'FirstLastName' => data_wsdl[:last_name],
        'SecondLastName' => data_wsdl[:second_last_name],
        'Address' => data_wsdl[:address],
        'Email' => email
      }
    }
    response = client.call(:radicate, message: message_data)
    response_data = response.to_array(:radicate_response, :radicate_result).first
    
    isSuccess = response_data[:result][:success]
    if isSuccess 
      radicate = response_data[:document][:radicado]
      verification_code = response_data[:document][:verification_code]
      doc_id = response_data[:document][:doc_id]
      response_message = "Exitoso. No Radicado: #{radicate}, Codigo Verificacion: #{verification_code}, Doc: #{doc_id}"
    else
      response_message = "#{response_data[:result]} \r\n Algo ha sucedido con la solicitud, intente de nuevo"
    end
    @attr_response = response_message
  end

  def encode_file_base64 tmp_file
    encoded = Base64.encode64(File.open(tmp_file).read)
  end
end