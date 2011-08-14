class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.string :name
      t.text :description
      t.references :holder, :polymorphic => true
      t.references :gallery_image
      t.references :gallery_dimension
      
      t.timestamps
    end
  end

  def self.down
    drop_table :galleries
  end
end
