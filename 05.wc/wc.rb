# frozen_string_literal: true

require 'debug'
require 'optparse'

def run
	opts_hash = ARGV.getopts('clw')
	options = opts_hash.any? ? ['c', 'l', 'w'] : opts_hash.keys.select { |k| opts_hash[k] }.sort
	if $stdin.tty?
		wc_list = []
		ARGV.each do |file|
			content = open(file, 'r')
      wc_list << wc(options, content.read, file)
		end
    insert_total(options, wc_list) if ARGV.size >= 2
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

def insert_total(options, wc_list)
  os = options.size
	total_row = Array.new(os, 0)
  total_row.push "total"
	wc_list.each do |wl|
		0.upto(os - 1) do |i|
			total_row[i] += wl[i]
		end
	end
  wc_list << total_row
end

def adjust_elements(elm)
  elm.map! { |e|
    if e.is_a?(String)
      e.ljust(1)
    else
      e.to_s.rjust(7)
    end
  }
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
