# frozen_string_literal: true

class Shot
  STRIKE_MARK = 'X'

  def initialize(roll)
    @roll = roll
  end

  def score
    @roll == STRIKE_MARK ? 10 : @roll.to_i
  end

  def strike?
    @roll == STRIKE_MARK
  end
end
