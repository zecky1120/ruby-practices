# frozen_string_literal: true

class Shot
  STRIKE_MARK = 'X'

  def initialize(pin)
    @pin = pin
  end

  def score
    strike? ? 10 : @pin.to_i
  end

  def strike?
    @pin == STRIKE_MARK
  end
end
