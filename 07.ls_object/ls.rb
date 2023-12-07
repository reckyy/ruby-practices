# frozen_string_literal: true

require_relative 'option'
require_relative 'file_info_printer'

class Ls
  def initialize(input)
    @opts = Option.new(input)
    @files = retrieve_files_by_option
  end

  def show
    @opts.long_format? ? FileInfoPrinter.new(@files).ls_opt_long : FileInfoPrinter.new(@files).ls_column
  end

  private

  def retrieve_files_by_option
    files = Dir.glob('*').sort
    files = Dir.entries('.').sort if @opts.all?
    files.reverse! if @opts.reverse?
    files
  end
end
