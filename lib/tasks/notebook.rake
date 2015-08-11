namespace :notebook do

  desc "Backs up all the file attachments for a given survey ID"
  task :server => :environment do
    require 'engine_notebook'
    EngineNotebook.start!
  end

  task :kernel => :environment do
    require 'iruby'
    IRuby::Kernel.new(ENV['connection_file']).run
  end
end
