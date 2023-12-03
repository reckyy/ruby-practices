# frozen_string_literal: true

require_relative 'filelist'
require_relative 'format'

option = Option.new.extract_entered_option
fl = FileList.new(option)
Format.new(option, fl.files).format
