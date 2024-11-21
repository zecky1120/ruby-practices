# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(index, shots)
    @index = index
    @shots = shots
  end

  def calculate_score(frames)
    score_without_bonus + calculate_bonus(frames)
  end

  private

  def score_without_bonus
    @shots.sum(&:score)
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    @shots.first(2).sum(&:score) == 10 && !strike?
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
