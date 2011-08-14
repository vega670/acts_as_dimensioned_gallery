class CreateGalleryDimensions < ActiveRecord::Migration
  def self.up
    create_table :gallery_dimensions do |t|
      t.references :gallery
      t.references :dimension
    end
  end

  def self.down
    drop_table :gallery_dimensions
  end
end
