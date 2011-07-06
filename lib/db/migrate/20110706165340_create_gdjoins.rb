class CreateGdjoins < ActiveRecord::Migration
  def self.up
    create_table :gdjoins do |t|
      t.references :gallery
      t.references :dimension
    end
  end

  def self.down
  end
end
