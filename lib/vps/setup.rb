module Vps
  class << self
    def setup address, project
      # Initialize resource in instances project
      resource address, project

      # Install default Script
      session :root, root_command

      # Sleep waiting server restart
      sleep 10

      # Install configuration Script
      begin
        session :rails, rails_command
      rescue Exception => exception
        sleep 2
        retry
      end

      logger "Done!"
    end

    private

    def resource address, project
      @address = address
      @project = project
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

    def root_command
      Vps::Script.root_script["cmd"]
    end

    def rails_command
      Vps::Script.rails_script["cmd"].map do |cmd|
        cmd % ([@project] * 2)
      end
    end

    def log_stdout stream
      print data  if stream == :stdout
    end

    def logger msg
      puts "\n"
      puts "#{msg}"
      puts "\n"
    end
  end
end
