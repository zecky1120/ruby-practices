# frozen_string_literal: true

require 'optparse'

def main(options)
  options = { l: true, w: true, c: true } if options.empty?
  files.empty? ? display_wc_stdin(options) : display_wc(options)
end

def options
  options = {}
  opt = OptionParser.new
  opt.on('-l') { options[:l] = true }
  opt.on('-w') { options[:w] = true }
  opt.on('-c') { options[:c] = true }
  opt.permute!(ARGV)
  options
end

def files
  ARGV
end

def get_count_line(lines)
  files.empty? ? lines.length : lines.count("\n")
end

def get_count_word(lines)
  files.empty? ? lines.sum { |line| line.split.size } : lines.split(/\s+/).count
end

def get_file_size(lines)
  files.empty? ? lines.join.bytesize : lines.bytesize
end

def width_size
  line_count_ary = []
  word_count_ary = []
  file_size_ary = []
  build_count_files = build_count(files)
  build_count_files.each do |build_count_file|
    line_count_ary << build_count_file[:count_lines]
    word_count_ary << build_count_file[:count_words]
    file_size_ary  << build_count_file[:count_file_sizes]
  end
  {
    max_line: line_count_ary.max.to_s.size + 2,
    max_word: word_count_ary.max.to_s.size + 3,
    max_file_size: file_size_ary.max.to_s.size + 1
  }
end

def build_wc_format(lines, file = '')
  {
    count_lines: get_count_line(lines),
    count_words: get_count_word(lines),
    count_file_sizes: get_file_size(lines),
    path: file
  }
end

def build_count(files)
  files.map do |file|
    lines = File.read(file)
    build_wc_format(lines, file)
  end
end

def display_wc_format(build_count_file, options)
  wc_format_ary = []
  wc_format_ary << build_count_file[:count_lines].to_s.rjust(width_size[:max_line]) if options[:l]
  wc_format_ary << build_count_file[:count_words].to_s.rjust(width_size[:max_word]) if options[:w]
  wc_format_ary << build_count_file[:count_file_sizes].to_s.rjust(width_size[:max_file_size]) if options[:c]
  wc_format_ary << " #{build_count_file[:path]}"
  puts wc_format_ary.join
end

def build_wc_total(build_count_files)
  {
    count_lines: build_count_files.sum { |build_count_file| build_count_file[:count_lines] },
    count_words: build_count_files.sum { |build_count_file| build_count_file[:count_words] },
    count_file_sizes: build_count_files.sum { |build_count_file| build_count_file[:count_file_sizes] },
    path: 'total'
  }
end

def display_wc(options)
  build_count_files = build_count(files)
  build_count_files.map { |build_count_file| display_wc_format(build_count_file, options) }
  display_wc_total(build_count_files, options) if files.size >= 2
end

def display_wc_total(build_count_files, options)
  build_count_file = build_wc_total(build_count_files)
  display_wc_format(build_count_file, options)
end

def display_wc_stdin(options)
  wc_stdin_ary = []
  rlines = $stdin.readlines
  wc_stdin_ary << get_count_line(rlines).to_s.rjust(7) if options[:l]
  wc_stdin_ary << get_count_word(rlines).to_s.rjust(8) if options[:w]
  wc_stdin_ary << get_file_size(rlines).to_s.rjust(8) if options[:c]
  puts wc_stdin_ary.join
end

main(options)
