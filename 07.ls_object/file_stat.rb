# frozen_string_literal: true

require 'etc'

class Ls
  class FileStat
    attr_reader :name

    def initialize(file)
      @stats = File::Stat.new(file)
      @name = file
    end

    def type_and_mode
      convert_to_file_type(@stats) + convert_to_file_permission(@stats)
    end

    def hard_link
      @stats.nlink.to_i
    end

    def owner_name
      Etc.getpwuid(@stats.uid).name
    end

    def group_name
      Etc.getgrgid(@stats.gid).name
    end

    def byte_size
      @stats.size
    end

    def month
      @stats.mtime.month
    end

    # File::Statのメソッド名はdayだが、日にちは英語でdateのため。
    def date
      @stats.mtime.day
    end

    def time
      @stats.mtime.strftime('%H:%M')
    end

    def block
      @stats.blocks
    end

    private

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
end
