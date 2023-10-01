# frozen_string_literal: true

require 'optparse'
require 'etc'

INITIAL_COLUMN = 3

def run
  opts_hash = ARGV.getopts('alr')
  options = opts_hash.keys.select { |k| opts_hash[k] }.sort
  files = get_files_by_option(options)
  if options.empty? || !options.include?('l')
    ls_column(files)
  else
    ls_opt_long(files)
  end
end

def get_files_by_option(opts)
  files = Dir.glob('*').sort
  files = Dir.entries('.').sort if opts.include?('a')
  files.reverse! if opts.include?('r')
  files
end

def calculate_row_and_space(all_files)
  div, mod = all_files.size.divmod(INITIAL_COLUMN)
  total_row = mod.zero? ? div : (div + 1)
  width = all_files.max_by(&:length).length + 7
  [total_row, width]
end

def ls_column(all_files)
  total_row, width = calculate_row_and_space(all_files)
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
  {
    file: '-',
    directory: 'd',
    characterSpecial: 'c',
    blockSpecial: 'b',
    fifo: 'p',
    link: 'l',
    socket: 's',
    unknown: 'u'
  }[file_stat.ftype.to_sym]
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
  file_permission_number.each_char.map { |c| file_permission_string[c.to_i] }.join
end

def get_file_stat(all_files)
  total_blocks = 0
  file_list = all_files.map do |file|
    fs = File::Stat.new(file)
    file_mtime = fs.mtime
    total_blocks += fs.blocks
    [
      convert_to_file_type(fs) + convert_to_file_permission(fs),
      fs.nlink.to_i,
      Etc.getpwuid(fs.uid).name,
      Etc.getgrgid(fs.gid).name,
      fs.size,
      file_mtime.month,
      file_mtime.day,
      file_mtime.strftime('%H:%M'),
      file
    ]
  end
  [file_list, total_blocks]
end

def adjust_elements(bfl, idx)
  if bfl.first.is_a?(String)
    max_length = bfl.max_by(&:length).length
    width = ![7, 8].include?(idx) ? max_length + 1 : max_length
    bfl.map! { |element| element.ljust(width) }
  else
    max_length = bfl.max.to_s.length
    width = idx == 5 ? max_length + 1 : max_length
    bfl.map! { |element| element.to_s.rjust(width) }
  end
end

def print_file_list(file_list, total_blocks)
  puts "total #{total_blocks}"
  file_list.each do |list|
    puts list.join(' ')
  end
end

def ls_opt_long(all_files)
  file_list, total_blocks = get_file_stat(all_files)
  file_list = file_list.transpose.each_with_index { |bfl, i| adjust_elements(bfl, i) }.transpose
  print_file_list(file_list, total_blocks)
end

run
