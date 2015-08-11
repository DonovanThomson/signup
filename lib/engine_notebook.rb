

module EngineNotebook

  def self.start!
    require 'profile'
    EngineNotebook::Profile.new.tap do |p|
      p.create!
      p.launch_ipython!
    end

  end

end