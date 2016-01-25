module Vps
  module Script
    class << self
      def app_path
        File.expand_path(File.join(File.dirname(__FILE__), '../../'))
      end

      [:root, :rails].each do |method|
        define_method("#{method}_script") do
          begin
            YAML.load_file send("#{method}_script_path")
          rescue Psych::SyntaxError, Errno::EACCES, Errno::ENOENT
            {}
          end
        end
      end

      private

      [:root, :rails].each do |method|
        define_method("#{method}_script_path") do
          File.join(app_path, "scripts/#{method}.yml")
        end
      end
    end
  end
end
