# frozen_string_literal: true

require './frame'

class Game
  def initialize(mark)
    @mark = mark
  end

  def main
    total_score = 0
    pinfalls = parse_frames
    pinfalls.each_with_index do |pinfall, idx|
      frame = Frame.new(pinfall)
      total_score += frame.scores
      total_score += calculate_bonus(pinfalls, idx, frame)
    end
    total_score
  end

  private

  def generate_frames
    input_values = @mark.split(',')
    current_frame = []
    bowling_frames = []
    input_values.each do |input_value|
      current_frame << input_value
      if bowling_frames.length < 10
        if current_frame.length >= 2 || input_value == 'X'
          bowling_frames << current_frame
          current_frame = []
        end
      else
        bowling_frames.last << input_value
      end
    end
    bowling_frames
  end

  def parse_frames
    generate_frames.map { |generate_frame| Frame.new(generate_frame).shots }
  end

  def calculate_bonus(pinfalls, idx, frame)
    return 0 if idx >= 9

    next_frame = pinfalls[idx + 1] || []
    second_frame = pinfalls[idx + 2] || []
    if frame.strike?
      bonus_shots = next_frame + second_frame
      bonus_shots.first(2).sum
    elsif frame.spare?
      next_frame[0] || 0
    else
      0
    end
  end
end

game = Game.new(ARGV[0])
puts game.main
