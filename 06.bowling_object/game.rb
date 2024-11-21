# frozen_string_literal: true

require './frame'
require './shot'

class Game
  def initialize(pinfall_text)
    @frames = parse_pinfall_text(pinfall_text).map.with_index { |shots, index| Frame.new(index, shots) }
  end

  def main
    total_score = @frames.sum { |frame| frame.calculate_score(@frames) }
    puts total_score
  end

  private

  def parse_pinfall_text(pinfall_text)
    all_shots = pinfall_text.split(',').map { |shot| Shot.new(shot) }
    shots = []
    all_shots.each_with_object([]) do |shot, shots_each_frame|
      shots << shot
      if shots_each_frame.length < 10
        if shots.length >= 2 || shot.strike?
          shots_each_frame << shots
          shots = []
        end
      else
        shots_each_frame.last << shot
      end
      shots_each_frame
    end
  end
end

game = Game.new(ARGV[0])
game.main
