# frozen_string_literal: true

require_relative 'file_attribute'

class LongFormat
  def initialize(files)
    @files = files
  end

  def display
    rows = @files.map { |file| FileAttribute.new(file).build_rowfile }
    max_sizes = %i[nlink owner group size].map do |key|
      rows.map { |row| row[key].to_s.size }.max
    end
    rows.map do |row|
      [
        row[:filemode],
        row[:nlink].to_s.rjust(max_sizes[0] + 1),
        row[:owner].ljust(max_sizes[1]),
        row[:group].rjust(max_sizes[2] + 1),
        row[:size].to_s.rjust(max_sizes[3] + 1),
        row[:mtime],
        row[:basename]
      ].join(' ')
    end
  end
end
