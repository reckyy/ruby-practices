# frozen_string_literal: true

require 'debug'
require 'optparse'

def run
	opts_hash = ARGV.getopts('clw')
	options = opts_hash.keys.select { |k| opts_hash[k] }.sort
  options = ['c', 'l', 'w'] if options.empty?
	if $stdin.tty?
		wc_list = []
		ARGV.each do |file|
			content = open(file, 'r')
      wc_list << wc(options, content.read, file)
		end
    wc_list.each { |wl| adjust_elements(wl) }
		wc_list.each do |wl|
      puts wl.join(' ')
    end
	else
		wc_list = wc(options, $stdin.read)
		wc_list.map { |wl| print wl.to_s.rjust(6 + wl.to_s.length) }
    puts
	end
end

def adjust_elements(elm)
  if elm.first.is_a?(String)
    elm.map! { |element| element.ljust(width) }
  else
    elm.map! { |element| element.to_s.rjust(7) }
  end
end

def wc(opts, f, name)
	[
    opts.include?('l') ? f.lines.size : nil,
    opts.include?('w') ? f.split.size : nil,
    opts.include?('c') ? f.bytesize : nil,
    name
	]
end

run

