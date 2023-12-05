# frozen_string_literal: true

require 'optparse'

class Option
  def initialize
    opts_hash = ARGV.getopts('alr')
    @params = extract_entered_option(opts_hash)
  end

  def extract_entered_option(opts_hash)
    opts_hash.keys.select { |k| opts_hash[k] }.sort
  end

  def all?
    @params.include?('a')
  end

  def reverse?
    @params.include?('r')
  end

  def long_format?
    @params.include?('l')
  end
end
