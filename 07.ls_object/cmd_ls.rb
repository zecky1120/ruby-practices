# frozen_string_literal: true

require_relative 'standard_ls'

class Command
  def initialize(option)
    @option = option
  end

  def main
    option = BaseLS.new(@option).parse_params(@option)
    if option[:l]
      puts 'longオプションを表示'
    else
      StandardLS.new(@option).main
    end
  end
end

cmd = Command.new(ARGV)
puts cmd.main
