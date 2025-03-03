# frozen_string_literal: true

require 'debug'
require 'optparse'

def run
  opts_hash = ARGV.getopts('clw')
  options = opts_hash.keys.select { |k| opts_hash[k] }.sort
  options = %w[c l w] if options.empty?
  analyses_command(options)
end

def analyses_command(opts)
  if $stdin.tty?
    wc_list = []
    ARGV.each do |file|
      File.open(file, 'r') { |io| wc_list << wc(opts, io.read, file) }
    end
    insert_total(opts, wc_list) if ARGV.size >= 2
    wc_list.each do |wl|
      adjust_elements(wl)
      add_space_and_print(wl)
    end
  else
    wc_list = wc(opts, $stdin.read)
    wc_list.map { |wl| print wl.to_s.rjust(8) }
    puts
  end
end

def wc(opts, content, name = nil)
  results = []
  results << content.lines.size if opts.include?('l')
  results << content.split.size if opts.include?('w')
  results << content.bytesize if opts.include?('c')
  results << name if name
  results
end

def insert_total(opts, wc_list)
  opts_size = opts.size
  total_row = Array.new(opts_size, 0)
  total_row.push 'total'
  wc_list.each do |wl|
    0.upto(opts_size - 1) do |i|
      total_row[i] += wl[i]
    end
  end
  wc_list << total_row
end

def adjust_elements(elm)
  elm.map! do |e|
    if e.is_a?(String)
      e.ljust(1)
    else
      e.to_s.rjust(7)
    end
  end
end

def add_space_and_print(elm)
  elm[0] = " #{elm[0]}"
  puts elm.join(' ')
end

run
