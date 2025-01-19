# frozen_string_literal: true

require_relative 'base_ls'

class StandardLS < BaseLS
  COLUMNS = 5

  def display_file_list
    formatted_file_list(find_files)
  end

  def formatted_file_list(find_files)
    column_max_size = find_files.map(&:size).max
    number_of_column = find_files.size.ceildiv(COLUMNS)
    columns = find_files.each_slice(number_of_column).to_a
    columns[0].zip(*columns[1..]).map do |row|
      row.map { |file| file.to_s.ljust(column_max_size + 2) }.join.rstrip
    end.join("\n")
  end
end
