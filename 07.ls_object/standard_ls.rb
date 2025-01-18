# frozen_string_literal: true

require_relative 'base_ls'

class StandardLS < BaseLS
  COLUMNS = 3

  def main
    files = find_files
    display_files(files)
  end

  def display_files(files)
    column_max_size = files.map(&:size).max
    number_of_column = files.size.ceildiv(COLUMNS)
    columns = files.each_slice(number_of_column).to_a
    columns[0].zip(*columns[1..]).map do |row|
      row.map { |file| file.to_s.ljust(column_max_size + 2) }.join.rstrip
    end.join("\n")
  end
end
