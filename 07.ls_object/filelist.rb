# frozen_string_literal: true

require 'etc'
require_relative 'option'

class FileList
  attr_reader :files

  def initialize(opts)
    @files = retrieve_files_by_option(opts)
  end

  private

  def retrieve_files_by_option(opts)
    files = Dir.glob('*').sort
    files = Dir.entries('.').sort if opts.include?('a')
    files.reverse! if opts.include?('r')
    files
  end
end
