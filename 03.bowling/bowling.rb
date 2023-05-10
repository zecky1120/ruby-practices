# frozen_string_literal: true

require 'optparse'

input_score = ARGV[0]
scores = input_score.split(',')

shots = []
scores.each do |score|
  if score == 'X'
    shots << 10 << 0
  else
    shots << score.to_i
  end
end

frames = []
shots.each_slice(2) do |shot|
  frames << shot
end

frames.map do |frame|
  frame.pop if frame[0] == 10
end

total_point = frames.take(10).each_with_index.sum do |frame, i|
  strike = frame[0] == 10
  spare = frame.sum == 10
  next_frame = frames[i + 1]
  if strike
    if next_frame[0] == 10
      10 + next_frame[0] + frames[i + 2][0]
    else
      10 + next_frame.sum
    end
  elsif spare
    10 + next_frame[0]
  else
    frame.sum
  end
end

puts total_point
