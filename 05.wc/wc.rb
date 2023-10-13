# frozen_string_literal: true

require 'optparse'

def parse_options
  params = {}
  opt = OptionParser.new
  opt.on('-l') { params[:l] = true }
  opt.on('-w') { params[:w] = true }
  opt.on('-c') { params[:c] = true }
  opt.permute!(ARGV)
  params
end

def files
  ARGV
end

def get_count_line(str)
  str.count("\n")
end

def get_count_word(str)
  str.split(/\s+/).count
end

def get_file_size(str)
  str.sum(&:bytesize)
end

def get_file_path(str)
  File.path(str)
end

def string_max_size
  line_count_ary = []
  word_count_ary = []
  file_size_ary = []
  files.each do |f|
    line_count_ary << get_count_line(f)
    word_count_ary << get_count_word(f)
    file_size_ary << get_file_size(f)
  end
  {
    max_line: line_count_ary.max.to_s.size + 5,
    max_word: word_count_ary.max.to_s.size + 5,
    max_file_size: file_size_ary.max.to_s.size + 5
  }
end

def build_wc_format(str, file = '')
  {
    count_lines: get_count_line(str),
    count_words: get_count_word(str),
    count_file_sizes: get_file_size(str),
    path: file
  }
end

def build_count_map(files)
  files.map do |file|
    str = File.read(file)
    build_wc_format(str, file)
  end
end

def display_wc_format(wc_format_map, parse_options)
  params = parse_options
  wc_format_ary = []
  wc_format_ary << wc_format_map[:count_lines].to_s.rjust(string_max_size[:max_line]) if params[:l]
  wc_format_ary << wc_format_map[:count_words].to_s.rjust(string_max_size[:max_word]) if params[:w]
  wc_format_ary << wc_format_map[:count_file_sizes].to_s.rjust(string_max_size[:max_file_size]) if params[:c]
  wc_format_ary << " #{wc_format_map[:path]}"
  puts wc_format_ary.join
end

def build_wc_total_map(wc_total_maps)
  {
    count_lines: wc_total_maps.sum { |wc_total_map| wc_total_map[:count_lines] },
    count_words: wc_total_maps.sum { |wc_total_map| wc_total_map[:count_words] },
    count_file_sizes: wc_total_maps.sum { |wc_total_map| wc_total_map[:count_file_sizes] },
    path: 'total'
  }
end

def display_wc(files, parse_options)
  display_wc_maps = build_count_map(files)
  display_wc_maps.map { |display_wc_map| display_wc_format(display_wc_map, parse_options) }
  display_wc_total(display_wc_maps, parse_options) if files.size >= 2
end

def display_wc_total(wc_total_maps, parse_options)
  display_wc_total_maps = build_wc_total_map(wc_total_maps)
  display_wc_format(display_wc_total_maps, parse_options)
end

def display_wc_stdin(parse_options)
  wc_stdin_ary = []
  rlines = $stdin.readlines
  wc_stdin_ary << rlines.size.to_s.rjust(string_max_size[:max_line]) if parse_options[:l]
  wc_stdin_ary << rlines.sum { |rline| rline.split(/\s+/).size }.to_s.rjust(string_max_size[:max_word]) if parse_options[:w]
  wc_stdin_ary << rlines.sum(&:bytesize).to_s.rjust(string_max_size[:max_file_size]) if parse_options[:c]
  puts wc_stdin_ary.join
end

def output
  params = parse_options
  params = { l: true, w: true, c: true } if params.empty?
  files.empty? ? display_wc_stdin(params) : display_wc(files, params)
end

output
