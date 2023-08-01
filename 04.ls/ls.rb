# frozen_string_literal: true

require 'optparse'

def parse_options
  params = {}
  opt = OptionParser.new
  opt.on('-a') { |a| params[:a] = a }
  opt.on('-r') { |r| params[:r] = r }
  opt.parse(ARGV)
  params
end

def find_files
  params = parse_options
  flags = params[:a] ? File::FNM_DOTMATCH : 0
  dir = Dir.glob('*', flags)
  params[:r] ? dir.reverse : dir
end

def string_max_size
  find_files.map(&:size).max + 2
end

def display_files_list(max_colums)
  number_of_files = find_files.size
  number_of_columns = number_of_files.ceildiv(max_colums)
  column_conditioning_array = find_files.each_slice(number_of_columns).to_a
  adjustment_array =
    column_conditioning_array.each do |item|
      item << nil while item.size < number_of_columns
    end
  adjustment_array.transpose.each do |file_names|
    file_names.each do |file_name|
      print file_name.to_s.ljust(string_max_size)
    end
    puts
  end
end

display_files_list(3)
