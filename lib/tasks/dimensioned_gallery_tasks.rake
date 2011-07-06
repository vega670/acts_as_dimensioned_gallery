namespace :dimensioned_gallery do
  desc "Initializes gallery directory"
  task :initialize => :environment do
    FileUtils.mkdir_p("#{RAILS_ROOT}/public/#{Gallery.path}")
  end

  desc "Sets the gallery directory relative to Rails root and creates the directory"
  task :setup, :path, :needs => :environment do |t, args|
    
  end
end

namespace :db do
  namespace :migrate do
    description = "Migrate the database through scripts in vendor/plugin/acts_as_dimensioned_gallery/lib/db/migrate"
    description << "and update db/schema.rb by invoking db:schema:dump."
    description << "Target specific version with VERSION=x. Turn off output with VERBOSE=false."
    
    desc description
    task :dimensioned_gallery => :environment do
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate("vendor/plugins/acts_as_dimensioned_gallery/lib/db/migrate", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end
  end
end
