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
    print_file_stat(file_stats)
  end

  private

  def calculate_row_and_space
    rows = @files.size.ceildiv(INITIAL_COLUMN)
    width = @files.max_by(&:length).length + 7
    [rows, width]
  end

  def max(num1, num2)
    num1 > num2 ? num1 : num2
  end

  def print_file_stat(file_stats)
    total_blocks = file_stats.map(&:block).sum
    max_width = calculate_max_width(file_stats)
    puts "total #{total_blocks}"
    file_stats.each do |fs|
      print [
        "#{fs.type_and_mode} ",
        fs.hard_link.to_s.rjust(max_width[:hard_link_count]),
        "#{fs.owner_name.ljust(max_width[:owner_name])} ",
        "#{fs.group_name.rjust(max_width[:hard_link_count])} ",
        fs.byte_size.to_s.rjust(max_width[:byte_size]),
        fs.month.to_s.rjust(max_width[:month]),
        fs.date.to_s.rjust(max_width[:date]),
        fs.time,
        fs.name.ljust(max_width[:file_name]).to_s
      ].join(' ')
      puts
    end
  end

  def calculate_max_width(file_stats)
    max_widths = {
      hard_link_count: 0,
      owner_name: 0,
      group_name: 0,
      byte_size: 0,
      month: 0,
      date: 0,
      file_name: 0
    }
    file_stats.each do |fs|
      max_widths[:hard_link_count] = max(fs.hard_link.to_s.length, max_widths[:hard_link_count])
      max_widths[:owner_name] = max(fs.owner_name.length, max_widths[:owner_name])
      max_widths[:group_name] = max(fs.group_name.length, max_widths[:group_name])
      max_widths[:byte_size] = max(fs.byte_size.to_s.length, max_widths[:byte_size])
      max_widths[:month] = max(fs.month.to_s.length, max_widths[:month])
      max_widths[:date] = max(fs.date.to_s.length, max_widths[:date])
      max_widths[:file_name] = max(fs.name.length, max_widths[:file_name])
    end
    max_widths
  end
end
