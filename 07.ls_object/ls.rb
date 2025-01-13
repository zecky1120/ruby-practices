# frozen_string_literal: true

require 'optparse'

class LS
  def initialize(option)
    @params = parse_params(option)
  end

  def display_files_list(find_files)
    number_of_column_file = find_files.size.ceildiv(Command::COLUMNS)
    reshape_column_files = successfully_transposed_files(find_files.each_slice(number_of_column_file).to_a)
    reshape_column_files.map do |row_file|
      row_file.map { |file| file.to_s.ljust(calculate_string_max_size) }.join.rstrip
    end.join("\n")
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

  def find_files
    flags = @params[:a] ? File::FNM_DOTMATCH : 0
    dir = Dir.glob('*', flags)
    @params[:r] ? dir.reverse : dir
  end

  def calculate_string_max_size
    find_files.map(&:size).max + 2
  end

  def successfully_transposed_files(nested_each_column_files)
    nested_each_column_files[0].zip(*nested_each_column_files[1..])
  end
end
