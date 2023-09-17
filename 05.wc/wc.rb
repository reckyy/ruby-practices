# frozen_string_literal: true

require 'optparse'

def run
	opts_hash = ARGV.getopts('clw')
	options = opts_hash.keys.select { |k| opts_hash[k] }.sort
  options = ['c', 'l', 'w'] if options.empty?
	if $stdin.tty?
		wc_list = []
		ARGV.each do |file|
			content = open(file, 'r')
      wc_list << wc(options, content.read)
			wc_list << file
		end
		puts wc_list.join(' ')
	else
		content = $stdin.read
		wc_list = wc(options, content)
		puts wc_list.join(' ')
	end
end

def wc(opts, f)
	[
    opts.include?('l') ? f.lines.size : nil,
    opts.include?('w') ? f.split.size : nil,
    opts.include?('c') ? f.bytesize : nil,
	]
end

run
