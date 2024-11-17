# frozen_string_literal: true

require './frame'

class Game
  def initialize(pinfall_text)
    @frames = parse_pinfall_text(pinfall_text).map { |shots| Frame.new(shots) }
  end

  def main
    total_score = @frames.sum { |frame| frame.scores(@frames) }
    puts total_score
  end

  private

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
end

game = Game.new(ARGV[0])
game.main
