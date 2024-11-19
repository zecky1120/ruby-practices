# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :shots

  def initialize(index, shots)
    @index = index
    @shots = shots
  end

  def calculate_frame(frames)
    calculate_score + calculate_bonus(frames)
  end

  private

  def calculate_score
    @shots.sum(&:score)
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    @shots[0..1].sum(&:score) == 10 && !strike?
  end

  def calculate_bonus(frames)
    return 0 if @index >= 9

    next_frame = frames[@index + 1]
    after_next_frame = frames[@index + 2]
    if strike?
      calculate_strike_bonus(next_frame, after_next_frame)
    elsif spare?
      calculate_spare_bonus(next_frame)
    else
      0
    end
  end

  def calculate_strike_bonus(next_frame, after_next_frame)
    bonus_shots = (next_frame&.shots || []) + (after_next_frame&.shots || [])
    bonus_shots.first(2).sum(&:score)
  end

  def calculate_spare_bonus(next_frame)
    next_frame ? next_frame.shots[0].score : 0
  end
end
