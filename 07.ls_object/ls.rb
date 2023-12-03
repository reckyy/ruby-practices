# frozen_string_literal: true

require_relative 'filelist'

option = Option.new.extract_entered_option
fl = FileList.new(option)
fl.show(option)
