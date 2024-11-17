# frozen_string_literal: true

require './frame'

class Game
  def initialize(pinfall_text)
    @frames = parse_pinfall_text(pinfall_text).each_with_index.map { |shots, idx| Frame.new(shots, idx) }
  end

  def main
    total_score = @frames.sum { |frame| frame.calculate_frame(@frames) }
    puts total_score
  end

  private

  def parse_pinfall_text(pinfall_text)
    all_shots = pinfall_text.split(',').map { |shot| Shot.new(shot) }
    shots = []
    shots_each_frame = []
    all_shots.each do |shot|
      shots << shot
      if shots_each_frame.length < 10
        if shots.length >= 2 || shot.strike?
          shots_each_frame << shots
          shots = []
        end
      else
        shots_each_frame.last << shot
      end
    end
    shots_each_frame
  end
end

game = Game.new(ARGV[0])
game.main
