# frozen_string_literal: true

require_relative 'ls'

input = ARGV.getopts(Option::OPTIONS)
Ls.new(input).show
