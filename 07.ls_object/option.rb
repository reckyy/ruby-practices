# frozen_string_literal: true

require 'optparse'

class Option
  def initialize
    @opts_hash = ARGV.getopts('alr')
  end

  def extract_entered_option
    @opts_hash.keys.select { |k| @opts_hash[k] }.sort
  end
end
