# frozen_string_literal: true

require_relative 'command'

ls = Command.new(ARGV)
puts ls.main
