#!/home/zecky1120/.rbenv/shims/ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def parse_options
  params = {}
  opt = OptionParser.new
  opt.on('-l') { |l| params[:l] = l }
  opt.parse(ARGV)
  params
end

def find_files
  params = parse_options
  params[:l] = Dir.glob('*')
end

GET_FILE_FTYPE_HASH = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

def get_file_ftype(get_file)
  GET_FILE_FTYPE_HASH[get_file]
end

FILE_PERMISSION_HASH = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def get_file_permission(file_octal)
  file_permission_ary = []
  file_octal.slice(-3, 3).each_char do |file_permission_number|
    file_permission_ary << FILE_PERMISSION_HASH[file_permission_number]
  end
  get_special_authority(file_octal, file_permission_ary)
  file_permission_ary.join
end

def get_special_authority(file_octal, file_permission_ary)
  case file_octal.slice(2)
  when '1'
    file_permission_ary[2] = if file_permission_ary[2].slice(2) == 'x'
                               file_permission_ary[2].gsub(/.$/, 't')
                             else
                               file_permission_ary[2].gsub(/.$/, 'T')
                             end
  when '2'
    file_permission_ary[1] = if file_permission_ary[1].slice(2) == 'x'
                               file_permission_ary[1].gsub(/.$/, 's')
                             else
                               file_permission_ary[1].gsub(/.$/, 'S')
                             end
  when '4'
    file_permission_ary[0] = if file_permission_ary[0].slice(2) == 'x'
                               file_permission_ary[0].gsub(/.$/, 's')
                             else
                               file_permission_ary[0].gsub(/.$/, 'S')
                             end
  end
end

def get_file_mode(file)
  file_octal = File.stat(file).mode.to_s(8).rjust(6, '0')
  file_ftype = File.stat(file).ftype
  file_type = get_file_ftype(file_ftype)
  file_permission = get_file_permission(file_octal)
  "#{file_type}#{file_permission}"
end

def get_file_hard_link(file)
  File.stat(file).nlink
end

def get_file_owner(file)
  uid = File.stat(file).uid
  Etc.getpwuid(uid).name
end

def get_file_group(file)
  gid = File.stat(file).gid
  Etc.getgrgid(gid).name
end

def get_file_size(file)
  File.stat(file).size
end

def get_file_mtime(file)
  File.stat(file).mtime.strftime(' %_b %_d %Y %H:%M ')
end

def get_file_name(file)
  File.basename(file)
end

def get_blocks(file)
  File.stat(file).blocks
end

def max_width_sizes
  owner_ary = []
  group_ary = []
  file_size_ary = []
  find_files.each do |f|
    owner_ary << get_file_owner(f)
    group_ary << get_file_group(f)
    file_size_ary << get_file_size(f)
  end
  {
    max_owner: owner_ary.max.to_s.size + 1,
    max_group: group_ary.max.to_s.size + 1,
    max_file_size: file_size_ary.max.to_s.size + 1
  }
end

def get_long_format(find_files)
  long_format_ary = []
  find_files.each do |f|
    long_format_hash = {
      file_mode: get_file_mode(f),
      file_hard_link: get_file_hard_link(f),
      file_owner: get_file_owner(f),
      file_group: get_file_group(f),
      file_size: get_file_size(f),
      file_mtime: get_file_mtime(f),
      file_name: get_file_name(f),
      file_blocks: get_blocks(f)
    }
    long_format_ary << long_format_hash
  end
  long_format_ary
end

def total_blocks(find_files)
  get_blocks = get_long_format(find_files)
  get_blocks.sum { |block| block[:file_blocks] }
end

def display_long_formats(find_files)
  long_formats = get_long_format(find_files)
  puts "total #{total_blocks(find_files) / 2}"
  long_formats.each do |long_format|
    print long_format[:file_mode].to_s.ljust(11)
    print long_format[:file_hard_link].to_s.rjust(1)
    print long_format[:file_owner].to_s.rjust(max_width_sizes[:max_owner])
    print long_format[:file_group].to_s.rjust(max_width_sizes[:max_group])
    print long_format[:file_size].to_s.rjust(max_width_sizes[:max_file_size])
    print long_format[:file_mtime]
    print long_format[:file_name]
    print "\n"
  end
end
display_long_formats(find_files)
