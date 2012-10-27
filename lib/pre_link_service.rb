require 'savon'

class PreLinkService

  @@application = YAML.load_file("#{Rails.root}/config/application.yml")["#{Rails.env}"]

  @@config = YAML.load_file(
    if @@application["run_local"] == true
      "#{Rails.root}/config/local.yml"
    else
      "#{Rails.root}/config/prelink.yml"
    end
    
  ) # rescue {}


  WSDL_URL  = @@config['wsdl_url']
  WSDL_NAMESPACE  = @@config['wsdl_namspace']
  STATION_ID = @@config['station_id']
  PASS_CODE  = @@config['pass_code']

  def initialize

    Savon.configure do |c|
      c.env_namespace = :soap
    end

    @client = Savon::Client.new do |wsdl|
      wsdl.document = WSDL_URL
      wsdl.namespace = WSDL_NAMESPACE
    end

    @soap_header = {'preLinkHeader' => {'StationId' => STATION_ID,
        'PassCode'  => PASS_CODE}}
  end

  def get_test_codes
    
    response = @client.request :get_test_codes

    return [] if response.soap_fault?

    useful_elements = response.to_hash[:get_test_codes_response][:get_test_codes_result][:diffgram][:document_element][:dynamic_list]

    array_of_hashes = useful_elements.map do |test|
      test.reject do |key,value|
        (key != :test_code) and (key != :test_name)
      end
    end
    
    array_of_hashes.inject({}) do |new_hash, array_hash|
      new_hash[array_hash[:test_name]]=array_hash[:test_code]
      new_hash
    end
  end
  
  def get_new_results
    response = @client.request :get_new_results do |soap|
      soap.xml = '<?xml version="1.0" encoding="utf-8"?>
          <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
            <soap:Header>
              <preLinkHeader xmlns="http://www.prelink.co.za/">
                <StationId>' + STATION_ID + '</StationId>
                <PassCode>' + PASS_CODE + '</PassCode>
              </preLinkHeader>
            </soap:Header>
            <soap:Body>
              <GetNewResults xmlns="http://www.prelink.co.za/" />
            </soap:Body>
          </soap:Envelope>'
      
    end

    return [] if response.soap_fault?

    useful_elements = response.to_hash[:get_new_results_response][:get_new_results_result][:diffgram][:document_element][:result] rescue []  # [:dynamic_list]
=begin
    array_of_hashes = useful_elements.map do |test|
      test.reject do |key,value|
        (key != :request_number) and (key != :result) and (key != :test_unit) and (key != :colour) and (key != :test_range)
      end
    end

    array_of_hashes
=end
  end

  def get_profile_codes
    response = @client.request :get_profile_codes

    return [] if response.soap_fault?

    useful_elements = response.to_hash[:get_profile_codes_response][:get_profile_codes_result][:diffgram][:document_element][:dynamic_list]

    array_of_hashes = useful_elements.map do |test|
      test.reject do |key,value|
        (key != :parent_prifile_id) and (key != :parent_profile_name) and (key != :test_name)
      end
    end

    array_of_hashes.inject({}) do |new_hash, array_hash|
      new_hash[array_hash[:test_name]]=array_hash[:test_code]
      new_hash
    end
  end

  def order_request(params = {})
    response = @client.request :order_request do |soap|
      soap.xml = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Header>
    <preLinkHeader xmlns="http://www.prelink.co.za/">
      <StationId>guid</StationId>
      <PassCode>string</PassCode>
    </preLinkHeader>
  </soap:Header>
  <soap:Body>
    <OrderRequest xmlns="http://www.prelink.co.za/">
      <dto>
        <PriorityCode>' + params[:priority_code] + '</PriorityCode>
        <DateCollected>' + params[:date_collected] + '</DateCollected>
        <DateReceived>' + params[:date_received] + '</DateReceived>
        <FolioNumber>' + params[:folio_number] + '</FolioNumber>
        <PatientFirstName>' + params[:first_name] + '</PatientFirstName>
        <PatientLastName>' + params[:last_name] + '</PatientLastName>
        <PatientIdNumber>' + params[:national_id] + '</PatientIdNumber>
        <PatientAge>' + params[:age] + '</PatientAge>
        <PatientDateOfBirth>' + params[:dob] + '</PatientDateOfBirth>
        <GenderCode>' + params[:gender] + '</GenderCode>
        <DoctorLocationCode>' + params[:doctor_location_code] + '</DoctorLocationCode>
        <TestCodes>
          <string>' + (params[:test_codes] rescue []).join("</string><string>") + '</string>
        </TestCodes>
      </dto>
    </OrderRequest>
  </soap:Body>
</soap:Envelope>'

    end

    return [] if response.soap_fault?

    useful_elements = response.to_hash[:order_request_response][:order_request_result]

    new_hash = useful_elements.delete_if{|key, value| key != :request_number and key != :barcodes}

    new_hash
  end

  def get_request_results(options = [])
    requests = ""

    options.each{|option|
      requests = requests + "<string>#{option}</string>\n"
    }

    response = @client.request :get_request_results do |soap|
      soap.xml = '<?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Header>
            <preLinkHeader xmlns="http://www.prelink.co.za/">
              <StationId>' + STATION_ID + '</StationId>
              <PassCode>' + PASS_CODE + '</PassCode>
            </preLinkHeader>
          </soap:Header>
          <soap:Body>
            <GetRequestResults xmlns="http://www.prelink.co.za/">
              <requestNumber>' +
        requests +
        '</requestNumber>
            </GetRequestResults>
          </soap:Body>
        </soap:Envelope>'

    end

    return [] if response.soap_fault?

  end

  def get_results_by_date(params = {})
    response = @client.request :get_results_by_date do |soap|
      soap.xml = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Header>
    <preLinkHeader xmlns="http://www.prelink.co.za/">
      <StationId>' + STATION_ID + '</StationId>
      <PassCode>' + PASS_CODE + '</PassCode>
    </preLinkHeader>
  </soap:Header>
  <soap:Body>
    <GetResultsByDate xmlns="http://www.prelink.co.za/">
      <patientId>' + params[:national_id] + '</patientId>
      <startDate>' + params[:start_date] + '</startDate>
      <endDate>' + params[:end_date] + '</endDate>
    </GetResultsByDate>
  </soap:Body>
</soap:Envelope>'

    end

    return [] if response.soap_fault?

    useful_elements = response.to_hash[:get_results_by_date_response][:get_results_by_date_result][:diffgram][:document_element][:result] rescue []

  end

  def get_priority_list
    response = @client.request :get_prioriy_list

    return [] if response.soap_fault?

    useful_elements = response.to_hash[:get_profile_codes_response][:get_profile_codes_result][:diffgram][:document_element][:dynamic_list]

    array_of_hashes = useful_elements.map do |test|
      test.reject do |key,value|
        (key != :parent_prifile_id) and (key != :parent_profile_name) and (key != :test_name)
      end
    end

    array_of_hashes.inject({}) do |new_hash, array_hash|
      new_hash[array_hash[:test_name]]=array_hash[:test_code]
      new_hash
    end
  end

  # [:get_profile_codes, :get_new_results, :order_request, :get_request_results,
  # :get_test_codes, :get_folio_results, :get_results_by_date,
  # :get_prioriy_list, :get_results_from_request_number]

end