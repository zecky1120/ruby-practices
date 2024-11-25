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
      (next_frame.shots + (after_next_frame&.shots || [])).first(2).sum(&:score)
    elsif spare?
      next_frame.shots[0].score
    else
      0
    end
  end
end
