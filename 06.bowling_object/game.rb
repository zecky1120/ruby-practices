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
    all_shots = pinfall_text.split(',').map { |shot| Shot.new(shot) }
    shots = []
    shots_by_frames = []
    all_shots.each do |shot|
      shots << shot
      if shots_by_frames.length < 10
        if shots.length >= 2 || shot.strike?
          shots_by_frames << shots
          shots = []
        end
      else
        shots_by_frames.last << shot
      end
    end
    shots_by_frames
  end
end

game = Game.new(ARGV[0])
game.main
