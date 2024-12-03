# frozen_string_literal: true

class ListSegments
  COLUMNS = 3

  def display_files_list
    number_of_column_files = find_files.size.ceildiv(COLUMNS)
    reshape_column_files = successfully_transposed_files(find_files.each_slice(number_of_column_files).to_a)
    reshape_column_files.map do |row_file|
      row_file.map { |file| file.to_s.ljust(calculate_string_max_size + 2) }.join.rstrip
    end.join("\n")
  end

  def find_files
    Dir.glob('*')
  end

  def calculate_string_max_size
    find_files.map(&:size).max
  end

  def successfully_transposed_files(nested_each_column_files)
    nested_each_column_files[0].zip(*nested_each_column_files[1..])
  end
end

ls = ListSegments.new
puts ls.display_files_list
