# frozen_string_literal: true

require_relative 'ls'

input = ARGV.getopts('alr')
Ls.new(input).show
