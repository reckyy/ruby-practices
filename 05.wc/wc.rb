# frozen_string_literal: true

require 'debug'
require 'optparse'

def run
  opts_hash = ARGV.getopts('clw')
  options = opts_hash.any? ? %w[c l w] : opts_hash.keys.select { |k| opts_hash[k] }.sort
  analyses_command(options)
end

def adjust_and_printelements(elm)
  puts elm.map! { |e|
    if e.is_a?(String)
      e.ljust(1)
    else
      e.to_s.rjust(7)
    end
  }.join(' ')
end

def analyses_command(opts)
  if $stdin.tty?
    wc_list = []
    ARGV.each do |file|
      File.open(file, 'r') { |io| wc_list << wc(opts, io.read, file) }
    end
    insert_total(opts, wc_list) if ARGV.size >= 2
    wc_list.each { |wl| adjust_elements(wl) }
  else
    wc_list = wc(opts, $stdin.read)
    wc_list.map { |wl| print wl.to_s.rjust(6 + wl.to_s.length) }
    puts
  end
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

def wc(opts, content, name = nil)
  [
    opts.include?('l') ? content.lines.size : nil,
    opts.include?('w') ? content.split.size : nil,
    opts.include?('c') ? content.bytesize : nil,
    name
  ]
end

run
