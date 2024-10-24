# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :shots

  def initialize(rolls)
    @shots = rolls.map { |roll| Shot.new(roll).score }
  end

  def scores
    @shots.sum
  end

  def strike?
    @shots[0] == 10
  end

  def spare?
    @shots[0] + @shots[1] == 10
  end
end
