# frozen_string_literal: true

require_relative 'option'
require_relative 'format'

class Ls
  attr_reader :files

  def initialize
    @option = Option.new.extract_entered_option
    @files = retrieve_files_by_option(@option)
  end

  def show
    @option.include?('l') ? Format.new(@files).ls_opt_long : Format.new(@files).ls_column
  end

  private

  def retrieve_files_by_option(opts)
    files = Dir.glob('*').sort
    files = Dir.entries('.').sort if opts.include?('a')
    files.reverse! if opts.include?('r')
    files
  end
end
