# Require Yaml module
require 'yaml'
require 'net/ssh'
require "vps/version"
require "vps/scripts"
require "vps/setup"
require 'progress_bar'

module Vps
  @bar = ProgressBar.new(Vps::Script.root_script["cmd"].count + Vps::Script.rails_script["cmd"].count)
end
