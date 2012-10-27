class LabResultDetails < ActiveRecord::Base
  self.establish_connection :prelink_gateway
  set_table_name "lab_result_details"
  set_primary_key "lab_result_details_id"

  # self.default_scope :conditions => "#{self.table_name}.voided = 0"
  belongs_to :lab_result, :class_name => "LabResult", :foreign_key => :lab_result_id

  def void
    self.update_attribute("voided", 1)
  end

end
