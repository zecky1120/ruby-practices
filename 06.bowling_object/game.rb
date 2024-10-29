# frozen_string_literal: true

require './frame'

class Game
  def initialize(pinfall_text)
    @frames = generate_pinfall_frames(pinfall_text)
  end

  def main
    total_score = @frames.each_with_index.sum { |frame, idx| frame.scores + calculate_bonus(idx, frame) }
    puts total_score
  end

  private

  def generate_pinfall_frames(pinfall_text)
    pinfall_frames = parse_pinfall_text(pinfall_text)
    pinfall_frames.map { |shots| Frame.new(shots) }
  end

  def parse_pinfall_text(pinfall_text)
    shots = pinfall_text.split(',').map { |shot| Shot.new(shot) }
    rolls = []
    pinfall_rolls = []
    shots.each do |shot|
      rolls << shot
      if pinfall_rolls.length < 10
        if rolls.length >= 2 || shot.strike?
          pinfall_rolls << rolls
          rolls = []
        end
      else
        pinfall_rolls.last << shot
      end
    end
    pinfall_rolls
  end

  def calculate_bonus(idx, frame)
    return 0 if idx >= 9

    next_frame = @frames[idx + 1]
    second_frame = @frames[idx + 2]
    if frame.strike?
      calculate_strike_point(next_frame, second_frame)
    elsif frame.spare?
      calculate_spare_point(next_frame)
    else
      0
    end
  end

  def calculate_strike_point(next_frame, second_frame)
    bonus_shots = (next_frame ? next_frame.shots : []) + (second_frame ? second_frame.shots : [])
    bonus_shots.first(2).sum(&:score)
  end

  def calculate_spare_point(next_frame)
    next_frame ? next_frame.shots[0].score : 0
  end
end

game = Game.new(ARGV[0])
game.main
