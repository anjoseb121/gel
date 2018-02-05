require 'savon'
require 'base64'
class Formulario 
  attr_reader :attr_response

  def initialize(data_wsdl)
    name = "#{data_wsdl[:name]} #{data_wsdl[:second_name]}"
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
    registration_number = data_wsdl[:registration_number]
    license_type = data_wsdl[:license_type]

    data_file = data_wsdl[:copy_doc_id]
    encoded_string = encode_file_base64(data_file.tempfile)

    files = []
    files.push(data_wsdl[:receipt_canceled])
    files.push(data_wsdl[:third_document]) if data_wsdl[:third_document]
    files.push(data_wsdl[:fourth_document]) if data_wsdl[:fourth_document]
    files.push(data_wsdl[:fifth_document]) if data_wsdl[:fifth_document]

    keys = [
      {:int => -1}, 
      {:int => -2}, 
      {:int => 10}, 
      {:int => 11}, 
      {:int => -4}, 
      {:int => 1053}, 
      {:int => 2083}, 
      {:int => 1021}, 
      {:int => 2060}, 
      {:int => 3043},
      {:int => 3039},
      {:int => 3040}, 
      {:int => 3041}, 
      {:int => 2047}, 
      {:int => 2048},
    ]

    values = [
      {:string => "4"},
      {:string => "4.1"},
      {:string => name},
      {:string => surname},
      {:string => email},
      {:string => phone},
      {:string => description},
      {:string => address},
      {:string => neighbor},
      {:string => predial},
      {:string => lot},
      {:string => neighborhood},
      {:string => urbanization},
      {:string => id_type},
      {:string => id_number},
    ]

    if registration_number 
      keys.push({:int => 3044})
      values.push({:string => registration_number})
    end

    if license_type 
      keys.push({:int => 3042})
      values.push({:string => license_type})
    end

    wsdl = 'https://evolution-epx.com:8027/ePxExternalSRV.asmx?wsdl'
    client = Savon.client(wsdl: wsdl)
    message_data = {
      :type_document => data_wsdl[:code_number],
      :keys => keys,
      :values => values,
      :doc_file => encoded_string,
      :doc_fileName => data_file.original_filename,
      :annex_files => {
        "Annex" => extra_files(files)
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

  def extra_files array_files
    files = []
    array_files.each do | file |
      hash_file = {
        "Base64File" => file ? encode_file_base64(file.tempfile) : '',
        "FileName" => file ? file.original_filename : ''
      }
      files.push(hash_file)
    end
    files
  end
end
