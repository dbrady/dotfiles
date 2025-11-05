#!/usr/bin/env ruby

# begin
#   # looksee is awesome. Adds gorgeous Object#ls method
#   # https://github.com/oggy/looksee
#   require 'looksee'
# rescue LoadError => e
#   $stderr.puts "~/.irbrc:#{__LINE__}: Could not load looksee/shortcuts: looksee gem not present in this gemset"
# end

require File.expand_path("~/dotfiles/json_load_file")
require File.expand_path("~/dotfiles/xml_load_file")
require File.expand_path("~/dotfiles/just_your_methods")
require File.expand_path("~/private_bin/acima_methods")

def code(path, create: false)
  path = File.expand_path(path)
  if !(File.exist?(path) || create)
    puts "Cannot open #{path}. Does it exist? If you want to rerun with create: true"
    return nil
  end
  system "code", path
end
puts "Kernel#code(path) created. code <file> to open in VSCode."

# Hello Acima MP Rails
if defined? Rails

  # model.schema /
  class ApplicationRecord
    class <<self
      def schema(format: nil)
        raise ArgumentError, "format must be :sql or :ruby" if format && ![:sql, :ruby].include?(format)
        # run schema-peek on my table
        command = "#{File.expand_path('~/bin/schema-peek')} #{table_name}"
        puts `#{command}`
      end
    end

    def schema(format: nil)
      self.class.schema
    end
  end

  # Call this and it will display the next line of source code
  def log_next_line!
    file, line, _ = caller.first.split(/:/)
    line = line.to_i
    source = File.readlines(file)[line]
    source.chomp
    puts source.cyan
  end


end
# End Rails

# jp - like pp, but in JSON.
# - if it response to as_json, it calls that, so jp rails_object will work.
# - if it's a string, tries to JSON parse it first. So jp '{"pants": 42}' will work, and so will jp object.to_json (even though as_json would be more efficient)
def jp(object)
  data = if object.respond_to? :as_json
           object.as_json
         else
           begin
             JSON.parse(object)
           rescue JSON::ParserError
             object
           end
         end

  # TODO: COLORIZE ME. Sadly we don't get that for free from pretty_generate.
  puts JSON.pretty_generate(data)
end

# array_to_table - poor man's text-table
def array_to_table(rows)
  return "" if rows.empty?

  left_justify = Hash.new(false)
  longests = Hash.new(0)

  rows.each do |row|
    row.each.with_index do |item, index|
      left_justify[index] ||= item.to_s =~ /[^0-9\-+.,]/
      longests[index] = [(longests[index] || 0), item.to_s.size].max
    end
  end

  formats = longests.keys.map do |key|
    size = longests[key]
    sign = left_justify[key] ? "-" : ""

    "%#{sign}#{size}s"
  end

  format = "| #{formats.join(' | ')} |"

  rows.each do |row|
    puts format % row
  end

  nil
end

# hash_to_table - poor man's text-table
#
# TODO: Do we care if the rows have different keys? Nah. You get what you get.
def hash_to_table(rows)
  return "" if rows.empty?

  left_justify = Hash.new(false)
  longests = Hash.new(0)

  rows.each do |row|
    row.each_pair do |key, value|
      left_justify[key] ||= value.to_s =~ /[^0-9+.,]/
      longests[key] = [key.size, longests[key], value.size].max
    end
  end

  formats = longests.keys.map do |key|
    size = longests[key]
    sign = left_justify[key] ? "-" : ""

    "%#{sign}#{size}s"
  end

  format = "| #{formats.join(' | ')} |"

  puts format % rows.first.keys

  rows.each do |row|
    puts format % row.values
  end

  nil
end

def to_table(rows)
  return "" if rows.empty?

  longests = Hash.new(0)

  rows.each do |row|
    if row.is_a? Hash
      row.keys.each_pair {|key, value| longests[key] = [key.size, value.to_s.size, longests[key]].max }
    else
      row.each.with_index {|value, index| longests[index] = [value.to_s.size, longests[index]].max }
    end
  end

  format = "| " + longests.values.map {|size| "%#{size}s" }.join(" | ") + " |"

  rows.each do |row|
    values = row.values rescue row
    puts format % values
  end

  nil
end
