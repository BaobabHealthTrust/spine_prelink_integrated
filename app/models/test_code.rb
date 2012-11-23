class TestCode < ActiveRecord::Base
  self.establish_connection :prelink_gateway
  set_table_name "test_codes"

end
