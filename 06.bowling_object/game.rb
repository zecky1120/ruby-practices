# frozen_string_literal: true

require './frame'

class Game
  def initialize
    @frames = pinfall_scores
  end

  def main
    total_score = 0
    @frames.each_with_index do |frame, idx|
      total_score += frame.scores
      total_score += calculate_bonus(idx, frame)
    end
    puts total_score
  end

  private

  def parse_pinfall_text
    pinfall_results = ARGV[0].split(',').map { |roll| Shot.new(roll) }
    rolls = []
    pinfall_rolls = []
    pinfall_results.each do |pinfall_result|
      rolls << pinfall_result
      if pinfall_rolls.length < 10
        if rolls.length >= 2 || pinfall_result.strike?
          pinfall_rolls << rolls
          rolls = []
        end
      else
        pinfall_rolls.last << pinfall_result
      end
    end
    pinfall_rolls
  end

  def pinfall_scores
    parse_pinfall_text.map { |r| Frame.new(r.map(&:score)) }
  end

  def calculate_bonus(idx, frame)
    return 0 if idx >= 9

    next_rolls = @frames[idx + 1]
    second_rolls = @frames[idx + 2]
    if frame.strike?
      calculate_strike_point(next_rolls, second_rolls)
    elsif frame.spare?
      calculate_spare_point(next_rolls)
    else
      0
    end
  end

  def calculate_strike_point(next_rolls, second_rolls)
    bonus_shots = (next_rolls ? next_rolls.shot : []) + (second_rolls ? second_rolls.shot : [])
    bonus_shots.first(2).sum(&:score)
  end

  def calculate_spare_point(next_rolls)
    next_rolls ? next_rolls.shot[0].score : 0
  end
end

game = Game.new
game.main
