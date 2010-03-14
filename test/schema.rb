ActiveRecord::Schema.define(:version => 0) do
  create_table :work_examples, :force => true do |t|
    t.string :client
    t.text :description
    t.string :url
    t.string :url_text
    t.boolean :links
  end

  create_table :work_options, :force => true do |t|
    t.string :client
    t.text :description
    t.string :url
    t.string :url_text
    t.boolean :links
  end
  
end