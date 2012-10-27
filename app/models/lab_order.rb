class LabOrder < ActiveRecord::Base
  self.establish_connection :prelink_gateway
  set_table_name "lab_order"
  set_primary_key "lab_order_id"

  self.default_scope :conditions => "#{self.table_name}.voided = 0"

  def void
    self.update_attribute("voided", 1)
  end

end
