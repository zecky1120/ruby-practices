# frozen_string_literal: true

require 'optparse'

class BaseLS
  def initialize(option)
    @params = parse_params(option)
  end

  def find_files
    flags = @params[:a] ? File::FNM_DOTMATCH : 0
    dir = Dir.glob('*', flags)
    @params[:r] ? dir.reverse : dir
  end

  def parse_params(option)
    params = {}
    opt = OptionParser.new
    opt.on('-a') { |a| params[:a] = a }
    opt.on('-r') { |r| params[:r] = r }
    opt.on('-l') { |l| params[:l] = l }
    opt.parse(option)
    params
  end
end
