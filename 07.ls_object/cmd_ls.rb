# frozen_string_literal: true

require_relative 'standard_ls'
require_relative 'long_option_ls'

class Command
  def initialize(option)
    @option = option
  end

  def output
    option = BaseLS.new(@option).parse_params(@option)
    option[:l] ? LongOptionLS.new(@option).display_long_file_list : StandardLS.new(@option).display_file_list
  end
end

cmd = Command.new(ARGV)
puts cmd.output
