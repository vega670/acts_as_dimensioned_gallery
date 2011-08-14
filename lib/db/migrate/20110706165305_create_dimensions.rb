class CreateDimensions < ActiveRecord::Migration
  def self.up
    create_table :dimensions do |t|
      t.string :name
      t.integer :height
      t.integer :width
      t.float :aspect
      t.boolean :crop
      t.boolean :resize
      
      t.timestamps
    end
  end

  def self.down
    drop_table :dimensions
  end
end
