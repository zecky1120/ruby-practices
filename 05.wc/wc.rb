# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  paths = ARGV
  wc_counts = build_wc_counts(paths)
  wc_counts.each do |wc_count|
    display_wc(wc_count, options, paths)
  end
  wc_total_count(wc_counts, options, paths) if paths.size >= 2
end

def parse_options
  options = {}
  opt = OptionParser.new
  opt.on('-l') { options[:l] = true }
  opt.on('-w') { options[:w] = true }
  opt.on('-c') { options[:c] = true }
  opt.permute!(ARGV)
  options.empty? ? { l: true, w: true, c: true } : options
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

def build_align_width(paths, options)
  if paths.empty?
    7
  elsif paths.size <= 1 && options.size <= 1
    0
  else
    filtered_count_data = build_wc_counts(paths).max_by { |v| v[:file_sizes] }
    filtered_count_data[:file_sizes].to_s.size
  end
end

def display_wc(count_file, options, paths)
  align_width = build_align_width(paths, options)
  count_files = []
  count_files << count_file[:lines].to_s.rjust(align_width) if options[:l]
  count_files << count_file[:words].to_s.rjust(align_width) if options[:w]
  count_files << count_file[:file_sizes].to_s.rjust(align_width) if options[:c]
  count_files << count_file[:path].to_s
  puts count_files.join(' ')
end

def build_wc_total_counts(wc_count_files)
  {
    lines: wc_count_files.sum { |count_file| count_file[:lines] },
    words: wc_count_files.sum { |count_file| count_file[:words] },
    file_sizes: wc_count_files.sum { |count_file| count_file[:file_sizes] },
    path: 'total'
  }
end

def wc_total_count(wc_count_files, options, paths)
  total_count_file = build_wc_total_counts(wc_count_files)
  display_wc(total_count_file, options, paths)
end

main
