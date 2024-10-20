# frozen_string_literal: true

class Shot
  STRIKE_MARK = 'X'

  def initialize(mark)
    @mark = mark
  end

  def score
    @mark == STRIKE_MARK ? 10 : @mark.to_i
  end
end
