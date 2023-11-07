# frozen_string_literal: true

require 'optparse'

def main(options)
  options = { l: true, w: true, c: true } if options.empty?
  paths = ARGV
  wc_count_files = build_wc_counts(paths:)
  wc_count_files.map { |wc_count_file| display_wc(count_file: wc_count_file, options:, paths:) }
  display_total_count(wc_count_files:, options:, paths:) if paths.size >= 2
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

def build_wc_counts(paths:)
  if paths.empty?
    [build_wc(lines: $stdin.read)]
  else
    paths.map do |path|
      build_wc(lines: File.read(path), path:)
    end
  end
end

def build_wc(lines:, path: '')
  {
    lines: lines.count("\n"),
    words: lines.split(/\s+/).count,
    file_sizes: lines.bytesize,
    path:
  }
end

def build_count_size(paths:, options:)
  count_ary = []
  string_sizes = build_wc_counts(paths:)
  string_sizes.each do |string_size|
    count_ary << string_size[:lines] if options[:l]
    count_ary << string_size[:words] if options[:w]
    count_ary << string_size[:file_sizes] if options[:c]
  end
  count_ary
end

def build_align_width(paths:, options:)
  string_size_counts = build_count_size(paths:, options:)
  fixed_max_width =
    if paths.size <= 1 && options.size <= 1
      0
    elsif paths.empty? && options.size >= 2
      7
    else
      string_size_counts.max.to_s.size
    end
  {
    max_line: fixed_max_width,
    max_word: fixed_max_width + 1,
    max_file_size: fixed_max_width + 1
  }
end

def display_wc(count_file:, options:, paths:)
  string_size_count = build_align_width(paths:, options:)
  count_files_ary = []
  count_files_ary << count_file[:lines].to_s.rjust(string_size_count[:max_line]) if options[:l]
  count_files_ary << count_file[:words].to_s.rjust(string_size_count[:max_word]) if options[:w]
  count_files_ary << count_file[:file_sizes].to_s.rjust(string_size_count[:max_file_size]) if options[:c]
  count_files_ary << " #{count_file[:path]}"
  puts count_files_ary.join
end

def build_wc_total_counts(wc_count_files)
  {
    lines: wc_count_files.sum { |count_file| count_file[:lines] },
    words: wc_count_files.sum { |count_file| count_file[:words] },
    file_sizes: wc_count_files.sum { |count_file| count_file[:file_sizes] },
    path: 'total'
  }
end

def display_total_count(wc_count_files:, options:, paths:)
  total_count_file = build_wc_total_counts(wc_count_files)
  display_wc(count_file: total_count_file, options:, paths:)
end

main(options)
