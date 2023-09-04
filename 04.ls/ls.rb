# frozen_string_literal: true

require 'optparse'
require 'etc'

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

def convert_to_file_permission(file_stat)
  file_permission_number = file_stat.mode.to_s(8).slice(-3..-1)
  file_permission_string = {
    0 => '---',
    1 => '--x',
    2 => '-w-',
    3 => '-wx',
    4 => 'r--',
    5 => 'r-x',
    6 => 'rw-',
    7 => 'rwx'
  }
  file_permission_type = ''
  file_permission_number.each_char do |c|
    file_permission_type += file_permission_string[c.to_i]
  end
  file_permission_type
end

def get_file_stat(all_files, file_list)
  total_blocks = 0
  all_files.each do |file|
    file_stat = []
    fs = File::Stat.new(file)
    total_blocks += fs.blocks
    file_stat << convert_to_file_type(fs) + convert_to_file_permission(fs)
    file_stat << fs.nlink.to_i
    file_stat << Etc.getpwuid(fs.uid).name
    file_stat << Etc.getgrgid(fs.gid).name
    file_stat << fs.size
    file_mtime = fs.mtime
    file_stat << file_mtime.month
    file_stat << file_mtime.day
    file_stat << file_mtime.strftime("%H:%M")
    file_stat << file
    file_list << file_stat
  end
  total_blocks
end

def resize_file_list(file_list)
  before_resize_file_list = file_list.transpose
  before_resize_file_list.each_with_index do |bfl, i|
    if bfl.first.is_a?(String)
      max = bfl.max_by(&:length).length
      max += 1 if ![7, 8].include?(i)
      bfl.map! { |element| element.ljust(max) }
    else
      max = bfl.max.to_s.length
      max += 1 if i == 4
      bfl.map! { |element| element.to_s.rjust(max) }
    end
  end
  resized_file_list = before_resize_file_list.transpose
  resized_file_list
end

def print_file_list(file_list, total_blocks)
  puts "total #{total_blocks}"
  file_list.each do |list|
    puts list.join(' ')
  end
end

def ls_l(all_files)
  file_list = []
  total_blocks = get_file_stat(all_files, file_list)
  file_list = resize_file_list(file_list)
  print_file_list(file_list, total_blocks)
end

parse_file
