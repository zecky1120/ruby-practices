# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  options = { l: true, w: true, c: true } if options.empty?
  paths = ARGV
  wc_count_files = build_wc_counts(paths)
  wc_count_files.each do |wc_count_file|
    display_wc(wc_count_file, options, paths)
  end
  display_total_count(wc_count_files, options, paths) if paths.size >= 2
end

def parse_options
  options = {}
  opt = OptionParser.new
  opt.on('-l') { options[:l] = true }
  opt.on('-w') { options[:w] = true }
  opt.on('-c') { options[:c] = true }
  opt.permute!(ARGV)
  options
end

def build_wc_counts(paths)
  if paths.empty?
    [build_wc(files: $stdin.read)]
  else
    paths.map do |path|
      build_wc(files: File.read(path), path:)
    end
  end
end

def build_wc(files:, path: '')
  {
    lines: files.count("\n"),
    words: files.split(/\s+/).count,
    file_sizes: files.bytesize,
    path:
  }
end

def build_count_size(options)
  count_ary = []
  wc_count_files.each do |wc_count_file|
    count_ary << wc_count_file[:lines] if options[:l]
    count_ary << wc_count_file[:words] if options[:w]
    count_ary << wc_count_file[:file_sizes] if options[:c]
  end
  count_ary
end

def build_align_width(paths)
  extract_file_sizes = build_wc_counts(paths).map do |count|
    count[:file_sizes]
  end
  string_max_size_count = extract_file_sizes.max.to_s.size
  paths.empty? ? 7 : string_max_size_count
end

def display_wc(count_file, options, paths)
  string_size_count = build_align_width(paths)
  count_files_ary = []
  count_files_ary << "#{count_file[:lines].to_s.rjust(string_size_count)} " if options[:l]
  count_files_ary << "#{count_file[:words].to_s.rjust(string_size_count)} " if options[:w]
  count_files_ary << "#{count_file[:file_sizes].to_s.rjust(string_size_count)} " if options[:c]
  count_files_ary << count_file[:path].to_s
  if paths.size <= 1 && options.size <= 1
    puts count_files_ary.join.strip
  else
    puts count_files_ary.join
  end
end

def build_wc_total_counts(wc_count_files)
  {
    lines: wc_count_files.sum { |count_file| count_file[:lines] },
    words: wc_count_files.sum { |count_file| count_file[:words] },
    file_sizes: wc_count_files.sum { |count_file| count_file[:file_sizes] },
    path: 'total'
  }
end

def display_total_count(wc_count_files, options, paths)
  total_count_file = build_wc_total_counts(wc_count_files)
  display_wc(total_count_file, options, paths)
end

main
