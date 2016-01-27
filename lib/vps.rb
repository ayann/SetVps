# Require Yaml module
require 'yaml'
require 'net/ssh'
require 'progress_bar'

require "vps/setup"
require "vps/version"
require "vps/commands"

module Vps
  @bar = ProgressBar.new(Vps::Command.root["cmd"].count + Vps::Command.rails["cmd"].count)
end
