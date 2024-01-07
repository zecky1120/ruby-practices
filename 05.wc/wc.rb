# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  paths = ARGV
  wc_counts = build_wc_counts(paths)
  total_count_file = build_wc_total_counts(wc_counts)
  width = max_space_size(wc_counts, total_count_file, options, paths)
  wc_counts.each do |wc_count|
    output(wc_count, options, width)
  end
  output(total_count_file, options, width) if paths.size >= 2
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

def output(count_file, options, width)
  count_files = []
  count_files << count_file[:lines].to_s.rjust(width) if options[:l]
  count_files << count_file[:words].to_s.rjust(width) if options[:w]
  count_files << count_file[:file_sizes].to_s.rjust(width) if options[:c]
  count_files << count_file[:path]
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

def max_space_size(wc_counts, total_count_file, options, paths)
  if paths.empty?
    7
  elsif paths.size <= 1 && options.size <= 1
    0
  else
    ary = []
    filtered_count_data = wc_counts.max_by { |v| v[:file_sizes] }
    total_count_data = total_count_file[:file_sizes]
    ary << filtered_count_data[:file_sizes]
    ary << total_count_data
    calculate_size = ary.max_by { |v| v }
    calculate_size.to_s.size
  end
end

main
