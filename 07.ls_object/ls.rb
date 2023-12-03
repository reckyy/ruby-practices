# frozen_string_literal: true

class Ls
  INITIAL_COLUMN = 3

  def self.ls_column(files)
    rows, width = calculate_row_and_space(files)
    if files.size <= 3
      files.each { |f| print f.ljust(width) }
      puts
    elsif files.size == 4
      transposed_files = files.each_slice(rows).to_a.transpose
      transposed_files[0].each { |tf| print tf.ljust(width) }
      print transposed_files[1][0].ljust(width)
      puts
      puts transposed_files[1][1]
    else
      all_sort_files = files.each_slice(rows).to_a
      rows.times do |col|
        INITIAL_COLUMN.times do |row|
          file_name = all_sort_files[row][col]
          print file_name.ljust(width) unless file_name.nil?
        end
        puts
      end
    end
  end

  def self.print_file_list(file_list, total_blocks)
    puts "total #{total_blocks}"
    file_list.each do |list|
      puts list.join(' ')
    end
  end

  def self.calculate_row_and_space(files)
    div, mod = files.size.divmod(INITIAL_COLUMN)
    rows = mod.zero? ? div : (div + 1)
    width = files.max_by(&:length).length + 7
    [rows, width]
  end
end
