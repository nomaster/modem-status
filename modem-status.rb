#!/usr/bin/env ruby

require('open-uri')
require('rubygems')
require('nokogiri')

doc = Nokogiri::HTML.parse(open('http://192.168.100.1/system.asp'))
doc.css("tr").each do |tr|
  tr.each{|a| a.content.gsub!(/\s*/,'')}
  label = tr.css("td").first.content.gsub(/\s+/, " ").strip
  value = tr.css("td").last.content.gsub(/\s+/, " ").strip
  value.slice!(0)
  constraints = 34..100 if label == "Signal to Noise Ratio"
  constraints = -5..10 if label == "Receive Power Level"
  constraints = 43..50 if label == "Transmit Power Level"
  if constraints
    if constraints.cover?(value.to_f)
      warning = "OK"
    else
      warning = "WARNING"
    end
    puts label + " " + constraints.to_s
    puts value + " " + warning.to_s
  else
    puts label
    puts value
  end
  puts
end
