# frozen_string_literal: true

class Shot
  STRIKE_MARK = 'X'

  def initialize(shot)
    @shot = shot
  end

  def score
    @shot == STRIKE_MARK ? 10 : @shot.to_i
  end

  def strike?
    @shot == STRIKE_MARK
  end
end
