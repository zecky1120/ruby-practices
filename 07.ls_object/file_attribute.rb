# frozen_string_literal: true

require 'etc'

class FileAttribute
  def initialize(file)
    @file = file
    @file_stat = File::Stat.new(@file)
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

  def convert_filetype
    ftype = GET_FILE_FTYPE[@file_stat.ftype]
    octal = @file_stat.mode.to_s(8)
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

  def build_rowfile
    {
      blocks: @file_stat.blocks,
      filemode: convert_filetype,
      nlink: @file_stat.nlink,
      owner: Etc.getpwuid(@file_stat.uid).name,
      group: Etc.getgrgid(@file_stat.gid).name,
      size: @file_stat.size,
      mtime: last_update,
      basename: File.basename(@file)
    }
  end

  def last_update
    current_time = Time.now
    time_stamp = @file_stat.mtime
    half_year_ago = current_time - 15_552_000
    time_or_year = time_stamp >= half_year_ago ? time_stamp.strftime('%H:%M') : time_stamp.strftime('%Y')
    "#{time_stamp.strftime('%_m %_d').rjust(5)} #{time_or_year.rjust(5)}"
  end
end
