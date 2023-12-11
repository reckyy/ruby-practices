# frozen_string_literal: true

require 'optparse'

class Option
  OPTIONS = 'alr'

  def initialize(input)
    @params = extract_entered_option(input)
  end

  def extract_entered_option(input)
    input.keys.select { |k| input[k] }.sort
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
