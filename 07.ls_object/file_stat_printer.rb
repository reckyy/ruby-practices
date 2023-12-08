# frozen_string_literal: true

require_relative 'file_stat'

class FileStatPrinter
  INITIAL_COLUMN = 3

  def initialize(file_list)
    @files = file_list
  end

  def print_in_short_format
    rows, width = calculate_row_and_space
    formated_files = @files.map { |file| file.ljust(width) }
    listed_files = formated_files.each_slice(rows).to_a
    adjusted_files = listed_files.map { |array| array.values_at(0..(rows - 1)) }.transpose
    adjusted_files.each do |array|
      puts array.join('')
    end
  end

  def print_in_long_format
    file_stats = @files.map { |file| Ls::FileStat.new(file) }
    max_width = calculate_max_width(file_stats)
    total_blocks = file_stats.map(&:block).sum
    print_file_stat(file_stats, total_blocks, max_width)
  end

  private

  def calculate_row_and_space
    rows = @files.size.ceildiv(INITIAL_COLUMN)
    width = @files.max_by(&:length).length + 7
    [rows, width]
  end

  def calculate_max_width(file_stats)
    file_info = file_stats.map(&:info)
    file_stat_max_sizes = file_info.transpose.map { |array| array.map { |fs| fs.to_s.size }.max }
    {
      hard_link_count: file_stat_max_sizes[1],
      owner_name: file_stat_max_sizes[2],
      group_name: file_stat_max_sizes[3],
      byte_size: file_stat_max_sizes[4],
      month: file_stat_max_sizes[5],
      date: file_stat_max_sizes[6],
      file_name: file_stat_max_sizes[8]
    }
  end

  def print_file_stat(file_stats, total_blocks, max_width)
    puts "total #{total_blocks}"
    file_stats.each do |fs|
      print [
        "#{fs.info[0]} ",
        fs.info[1].to_s.rjust(max_width[:hard_link_count]),
        "#{fs.info[2].ljust(max_width[:owner_name])} ",
        "#{fs.info[3].rjust(max_width[:hard_link_count])} ",
        fs.info[4].to_s.rjust(max_width[:byte_size]),
        fs.info[5].to_s.rjust(max_width[:month]),
        fs.info[6].to_s.rjust(max_width[:date]),
        fs.info[7],
        fs.info[8].ljust(max_width[:file_name]).to_s
      ].join(' ')
      puts
    end
  end
end
