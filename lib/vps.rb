# Require Yaml module
require 'yaml'
require 'net/ssh'
require "vps/version"
require "vps/scripts"
require "vps/setup"
require 'progress_bar'

module Vps
  @bar = ProgressBar.new
end
