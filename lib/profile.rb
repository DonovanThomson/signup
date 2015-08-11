require 'fileutils'

module EngineNotebook

  class Profile

    def profile_name
      "engine-notebook"
    end

    def create!
      validate!
      run_ipython_create_profile!
      add_config!
      create_static_symlink!
    end

    def launch_ipython!
      exec("ipython notebook --profile=engine-notebook")
    end

    private

    def validate!
      version = `ipython --version`
      raise "iPython not found. Installing Anaconda packages recommended" if $?.exitstatus > 0
      raise "Upgrade iPython (Anaconda packages recommended)" if version[0].to_i < 2
    end

    def run_ipython_create_profile!
      current_profile = `ipython profile locate engine-notebook`.strip
      FileUtils.rm_r(current_profile) if $? == 0
      `ipython profile create engine-notebook`
    end

    def add_config!
      File.open(self.class.config_path, 'a') { |f| f.write engine_notebook_config }
    end

    def create_static_symlink!
      src, dst = static_path, File.join(self.class.profile_path, 'static')
      FileUtils.rm_r dst
      File.symlink src, dst
    end

    def self.config_path
      File.join(profile_path, "ipython_config.py")
    end

    def self.profile_path
      `ipython profile locate engine-notebook`.strip
    end

    def static_path
      File.join(File.dirname(__FILE__), "static")
    end

    def engine_notebook_config
      File.read(File.join(File.dirname(__FILE__), "profile_config")) % kernel_args.inspect
    end

    def kernel_args
      kernel_args = []
      kernel_args << ENV['BUNDLE_BIN_PATH'] << 'exec' if ENV['BUNDLE_BIN_PATH']
      kernel_args + ["bundle", "exec", "rake", "notebook:kernel" , "connection_file={connection_file}"]
    end


  end

end