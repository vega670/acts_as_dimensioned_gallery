namespace :dimensioned_gallery do
  desc "Initializes gallery directory"
  task :initialize => :environment do
    FileUtils.mkdir_p(Gallery.absolute_path)
  end

=begin
  desc "Sets the gallery directory relative to Rails root and creates the directory"
  task :setup, :path, :needs => :environment do |t, args|
    
  end
=end
end

namespace :db do
  namespace :migrate do
    desc "Migrate the database through scripts in vendor/plugin/acts_as_dimensioned_gallery/lib/db/migrate."
    task :dimensioned_gallery => :environment do
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
      ActiveRecord::Migrator.migrate("vendor/plugins/acts_as_dimensioned_gallery/lib/db/migrate", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end
  end
end
