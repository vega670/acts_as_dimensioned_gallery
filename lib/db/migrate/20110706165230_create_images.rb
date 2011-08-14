class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :name
      t.text :description
      t.string :original_filename
      t.string :extension
      t.integer :height
      t.integer :width
      t.references :gallery
      
      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
