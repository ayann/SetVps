module Vps
  module Command
    class << self
      def app_path
        File.expand_path(File.join(File.dirname(__FILE__), '../../'))
      end

      [:root, :rails].each do |method|
        define_method("#{method}") do
          begin
            YAML.load_file send("#{method}_command_file")
          rescue Psych::SyntaxError, Errno::EACCES, Errno::ENOENT
            {}
          end
        end
      end

      private

      [:root, :rails].each do |method|
        define_method("#{method}_command_file") do
          File.join(app_path, "commands/#{method}.yml")
        end
      end
    end
  end
end
