# frozen_string_literal: true

require 'debug'
require 'optparse'

INITIAL_COLUMN = 3

def parse_file
  options = ARGV.getopts('l')
  if options['l']
    all_files = Dir.glob('*').sort
    ls_l(all_files)
  else
    all_files = Dir.glob('*').sort
    total_row, width = calculate_row_and_space(all_files)
    ls(all_files, total_row, width)
  end
end

def calculate_row_and_space(all_files)
  div, mod = all_files.size.divmod(INITIAL_COLUMN)
  total_row = mod.zero? ? div : (div + 1)
  width = all_files.max_by(&:length).length + 7
  [total_row, width]
end

def ls(all_files, total_row, width)
  all_sort_files = all_files.each_slice(total_row).to_a
  total_row.times do |col|
    INITIAL_COLUMN.times do |row|
      file_name = all_sort_files[row][col]
      print file_name.ljust(width) unless file_name.nil?
    end
    puts
  end
end

def convert_to_file_type(file_stat)
  all_file_type = {
    file: "-",
    directory: "d",
    characterSpecial: "c",
    blockSpecial: "b",
    fifo: "p",
    link: "l",
    socket: "s",
    unknown: "u"
  }
  file_type = all_file_type[file_stat.ftype.to_sym]
end

def get_file_stat(all_files, file_list)
  all_files.each do |file|
    file_stat = []
    fs = File::Stat.new(file)
    file_stat << convert_to_file_type(fs)
    file_list << file_stat
  end
end

def ls_l(all_files)
  file_list = []
  get_file_stat(all_files, file_list)
  puts file_list.join(' ')
end

parse_file
