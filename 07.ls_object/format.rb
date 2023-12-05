# frozen_string_literal: true

require_relative 'myfilestat'
require 'debug'

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
    file_stats = @file_list.map{ |file| MyFileStat.new(file) }
    max_width = calculate_max_width(file_stats)
    total_blocks = file_stats.map(&:block).sum
    print_file_stat(file_stats, total_blocks, max_width)
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

  private

  def calculate_row_and_space
    div, mod = @file_list.size.divmod(INITIAL_COLUMN)
    rows = mod.zero? ? div : (div + 1)
    width = @file_list.max_by(&:length).length + 7
    [rows, width]
  end

  def calculate_max_width(file_stats)
    {
      hard_link_count: file_stats.map { |fs| fs.info[1].to_s.size }.max,
      owner_name: file_stats.map{ |fs| fs.info[2].to_s.size }.max,
      group_name: file_stats.map{ |fs| fs.info[3].to_s.size }.max,
      byte_size: file_stats.map{ |fs| fs.info[4].to_s.size }.max,
      month: file_stats.map{ |fs| fs.info[5].to_s.size }.max,
      date: file_stats.map{ |fs| fs.info[6].to_s.size }.max + 1,
      file_name: file_stats.map{ |fs| fs.info[8].to_s.size }.max
    }
  end
end
