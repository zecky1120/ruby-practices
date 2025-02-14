# frozen_string_literal: true

require 'optparse'
require_relative 'short_format'
require_relative 'long_format'

class Command
  def initialize(option)
    @params = parse_params(option)
  end

  def main
    @params[:l] ? LongFormat.new(files).display : ShortFormat.new(files).display
  end

  private

  def parse_params(option)
    params = {}
    opt = OptionParser.new
    opt.on('-a') { |a| params[:a] = a }
    opt.on('-r') { |r| params[:r] = r }
    opt.on('-l') { |l| params[:l] = l }
    opt.parse(option)
    params
  end

  def files
    flags = @params[:a] ? File::FNM_DOTMATCH : 0
    dir = Dir.glob('*', flags)
    @params[:r] ? dir.reverse : dir
  end
end
