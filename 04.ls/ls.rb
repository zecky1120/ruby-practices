# frozen_string_literal: true

require 'optparse'

class AppOption
  def initialize
    OptionParser.new do |opt|
      opt.on('-a') { find_files }
      opt.parse(ARGV)
    end
  end

  def find_files
    if ARGV[0] == '-a'
      Dir.glob('*', File::FNM_DOTMATCH)
    else
      Dir.glob('*')
    end
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
end

option = AppOption.new
option.display_files_list(3)
