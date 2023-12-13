# frozen_string_literal: true

require_relative 'option'
require_relative 'file_stat_printer'

class Ls
  def initialize(input)
    @opts = Option.new(input)
    @files = retrieve_files_by_option
  end

  def show
    file_stat_printer = FileStatPrinter.new(@files)
    @opts.long_format? ? file_stat_printer.print_in_long_format : file_stat_printer.print_in_short_format
  end

  private

  def retrieve_files_by_option
    files = Dir.glob('*').sort
    files = Dir.entries('.').sort if @opts.all?
    files.reverse! if @opts.reverse?
    files
  end
end
