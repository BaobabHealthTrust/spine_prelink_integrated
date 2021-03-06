class CreateLocationDrugs < ActiveRecord::Migration
  def self.up
    create_table :location_drugs do |t|
      t.integer :drug_concept_id
      t.string :drug_concept_name
      t.integer :in_stock, :default => 1
      t.integer :created_by
      t.timestamps
    end
  end

  def self.down
    drop_table :location_drugs
  end
end
