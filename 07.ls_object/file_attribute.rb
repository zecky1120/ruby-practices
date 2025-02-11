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

  def blocks
    @file_stat.blocks
  end

  def ftype
    GET_FILE_FTYPE[@file_stat.ftype]
  end

  def mode
    @file_stat.mode.to_s(8)
  end

  def nlink
    @file_stat.nlink
  end

  def owner
    Etc.getpwuid(@file_stat.uid).name
  end

  def group
    Etc.getgrgid(@file_stat.gid).name
  end

  def size
    @file_stat.size
  end

  def mtime
    current_time = Time.now
    time_stamp = @file_stat.mtime
    half_year_ago = current_time - 15_552_000
    time_or_year = time_stamp >= half_year_ago ? time_stamp.strftime('%H:%M') : time_stamp.strftime('%Y')
    "#{time_stamp.strftime('%_m %_d').rjust(5)} #{time_or_year.rjust(5)}"
  end

  def basename
    File.basename(@file)
  end
end
