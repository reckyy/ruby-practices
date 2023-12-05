# frozen_string_literal: true

require_relative 'myfilestat'

class Format
  INITIAL_COLUMN = 3

  def initialize(file_list)
    @file_list = file_list
  end

  def ls_column
    rows, width = calculate_row_and_space
    if @file_list.size <= 3
      @file_list.each { |f| print f.ljust(width) }
      puts
    elsif @file_list.size == 4
      transposed_files = @file_list.each_slice(rows).to_a.transpose
      transposed_files[0].each { |tf| print tf.ljust(width) }
      print transposed_files[1][0].ljust(width)
      puts
      puts transposed_files[1][1]
    else
      all_sort_files = @file_list.each_slice(rows).to_a
      rows.times do |col|
        INITIAL_COLUMN.times do |row|
          file_name = all_sort_files[row][col]
          print file_name.ljust(width) unless file_name.nil?
        end
        puts
      end
    end
  end

  def ls_opt_long
    fs = MyFileStat.new(@file_list)
    adjusted_fs_info = fs.info.transpose.each_with_index { |file_attribute, i| adjust_elements(file_attribute, i) }.transpose
    print_file_list(adjusted_fs_info, fs.total_blocks)
  end


  private

  def calculate_row_and_space
    div, mod = @file_list.size.divmod(INITIAL_COLUMN)
    rows = mod.zero? ? div : (div + 1)
    width = @file_list.max_by(&:length).length + 7
    [rows, width]
  end

  def print_file_list(file_list, total_blocks)
    puts "total #{total_blocks}"
    file_list.each do |list|
      puts list.join(' ')
    end
  end

  def adjust_elements(file_attribute, idx)
    if file_attribute.first.is_a?(String)
      max_length = file_attribute.max_by(&:length).length
      width = ![7, 8].include?(idx) ? max_length + 1 : max_length
      file_attribute.map! { |element| element.ljust(width) }
    else
      max_length = file_attribute.max.to_s.length
      width = idx == 6 ? max_length + 1 : max_length
      file_attribute.map! { |element| element.to_s.rjust(width) }
    end
  end
end
