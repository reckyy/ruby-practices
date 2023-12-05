# frozen_string_literal: true

require 'etc'

class MyFileStat
  attr_reader :total_blocks, :info

  def initialize(file_list)
    @info, @total_blocks = compile_file_stat(file_list)
  end

  private

  def compile_file_stat(file_list)
    total_blocks = 0
    file_stats = file_list.map do |file|
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
    [file_stats, total_blocks]
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
end
