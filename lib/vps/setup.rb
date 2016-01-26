module Vps
  class << self
    def setup address
      @address = address

      root_step

      sleep 10

      begin
        rails_step
      rescue Exception => e
        sleep 0.5
        retry
      end
    end

    private

    def root_step
      Net::SSH.start(@address, :root) do |session|
        Vps::Script.root_script["cmd"].each do |command|
          logger command
          session.exec! command do |channel, stream, data|
            # @bar.increment!
            print data  if stream == :stdout
            channel.send_data( "Y\n" )
          end
        end
      end
    end

    def rails_step
      Net::SSH.start(@address, :rails) do |session|
        Vps::Script.rails_script["cmd"].each do |command|
          logger command
          session.exec! command do |channel, stream, data|
            # @bar.increment!
            print data  if stream == :stdout
            channel.send_data( "Y\n" )
          end
        end
      end

      logger 'Vps setup with success'
    end

    def logger command
      puts '#===================================================#'
      puts command
      puts '#===================================================#'
    end
  end
end
