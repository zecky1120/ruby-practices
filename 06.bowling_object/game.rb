# frozen_string_literal: true

require './frame'
require 'benchmark'
class Game
  def initialize(mark)
    @mark = mark
  end

  def main
    total_score = 0
    pinfalls = parse_pinfall_text
    pinfalls.each_with_index do |pinfall, idx|
      frame = Frame.new(pinfall)
      total_score += frame.scores
      total_score += add_bonus(pinfall, idx, frame)
    end
    total_score
  end

  # private

  def pinfall_texts
    pins = @mark.split(',')
    frame = []
    game_frames = []
    pins.each do |pin|
      frame << pin
      if game_frames.size < 10
        if frame.size >= 2 || pin == 'X'
          game_frames << frame
          frame = []
        end
      else
        game_frames.last << pin
      end
    end
    game_frames
  end

  def parse_pinfall_text
    pinfall_texts.map { |pin| Frame.new(pin).shots }
  end

  def add_bonus(pinfall, idx, frame)
    bonus_point = 0
    next_pinfall = parse_pinfall_text[idx + 1] ||= []
    if frame.strike?
      bonus_point += next_pinfall.first(2).sum
    elsif frame.spare?
      bonus_point += next_pinfall[0] || 0
    end
    bonus_point
  end
end

game = Game.new(ARGV[0])
# p game.pinfall_texts
# puts game.main
p "-----------------------"
time = Benchmark.measure do
  game = Game.new(ARGV[0])
  p game.parse_pinfall_text
end

puts "処理時間: #{time.real} 秒"
