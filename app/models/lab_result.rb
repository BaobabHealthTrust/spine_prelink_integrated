class LabResult < ActiveRecord::Base
  self.establish_connection :prelink_gateway
  set_table_name "lab_result"
  set_primary_key "lab_result_id"

  # self.default_scope :conditions => "#{self.table_name}.voided = 0"
  has_many :lab_result_details, :class_name => "LabResultDetails", :dependent => :destroy

  def void
    self.update_attribute("voided", 1)
  end

end
