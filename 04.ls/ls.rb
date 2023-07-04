# frozen_string_literal: true

def find_files
  Dir.glob('*').sort!
end

def string_max_size
  find_files.map(&:size).max + 2
end

def display_files_list(column)
  number_of_files = find_files.size
  number_of_columns = number_of_files.ceildiv(column)
  column_conditioning_array = find_files.each_slice(number_of_columns).to_a
  adjustment_array =
    column_conditioning_array.each do |item|
      item << nil while item.size < number_of_columns
    end
  adjustment_array.transpose.each do |file_names|
    file_names.each do |file_name|
      printf("%-#{string_max_size}s", file_name)
    end
    puts
  end
end

display_files_list(3)
