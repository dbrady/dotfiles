# loading a file from disk that contains JSON directly into memory is a huge
# PITA in Ruby, and it shouldn't be. This creates a method directly on the
# module, JSON.load_file(filename), that does exactly what you'd expect.
require 'json'
module JSON
  def self.load_file(filename, options={})
    parse File.read(filename)
  end

  def self.purtify(json)
    pretty_generate parse json
  end
end
$stderr.puts "So, doin' a lot of JSON work lately, eh? I just created JSON.load_file(filename [, options]) for you. You're welcome. ([options] are so can symbolize_names: true)"
$stderr.puts "Also! I just added JSON.purtify(json). It does JSON.pretty_generate(JSON.parse(json)) so you don't have to!"
