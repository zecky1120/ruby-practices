# frozen_string_literal: true

class FileList
  COLUMN = 5

  def initialize(files)
    @files = files
  end

  def display
    column_max_size = @files.map(&:size).max
    number_of_column = @files.size.ceildiv(COLUMN)
    columns = @files.each_slice(number_of_column).to_a
    columns[0].zip(*columns[1..]).map do |row|
      row.map { |file| file.to_s.ljust(column_max_size + 2) }.join.rstrip
    end.join("\n")
  end
end
