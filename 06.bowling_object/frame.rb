# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :shots

  def initialize(rolls)
    @shots = rolls.map { |roll| Shot.new(roll) }
  end

  def scores
    @shots.sum(&:score)
  end

  def strike?
    @shots[0].score == 10
  end

  def spare?
    @shots[0].score + @shots[1].score == 10
  end
end
