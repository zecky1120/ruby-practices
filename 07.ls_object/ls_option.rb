# frozen_string_literal: true

require 'etc'
require_relative 'ls'

class Option < LS
  def display_option_file_list
    if @params[:l]
      display_long_formats(find_files)
    else
      display_files_list(find_files)
    end
  end

  def display_long_formats(find_files)
    long_formats = find_files.map do |file_path|
      stat = File::Stat.new(file_path)
      build_rowfile(file_path, stat)
    end
    total_block = long_formats.sum { |data| data[:blocks] }
    total = "total #{total_block}"
    body = long_format_body(long_formats)
    puts [total, *body]
  end

  def long_format_body(files)
    max_size = %i[nlink owner group size].map do |value|
      find_max_size(files, value)
    end
    files.map do |data|
      format_rows(data, *max_size)
    end
  end

  def find_max_size(long_formats, key)
    long_formats.map { |data| data[key].to_s.size }.max
  end

  def format_rows(row, max_nlink, max_owner, max_group, max_size)
    [
      row[:filemode],
      "  #{row[:nlink].to_s.rjust(max_nlink)}",
      " #{row[:owner].ljust(max_owner)}",
      "  #{row[:group].rjust(max_group)}",
      "  #{row[:size].to_s.rjust(max_size)}",
      " #{row[:mtime]}",
      row[:basename]
    ].join
  end

  def build_rowfile(file_path, stat)
    {
      blocks: stat.blocks,
      filemode: format_type_and_mode(stat),
      nlink: stat.nlink,
      owner: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: stat.size,
      mtime: stat.mtime.strftime('%_m %_d %Y %H:%M '),
      basename: File.basename(file_path)
    }
  end

  GET_FILE_FTYPE = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }.freeze

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

  def format_type_and_mode(stat)
    ftype = GET_FILE_FTYPE[stat.ftype]
    octal = stat.mode.to_s(8)
    slice_octal = octal.slice(-3, 3)
    permissions = get_special_authority(octal, slice_octal).join
    "#{ftype}#{permissions}"
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
end
