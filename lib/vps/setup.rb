module Vps
  class << self
    def setup address, project
      # Initialize resource in instances project
      self.resource address, project

      # Install default Script
      self.default_script

      # Sleep waiting server restart
      sleep 10

      # Install configuration Script
      self.configuration_script

      logger "Done!"
    end

    private

    def resource address, project
      @address = address
      @project = project
    end

    def default_script
      session :root, rails_command
    end

    self.def configuration_script
      session :rails, rails_command
    end

    def rails_command
      command = Vps::Script.rails_script["cmd"]
      [12, 15].each do |i|
        command[i] = command[i] % @project
      end
      command
    end

    def root_command
      Vps::Script.root_script["cmd"]
    end

    def log_stdout stream
      print data  if stream == :stdout
    end

    def session user, commands
      Net::SSH.start(@address, user) do |session|
        commands.each do |cmd|
          @bar.increment!
          session.exec! cmd do |channel, stream, data|
            channel.send_data( "Y\n" )
          end
        end
      end
    end

    def logger msg
      puts "\n"
      puts "#{msg}"
      puts "\n"
    end
  end
end
