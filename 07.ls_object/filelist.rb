# frozen_string_literal: true

require 'etc'
require_relative 'option'

class FileList
  INITIAL_COLUMN = 3

  def initialize
    @options = Option.new.extract_entered_option
    @files = retrieve_files_by_option
  end

  def show
    if @options.empty? || !@options.include?('l')
      ls_column
    else
      ls_opt_long
    end
  end

  private

  def retrieve_files_by_option
    files = Dir.glob('*').sort
    files = Dir.entries('.').sort if @options.include?('a')
    files.reverse! if @options.include?('r')
    files
  end

  def ls_column
    total_row, width = calculate_row_and_space
    all_sort_files = @files.each_slice(total_row).to_a
    total_row.times do |col|
      INITIAL_COLUMN.times do |row|
        file_name = all_sort_files[row][col]
        print file_name.ljust(width) unless file_name.nil?
      end
      puts
    end
  end

  def calculate_row_and_space
    div, mod = @files.size.divmod(INITIAL_COLUMN)
    total_row = mod.zero? ? div : (div + 1)
    width = @files.max_by(&:length).length + 7
    [total_row, width]
  end

  def ls_opt_long
    file_list, total_blocks = compile_file_stat
    file_list = file_list.transpose.each_with_index { |bfl, i| adjust_elements(bfl, i) }.transpose
    print_file_list(file_list, total_blocks)
  end

  def compile_file_stat
    total_blocks = 0
    file_list = @files.map do |file|
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
end
