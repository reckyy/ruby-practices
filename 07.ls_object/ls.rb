# frozen_string_literal: true

class Ls
  INITIAL_COLUMN = 3

  def self.ls_column(files)
    rows, width = calculate_row_and_space(files)
    all_sort_files = files.each_slice(rows).to_a
    rows.times do |col|
      INITIAL_COLUMN.times do |row|
        file_name = all_sort_files[row][col]
        print file_name.ljust(width) unless file_name.nil?
      end
      puts
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
