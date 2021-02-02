#!/usr/bin/env ruby

# This fixes the "Ctrl-p doesn't go up a line" problem in Docker.

# Details: https://stackoverflow.com/questions/20828657/docker-change-ctrlp-to-something-else

#  jam this code into ~/.docker/config.json: { "detachKeys": "ctrl-z,z" }
require 'json'

puts "Fixing ~/.docker/config.json so ctrl-p will work the way bash intended"

docker_folder = File.expand_path("~/.docker")

# if !File.directory?(docker_folder)
#   puts "Whoa, whoa. You don't even have a docker config folder. Cowardly refusing to proceed. Please INSTALL DOCKER FIRST."
#   puts "Directory does not exist: #{docker_folder}"
#   exit -1
# end

config_path = File.join(docker_folder, "config.json")
config = if File.exists? config_path
           puts "Ah, found an existing config file. Reading..."
           JSON.parse(IO.readlines(config_path).join(''))
         else
           puts "No config file yet? No problem. We'll create one..."
           {}
         end


if config.fetch("detachKeys", "") == "ctrl-z,z"
  puts "Your docker config is already patched--happily exiting."
else
  puts "Patching file..."
  config["detachKeys"] = "ctrl-z,z"
end

File.open(config_path, "w") do |fp|
  fp.puts JSON.pretty_generate(config)
end

puts "All done."
# TODO: Make me a setup script? Use Ruby to read the json config, amend
#  detachKeys and then re-emit? That way it will idempotently create or fix up
#  an existing docker config?
#
#  tail -n 3 dotdockerconfig.json > ~/.docker/config.json
#
# ruby -rjson 'config = JSON.parse(File.read(File.expand_path("~/.docker/config.json")) rescue {}; puts JSON.pretty_generate(config)'

# {
#   "detachKeys": "ctrl-z,z"
# }
