ActiveRecord::Schema.define(:version => 0) do
  create_table :galleries, :force => true do |t|
    t.string :name
    t.text :description
    t.references :holder, :polymorphic => true
    t.references :gallery_image
    t.references :gallery_dimension
    t.timestamps
  end
  create_table :images, :force => true do |t|
    t.string :name
    t.text :description
    t.string :original_filename
    t.string :extension
    t.integer :height
    t.integer :width
    t.references :gallery
    t.timestamps
  end
  create_table :dimensions, :force => true do |t|
    t.string :name
    t.integer :height
    t.integer :width
    t.float :aspect
    t.boolean :crop
    t.boolean :resize
    t.timestamps
  end
  create_table :gallery_dimensions, :force =. true do |t|
    t.references :gallery
    t.references :dimension
end
