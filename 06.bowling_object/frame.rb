# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def scores
    @shots.sum(&:score)
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    @shots[0..1].sum(&:score) == 10 && !strike?
  end
end
