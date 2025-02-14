# frozen_string_literal: true

require_relative 'file_attribute'

class LongFormat
  GET_FILE_PERMISSION = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(files)
    @files = files
  end

  def display
    rows = @files.map { |file| generate_format_row(FileAttribute.new(file)) }
    total_block = rows.sum { |row| row[:blocks] }
    total = "total #{total_block}"
    body = format_rows(rows)
    [total, body]
  end

  private

  def generate_format_row(file)
    {
      blocks: file.blocks,
      filemode: "#{file.ftype}#{file_permissions(file.mode)}",
      nlink: file.nlink,
      owner: file.owner,
      group: file.group,
      size: file.size,
      mtime: file.mtime,
      basename: file.basename
    }
  end

  def file_permissions(octal)
    slice_octal = octal.slice(-3, 3)
    get_special_authority(octal, slice_octal).join
  end

  def get_special_authority(octal, slice_octal)
    slice_octal.each_char.with_index.map do |oc, index|
      perm = GET_FILE_PERMISSION[oc]
      apply_special_permission(octal, perm, index)
    end
  end

  def apply_special_permission(octal, perm, index)
    special_bit = octal.slice(-4)
    case [special_bit, index]
    when ['1', 2]
      perm[-1] == 'x' ? perm.sub(/.$/, 't') : perm.sub(/.$/, 'T')
    when ['2', 1]
      perm[-1] == 'x' ? perm.sub(/.$/, 's') : perm.sub(/.$/, 'S')
    when ['4', 0]
      perm[-1] == 'x' ? perm.sub(/.$/, 's') : perm.sub(/.$/, 'S')
    else
      perm
    end
  end

  def format_rows(rows)
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
