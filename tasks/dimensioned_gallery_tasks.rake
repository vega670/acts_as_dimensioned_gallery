namespace :dimensioned_gallery do
  desc "Initializes gallery directory"
  task :initialize => :environment do
    FileUtils.mkdir_p("#{RAILS_ROOT}/public/#{Gallery.path}")
  end

  desc "Sets the gallery directory relative to Rails root and creates the directory"
  task :setup, :path, :needs => :environment do |t, args|
    
  end
end