# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def scores(frames)
    idx = frames.index(self)
    score + calculate_bonus(idx, frames)
  end

  private

  def score
    @shots.sum(&:score)
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    @shots[0..1].sum(&:score) == 10 && !strike?
  end

  def calculate_bonus(idx, frames)
    return 0 if idx >= 9

    next_frame = frames[idx + 1]
    second_frame = frames[idx + 2]
    if strike?
      calculate_strike_point(next_frame, second_frame)
    elsif spare?
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
