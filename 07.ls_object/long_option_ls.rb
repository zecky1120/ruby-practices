# frozen_string_literal: true

require 'etc'
require_relative 'base_ls'

class LongOptionLS < BaseLS
  def display_long_file_list
    formatted_long_file_list(find_files)
  end

  def formatted_long_file_list(find_files)
    rows = find_files.map do |file_path|
      stat = File::Stat.new(file_path)
      build_rowfile(file_path, stat)
    end
    total_block = rows.sum { |row| row[:blocks] }
    total = "total #{total_block}"
    body = format_rows(rows)
    [total, body]
  end

  private

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

  def convert_filetype(stat)
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

  def build_rowfile(file_path, stat)
    {
      blocks: stat.blocks,
      filemode: convert_filetype(stat),
      nlink: stat.nlink,
      owner: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: stat.size,
      mtime: last_update(stat),
      basename: File.basename(file_path)
    }
  end

  def last_update(stat)
    current_time = Time.now
    time_stamp = stat.mtime
    half_year_ago = current_time - 15_552_000
    time_or_year = time_stamp >= half_year_ago ? time_stamp.strftime('%H:%M') : time_stamp.strftime('%Y')
    "#{time_stamp.strftime('%_m %_d').rjust(5)} #{time_or_year.rjust(5)}"
  end
end
