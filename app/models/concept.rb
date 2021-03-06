class Concept < ActiveRecord::Base
  set_table_name :concept
  set_primary_key :concept_id
  include Openmrs

  named_scope :active, :conditions => ['concept.retired = 0']

  belongs_to :concept_class
  belongs_to :concept_datatype
  has_many :concept_answers do
    def limit(search_string)
      return self if search_string.blank?
      map{|concept_answer|
        concept_answer if concept_answer.name.match(search_string)
      }.compact
    end
  end

  has_many :concept_names
  has_many :answer_concept_names, :class_name => 'ConceptName'
  has_one :name, :class_name => 'ConceptName', :conditions => 'concept_name.voided = 0'

  has_many :drugs
  has_many :concept_sets #, :class_name => 'ConceptSet'

  def self.find_by_name(concept_name)
    Concept.find(:first, :joins => 'INNER JOIN concept_name on concept_name.concept_id = concept.concept_id', :conditions => ["concept.retired = 0 AND concept_name.voided = 0 AND concept_name.name =?", "#{concept_name}"])  
  end

  def short_name
    self.concept_names.collect{|c| c.name}.sort{|a,b| a.length <=> b.length}.first
  end

end
