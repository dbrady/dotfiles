# loading a file from disk that contains XML directly into memory is a minor
# PITA in Ruby, and it shouldn't be. This creates a global method, load_xml,
# that does exactly what you'd expect, as long as you expect it to use Nokogiri
# to load the xml file.
require "nokogiri"
def xml_load_file(filename)
  Nokogiri::XML(File.read(File.expand_path(filename)))
end
$stderr.puts "So, doin' a lot of XML work lately, eh? I just created xml_load_file(filename) for you. You're welcome."
