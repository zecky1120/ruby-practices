# frozen_string_literal: true

require_relative 'ls_option'

class Command < Option
  COLUMNS = 3

  def main
    @params.empty? ? display_files_list(find_files) : display_option_file_list
  end
end
cmd = Command.new(ARGV)
puts cmd.main
