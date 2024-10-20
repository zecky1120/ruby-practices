# frozen_string_literal: true

require './frame'

class Game
  def initialize(value)
    @value = value
    @frames = parse_pinfall_text
  end

  def main
    total_score = 0
    @frames.each_with_index do |frame, idx|
      total_score += frame.scores
      total_score += calculate_bonus(idx, frame)
    end
    total_score
  end

  private

  def parse_pinfall_text
    input_values = @value.split(',')
    roll = []
    rolls = []
    input_values.each do |input_value|
      roll << input_value
      if rolls.length < 10
        if roll.length >= 2 || input_value == Shot::STRIKE_MARK
          rolls << roll
          roll = []
        end
      else
        rolls.last << input_value
      end
    end
    rolls.map { |r| Frame.new(r) }
  end

  def calculate_bonus(idx, frame)
    return 0 if idx >= 9

    next_stroke = @frames[idx + 1]
    second_stroke = @frames[idx + 2]
    if frame.strike?
      bonus_shots = (next_stroke ? next_stroke.shots : []) + (second_stroke ? second_stroke.shots : [])
      bonus_shots.first(2).sum
    elsif frame.spare?
      next_stroke ? next_stroke.shots[0] : 0
    else
      0
    end
  end
end

game = Game.new(ARGV[0])
puts game.main
