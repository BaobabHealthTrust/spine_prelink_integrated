class LabController < ApplicationController
  before_filter :prelink_connect, :except => [:void]

  def order_request
    @patient = Patient.find(params[:id]) rescue nil

    redirect_to "/" if @patient.nil?

    @name = @patient.person.name rescue ""

    @first_name = @patient.person.names.first.given_name rescue ""
    @last_name = @patient.person.names.first.family_name rescue ""
    @national_id = @patient.national_id(false) # rescue ""
    @age = @patient.person.age rescue ""
    @dob = @patient.person.birthdate rescue ""
    @gender = @patient.person.gender rescue ""

    @codes = {
      "FNA Gram Stain" => ["Gram GNB","Gram GNC","Gram GNCB","Gram GNDC","Gram GPB",
        "Gram GPC","Gram GPDC","Gram NOS","Gram YEA"],
      "Liver Enzymes" => ["Alkaline Phosphatase","ALT","AST","GGT","LDH"],
      "Urine Microscopy" => ["Schistosomiasis","Trichomonas Vaginalis","Urine RBC",
        "Urine WBC","Yeast Cells"],
      "U&Es (Urea & Electrolytes, renal function)" => ["Calcium","Chloride","CO2 ","NA",
        "Potassium","Urea"],
      "Bilirubin profile" => ["Bilirubin Direct","Bilirubin Indirect","Bilirubin Total"],
      "CSF CHEM" => ["CSF Glucose","CSF micro-protein"],
      "BC Adult" => ["BCULT ADULT"],
      "Mycobacterial blood culture" => ["Mycobacterial BC","Mycobacterial BC Time"],
      "Stool M&C" => ["Cryptosporidium oocysts","Stool Appearance"],
      "HIV DNA PCR" => ["HIV DNA PCR","HIV DNA PCR Confirmatory"],
      "Lipogram" => ["Cholesterol","HDL Cholesterol","LDL Cholesterol","Triglycerides"],
      "Malaria Thin film" => ["Blood parasite (non-Malaria)",
        "Mal P falciparum gametocyte parasitaemia","Mal P falciparum gametocytes",
        "Mal P falciparum merozoites","Mal P falciparum schizonts",
        "Mal P falciparum troph count per 200 WBCs","Mal P falciparum trophs",
        "Mal P falciparum trophs/microL (RBC)","Mal P falciparum trophs/microL (WBC)",
        "Mal P falciparum trophs/500 RBCs","Mal P Malariae gametocytes",
        "Mal P Malariae merozoites","Mal P Malariae schizonts","Mal P Malariae trophs",
        "Mal P Ovale gametocytes","Mal P Ovale merozoites","Mal P Ovale schizonts",
        "Mal P Ovale trophs","Mal P Vivax gametocytes","Mal P Vivax merozoites",
        "Mal P Vivax schizonts","Mal P Vivax trophs"],
      "CSF MC&S Procedure" => ["Appearance","CSF Indian Ink","Gram"],
      "CD4 (FACSCount)" => ["CD4 Absolute","CD4/CD8","CD8 Absolute","Total CD3 Average"],
      "Calcium" => ["Albumin","Calcium"],
      "TB Microscopy & Culture" => ["TB Culture Identification","TB Culture Sputum",
        "TB Smear Microscopy(AFB) sputum"],
      "BC Paediatric" => ["BCULT blood weight","BCULT bottle weight Post",
        "BCULT bottle weight Pre","BCULT PAED","BCULT Paeds BC bottle label"],
      "CDC Flu" => ["CDC FLU A ","CDC FLU B","CDC H1N1 sw","CDC H5N1"],
      "Malaria Thick Screen" => ["Malaria Thick Film","Thick Smear Parasitaemia"],
      "Pleural fluid M,C&S procedure" => ["Appearance","Glucose Pleural fluid","Gram","Protein Pleural"],
      "Syphilis serology" => ["TPPA FUJIREBIO"],
      "U&E and Creatinine" => ["Creatinine"],
      "Micro Other" => ["B-LACT","ESBL"],
      "LEUKOCYTE MORPHOLOGY WORKSHEET" => ["LM Basophils Abs","LM Comment",
        "LM Eosinophils Abs","LM Epithelial Cells/HPF","LM Erythrocyte Cells/HPF",
        "LM Lymphocytes Abs","LM Macro Abs","LM Neutrophils Abs"],
      "AFB Profile" => ["TB Smear Microscopy(AFB) sputum"],
      "RPR" => ["RPR (TITRE)","RPR QUAL"],
      "Selective salmonella culture, BM" => ["ESBL","MIC CIP"],
      "Total Protein" => ["Albumin","Protein Total"],
      "Selective Salmonella Culture, HS" => ["ESBL","MIC CIP"],
      "TSH,FT4" => ["Free T4","TSH"],
      "Microscopy" => ["Lymphs","Polymorphs","RCC","WBC"],
      "CT/NG Abbott" => ["CT Abbott PCR","NG Abbott PCR"],
      "Electrolytes" => ["Chloride","CO2 ","NA","Potassium"],
      "CD4 Profile" => ["CD 45","CD4 %","CD4 - bead events","CD4 Aq Time",
        "CD4 Bead count","CD4 CHECK0","CD4 CHECK1","CD4 CHECK2","CD4 COLCOMP",
        "CD4 color","CD4 Count","CD4/CD8","CD8 %","CD8 Count"],
      "Gram Stain" => ["Gram GNB","Gram GNC","Gram GNCB","Gram GNDC","Gram GPB",
        "Gram GPC","Gram GPDC","Gram NOS","Gram YEA"],
      "BM GRAM" => ["BM Gram GNB","BM Gram GNC","BM Gram GNCB","BM Gram GNDC",
        "BM Gram GPB","BM Gram GPC","BM Gram GPDC","BM Gram YEA"],
      "FTD Resp." => ["Adenovirus","Bocavirus","C.pneumoniae","CorHKU","CoronaVirus 229",
        "CoronaVirus 43","CoronaVirus 63","Enterovirus","FTD Bordetella","FTD CMV",
        "FTD FLU A","FTD FLU B","FTD FLU C","FTD H1N1 sw","FTD Haem inf sp",
        "FTD K. pneumo","FTD Legionella","FTD Moraxella","FTD PCP","FTD Salmonella",
        "H.Influenzae B","M.pneumoniae","Metapneumo","Paraflu1","ParaFlu2","ParaFlu3",
        "ParaFlu4","Parechovirus","Rhinovirus","RSV","S.aureus","S.pneumoniae PCR"],
      "LEUKOCYTE MORPHOLOGY PROFILE" => ["LM Basophils %","LM Basophils Abs",
        "LM Comment","LM Eosinophils %","LM Eosinophils Abs","LM Epithelial Cells/HPF",
        "LM Erythrocyte Cells/HPF","LM Lymphocytes %","LM Lymphocytes Abs","LM Macro %",
        "LM Macro Abs","LM Neutrophils %","LM Neutrophils Abs"],
      "LFT" => ["ALT","AST","Bilirubin Direct","Bilirubin Total","GGT"],
      "BCULT GRAM" => ["BCULT Gram GNB","BCULT Gram GNC","BCULT Gram GNCB",
        "BCULT Gram GNDC","BCULT Gram GPB","BCULT Gram GPC","BCULT Gram GPDC","BCULT Gram YEA"],
      "FBC (Full Blood Count)" => ["Basophils#","Basophils%","Eosinophils#","Eosinophils%",
        "Haematocrit","Haemoglobin","Lymphocytes#","Lymphocytes%","MCH","MCHC","MCV",
        "Monocytes#","Monocytes%","MPV","Neutrophils#","Neutrophils%","Platelets",
        "RDW","Red Cell Count","WCC "],
      "Gene Xpert" => ["Gene Xpert MTB sputum","Gene Xpert Rif sputum"],
      "HbA1c" => ["Haemoglobin A1c (CX5)","Haemoglobin Hb (CX5)","HbA1c (IFCC)","HbA1c (NGSP)"],
      "Micro Other MC&S Procedure" => ["Appearance","Gram"],
      "Hepatitis screen" => ["Hepatitis B Surface Antigen (RT)","Hepatitis C  (RT)"],
      "Manual Differential" => ["Basophils#","Basophils%","Blasts#","Blasts%","Eosinophils#",
        "Eosinophils%","Lymphocytes#","Lymphocytes%","Metamyelocytes %","Metamyelocytes#",
        "Monocytes#","Monocytes%","Myelocytes#","Myelocytes%","Neutrophils#",
        "Neutrophils%","Promyelocytes %","Promyelocytes#","Stab#","Stab%","WCC Man"],
      "Selective Salmonella culture, stool" => ["ESBL","MIC CIP"]}

  end

  def place_orders
    options = {
      :priority_code => params["PriorityCode"],
      :date_collected => params["DateCollected"],
      :date_received => params["DateCollected"],
      :folio_number => params["FolioNumber"],
      :first_name => params["FirstName"],
      :last_name => params["LastName"],
      :national_id => params["NationalId"],
      :age => params["Age"],
      :dob => params["Dob"],
      :gender => params["Gender"],
      :doctor_location_code => params["DoctorLocationCode"],
      :test_codes => (params["TestCodes"] rescue [])
    }

    @order = LabOrder.create(
      :national_id => params["NationalId"],
      :priority_code => params["PriorityCode"],
      :date_collected => params["DateCollected"],
      :date_received => params["DateReceived"],
      :patient_id => params["PatientId"],
      :test_code => params["TestCodes"].join("|")
    )

    @result = @prelink.order_request(options)

    @order.update_attributes(
      :request_number => @result[:request_number],
      :barcodes => @result[:barcodes]
    )

    redirect_to "/lab/show/#{@order.patient_id}"

  end

  def place_order
    prefix = YAML.load_file("#{Rails.root}/config/application.yml")["#{Rails.env}"]["order_prefix"] rescue ""

    ids = ""

    params["TestCodes"].each do |test|
      @order = LabOrder.create(
        :national_id => params["NationalId"],
        :date_collected => Time.now,
        :patient_id => params["PatientId"],
        :test_code => test
      )

      @order.update_attributes(
        :request_number => "#{prefix}#{@order[:lab_order_id]}"
      )

      if ids == ""
        ids = @order.id.to_s
      else
        ids = ids + ";" + @order.id.to_s
      end
    end

    print_and_redirect("/lab/print/#{ids}", "/lab/show/#{@order.patient_id}") and return

  end

  def show
    @patient = Patient.find(params[:id]) rescue nil

    @name = @patient.person.name rescue ""

    @first_name = @patient.person.names.first.given_name rescue ""
    @last_name = @patient.person.names.first.family_name rescue ""
    @national_id = @patient.national_id_with_dashes(false) rescue ""
    @age = @patient.person.age rescue ""
    @dob = @patient.person.birthdate rescue ""
    @gender = @patient.person.gender rescue ""

    @orders = LabOrder.find(:all, :conditions => ["patient_id = ?", @patient.id]) rescue []

    @open = []
    @closed = []

    @orders.each do |order|
      if order.result.blank?
        @open << order
      else
        @closed << order
      end
    end

    @cancel_destination_root_url =
      YAML.load_file("#{Rails.root}/config/application.yml")["#{Rails.env}"]["cancel_destination_root_url"] rescue ""

    @results = @prelink.get_test_codes rescue nil

    render :layout => "lab_application"
  end

  def overview
    @patient = Patient.find(params[:id]) rescue nil

    @national_id = @patient.national_id_with_dashes(false) rescue ""

    @fields = ["request_number", "timestamp", "test_code"]

    @fields = @fields + LabResultDetails.find(:all, :joins => [:lab_result],
      :select => ["DISTINCT field_name"],
      :conditions => ["patient_id = ?", @patient.id]).map{|l| l.field_name} rescue []

    @labs = LabResultDetails.find(:all, :joins => [:lab_result], :order => ["timestamp DESC"],
      :select => ["lab_result.lab_result_id, lab_result.request_number, lab_result.test_code, " +
          "field_name, field_value, timestamp"],
      :conditions => ["patient_id = ? AND DATE(timestamp) = ?",
        @patient.id, (session[:datetime] ? session[:datetime].to_date.strftime("%Y-%m-%d") :
            Date.today.strftime("%Y-%m-%d"))])

    @orders = {}

    mapping = {"08B"=>"Albumin", "35A"=>"Alkaline Phosphatase", "31A"=>"ALT",
      "30A"=>"AST", "BA#"=>"Basophils#", "BA%"=>"Basophils%",
      "12A"=>"Bilirubin Direct", "11A"=>"Bilirubin Total", "44A"=>"Cholesterol",
      "MCA"=>"CRAG Test", "03F"=>"Urine Creatinine ", "89A"=>"CRP", "EO#"=>"Eosinophils#",
      "EO%"=>"Eosinophils%", "36A"=>"GGT", "06A"=>"Glucose random (serum)",
      "HCT"=>"Haematocrit", "HB"=>"Haemoglobin", "83D"=>"LDH", "HIVAMPLICORPCRQUAL"=>"HIV DNA PCR Confirmatory",
      "HIVD"=>"HIV Rapid Test", "HSV2KALON"=>"HSV-2 KALON ELISA", "34B"=>"LDL Cholesterol", "LY#"=>"Lymphocytes#",
      "LY%"=>"Lymphocytes%", "48A"=>"Magnesium", "MALTHICK"=>"Malaria Thick Film", "MCH"=>"MCH",
      "MCHC"=>"MCHC", "MCV"=>"MCV", "MRETVol"=>"Mean Reticulocyte Volume", "MO#"=>"Monocytes#",
      "MO%"=>"Monocytes%", "MPV"=>"MPV", "01A"=>"NA", "NE#"=>"Neutrophils#", "NE%"=>"Neutrophils%",
      "PLT"=>"Platelets", "01B"=>"Potassium", "07A"=>"Protein Pleural", "RDW"=>"RDW",
      "RBC"=>"Red Cell Count", "RET%"=>"Retic", "TIBC"=>"TIBC", "TPPA"=>"TPPA FUJIREBIO",
      "42B"=>"Triglycerides", "UREA"=>"Urea", "08M"=>"Urine albumin", "WBC"=>"WCC "}

    @labs.each do |lab|

      if @orders[lab.lab_result_id].nil?

        @orders[lab.lab_result_id] = {
          "request_number" => "#{lab.request_number}",
          "test_code" => "#{(mapping[lab.test_code].blank? ? lab.test_code : mapping[lab.test_code])}",
          "timestamp" => "#{lab.timestamp}"
        }

      end

      @orders[lab.lab_result_id][lab.field_name] = "#{lab.field_value}"

    end

    render :layout => false
  end

  def orders
    @patient = Patient.find(params[:id]) rescue nil

    @national_id = @patient.national_id_with_dashes(false) rescue ""

    @fields = ["request_number", "timestamp", "test_code"]

    @fields = @fields + LabResultDetails.find(:all, :joins => [:lab_result],
      :select => ["DISTINCT field_name"],
      :conditions => ["patient_id = ?", @patient.id]).map{|l| l.field_name} rescue []

    @labs = LabResultDetails.find(:all, :joins => [:lab_result], :order => ["timestamp DESC"],
      :select => ["lab_result.lab_result_id, lab_result.request_number, field_name, lab_result.test_code, " +
          "field_value, timestamp"],
      :conditions => ["patient_id = ?", @patient.id])

    @orders = {}

    mapping = {"08B"=>"Albumin", "35A"=>"Alkaline Phosphatase", "31A"=>"ALT",
      "30A"=>"AST", "BA#"=>"Basophils#", "BA%"=>"Basophils%",
      "12A"=>"Bilirubin Direct", "11A"=>"Bilirubin Total", "44A"=>"Cholesterol",
      "MCA"=>"CRAG Test", "03F"=>"Urine Creatinine ", "89A"=>"CRP", "EO#"=>"Eosinophils#",
      "EO%"=>"Eosinophils%", "36A"=>"GGT", "06A"=>"Glucose random (serum)",
      "HCT"=>"Haematocrit", "HB"=>"Haemoglobin", "83D"=>"LDH", "HIVAMPLICORPCRQUAL"=>"HIV DNA PCR Confirmatory",
      "HIVD"=>"HIV Rapid Test", "HSV2KALON"=>"HSV-2 KALON ELISA", "34B"=>"LDL Cholesterol", "LY#"=>"Lymphocytes#",
      "LY%"=>"Lymphocytes%", "48A"=>"Magnesium", "MALTHICK"=>"Malaria Thick Film", "MCH"=>"MCH",
      "MCHC"=>"MCHC", "MCV"=>"MCV", "MRETVol"=>"Mean Reticulocyte Volume", "MO#"=>"Monocytes#",
      "MO%"=>"Monocytes%", "MPV"=>"MPV", "01A"=>"NA", "NE#"=>"Neutrophils#", "NE%"=>"Neutrophils%",
      "PLT"=>"Platelets", "01B"=>"Potassium", "07A"=>"Protein Pleural", "RDW"=>"RDW",
      "RBC"=>"Red Cell Count", "RET%"=>"Retic", "TIBC"=>"TIBC", "TPPA"=>"TPPA FUJIREBIO",
      "42B"=>"Triglycerides", "UREA"=>"Urea", "08M"=>"Urine albumin", "WBC"=>"WCC "}

    @labs.each do |lab|

      if @orders[lab.lab_result_id].nil?

        @orders[lab.lab_result_id] = {
          "request_number" => "#{lab.request_number}",
          "test_code" => "#{(mapping[lab.test_code].blank? ? lab.test_code : mapping[lab.test_code])}",
          "timestamp" => "#{lab.timestamp}"
        }

      end

      @orders[lab.lab_result_id][lab.field_name] = "#{lab.field_value}"

    end

    render :layout => false
  end

  def results
    @patient = Patient.find(params[:id]) rescue nil

    @orders = LabOrder.find(:all, :conditions => ["patient_id = ?", @patient.id]) rescue []

    @closed = []

    @orders.each do |order|
      if !order.result.blank?
        @closed << order
      end
    end

    render :layout => false
  end

  def check_results
    results = @prelink.get_new_results rescue nil

    if !results.nil?

      if results.class.to_s.upcase == "ARRAY"

        results.each do |result|

          order = LabOrder.find_by_request_number(result[:request_number]) # rescue nil

          order.update_attributes(
            :result => result[:result],
            :test_unit => result[:test_unit],
            :test_range => result[:test_range],
            :colour => result[:colour],
            :date_result_received => Time.now
          ) if !order.nil?
        end

        @new_results = results.length rescue 0

      else

        order = LabOrder.find_by_request_number(results[:request_number]) # rescue nil

        order.update_attributes(
          :result => results[:result],
          :test_unit => results[:test_unit],
          :test_range => results[:test_range],
          :colour => results[:colour],
          :date_result_received => Time.now
        ) if !order.nil?

        @new_results = 1

      end

    else

      @new_results = 0

    end

    # render :text => results.length rescue 0
  end

  def query
    results = @prelink.get_new_results rescue nil
    # [{:patient_id=>nil, :request_number=>"SPN96", :result=>"Positive", :test_unit=>"Mg/l", :test_range=>"0-9", :colour=>"Red", :"@diffgr:id"=>"Result1", :"@msdata:row_order"=>"0"}, {

    # raise results.inspect
    
    if !results.nil?

      if results.class.to_s.upcase == "ARRAY"

        results.each do |result|

          if !result[:clinic_patient_id].nil? && result.keys.include?(:test_code)

            id = Person.search_by_identifier(result[:clinic_patient_id]).first.id rescue nil

            if !id.nil?

              previous_order = LabResult.find_by_request_number(result[:request_number],
                :conditions => ["test_code = ?", result[:test_code]])

              if previous_order.nil?

                order = LabResult.create(
                  {
                    :patient_id => id,
                    :national_id => result[:clinic_patient_id],
                    :request_number => result[:request_number],
                    :test_code => result[:test_code],
                    :voided => 0
                  }
                )

                result.each do |key, value|

                  LabResultDetails.create(
                    {
                      :lab_result_id => order.id,
                      :field_name => key.to_s,
                      :field_value => value,
                      :voided => 0
                    }
                  ) if key != :request_number && key != :clinic_patient_id &&
                    !key.to_s.match(/@/) && key != :test_code && value.class.to_s.upcase != "HASH"

                end

              else

                LabResultDetails.find_all_by_lab_result_id(previous_order.id).each{|lab|
                  lab.void
                }

                result.each do |key, value|

                  LabResultDetails.create(
                    {
                      :lab_result_id => previous_order.id,
                      :field_name => key.to_s,
                      :field_value => value,
                      :voided => 0
                    }
                  ) if key != :request_number && key != :clinic_patient_id &&
                    !key.to_s.match(/@/) && key != :test_code && value.class.to_s.upcase != "HASH"

                end

              end

            end

          end

        end

        @new_results = results.length rescue 0

      else

        if !results[:clinic_patient_id].nil? && results.keys.include?(:test_code)

          id = Person.search_by_identifier(results[:clinic_patient_id]).first.id rescue nil

          if !id.nil?

            previous_order = LabResult.find_by_request_number(results[:request_number],
              :conditions => ["test_code = ?", results[:test_code]])

            if previous_order.nil?

              order = LabResult.create(
                {
                  :patient_id => id,
                  :national_id => results[:clinic_patient_id],
                  :request_number => results[:request_number],
                  :test_code => results[:test_code],
                  :voided => 0
                }
              )

              results.each do |key, value|

                LabResultDetails.create(
                  {
                    :lab_result_id => order.id,
                    :field_name => key.to_s,
                    :field_value => value,
                    :voided => 0
                  }
                ) if key != :request_number && key != :clinic_patient_id &&
                  !key.to_s.match(/@/) && key != :test_code && value.class.to_s.upcase != "HASH"

              end

            else

              LabResultDetails.find_all_by_lab_result_id(previous_order.id).each{|lab|
                lab.void
              }

              results.each do |key, value|

                LabResultDetails.create(
                  {
                    :lab_result_id => previous_order.id,
                    :field_name => key.to_s,
                    :field_value => value,
                    :voided => 0
                  }
                ) if key != :request_number && key != :clinic_patient_id &&
                  !key.to_s.match(/@/) && key != :test_code && value.class.to_s.upcase != "HASH"

              end

            end

          end

        end

        @new_results = 1
      end

    else

      @new_results = 0

    end

    render :layout => "lab_application"

  end

  def check_by_date
    @patient_id = params[:id]
    
    render :layout => "lab_application"
  end

  def check_result_by_date
    
    s_d = params["StartDate"].split("-")
    start_date = s_d[2] + s_d[1] + s_d[0]

    e_d = params["EndDate"].split("-")
    end_date = e_d[2] + e_d[1] + e_d[0]

    national_id = PatientIdentifier.find_by_patient_id(params[:patient_id],
      :conditions => ["identifier_type = ?",
        PatientIdentifierType.find_by_name("National id").id]).identifier rescue nil

    results = @prelink.get_results_by_date({:national_id => national_id,
        :start_date => start_date, :end_date => end_date}) rescue nil

    @patient_id = params["patient_id"]

    if !results.nil?

      if results.class.to_s.upcase == "ARRAY"

        results.each do |result|

          if result.keys.include?(:test_code)

            id = @patient_id rescue nil

            if !id.nil?

              previous_order = LabResult.find_by_request_number(result[:request_number],
                :conditions => ["test_code = ?", result[:test_code]])

              if previous_order.blank?

                order = LabResult.create(
                  {
                    :patient_id => id,
                    :national_id => national_id,
                    :request_number => result[:request_number],
                    :test_code => result[:test_code],
                    :voided => 0
                  }
                )

                result.each do |key, value|

                  LabResultDetails.create(
                    {
                      :lab_result_id => order.id,
                      :field_name => key.to_s,
                      :field_value => value,
                      :voided => 0
                    }
                  ) if key != :request_number && key != :clinic_patient_id &&
                    !key.to_s.match(/@/) && key != :test_code && value.class.to_s.upcase != "HASH"

                end

              else

                LabResultDetails.find_all_by_lab_result_id(previous_order.id).each{|lab|
                  lab.void
                }

                result.each do |key, value|

                  LabResultDetails.create(
                    {
                      :lab_result_id => previous_order.id,
                      :field_name => key.to_s,
                      :field_value => value,
                      :voided => 0
                    }
                  ) if key != :request_number && key != :clinic_patient_id &&
                    !key.to_s.match(/@/) && key != :test_code && value.class.to_s.upcase != "HASH"

                end

              end

            end

          end

        end

        @new_results = results.length rescue 0

      else

        if !results[:clinic_patient_id].nil? && results.keys.include?(:test_code)

          id = Person.search_by_identifier(results[:clinic_patient_id]).first.id rescue nil

          if !id.nil?

            previous_order = LabResult.find_by_request_number(results[:request_number],
              :conditions => ["test_code = ?", results[:test_code]])

            if previous_order.nil?

              order = LabResult.create(
                {
                  :patient_id => id,
                  :national_id => national_id,
                  :request_number => results[:request_number],
                  :test_code => results[:test_code],
                  :voided => 0
                }
              )

              results.each do |key, value|

                LabResultDetails.create(
                  {
                    :lab_result_id => order.id,
                    :field_name => key,
                    :field_value => value,
                    :voided => 0
                  }
                ) if key != :request_number && key != :clinic_patient_id &&
                  !key.to_s.match(/@/) && key != :test_code

              end

            else

              LabResultDetails.find_all_by_lab_result_id(previous_order.id).each{|lab|
                lab.void
              }

              results.each do |key, value|

                LabResultDetails.create(
                  {
                    :lab_result_id => previous_order.id,
                    :field_name => key,
                    :field_value => value,
                    :voided => 0
                  }
                ) if key != :request_number && key != :clinic_patient_id &&
                  !key.to_s.match(/@/) && key != :test_code

              end

            end

          end

        end

        @new_results = 1
      end

    else

      @new_results = 0

    end

    redirect_to "/lab/show/#{@patient_id}" and return
  end

  def void
    @order = LabOrder.find(params[:id])
    @patient_id = @order.patient_id
    @order.void

    redirect_to "/lab/show/#{@patient_id}" and return
  end

  def print_order
    @order = LabOrder.find(params[:id])
    @patient = Patient.find(@order.patient_id)

    print_and_redirect("/lab/print/#{params[:id]}", "/#{(params[:redirect_url] || "/show")}/#{@patient.id}") and return

  end

  def print
    ids = params[:id].split(";")

    print_string = ''

    ids.each do |id|
      @order = LabOrder.find(id)
      @patient = Patient.find(@order.patient_id)

      print_string += '
N
q500
Q165,026
ZT
A40,50,0,2,1,1,N,"' + (@order.date_collected || Time.now).strftime("%d %b %Y %H:%M") + ' ' + @order.national_id + '"
A40,76,0,2,1,1,N,"' + @patient.person.name + ' ' + @order.request_number + '"
A40,102,0,2,1,1,R,"' + @order.test_code + '"
B50,130,0,1,4,8,20,N,"' + @order.request_number + '"
P1
      '
    end

    send_data(print_string,:type=>"application/label; charset=utf-8", :stream=> false, :filename=>"#{@patient.id}#{rand(10000)}.lbs", :disposition => "inline")
  end

end
