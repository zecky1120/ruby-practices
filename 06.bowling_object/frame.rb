# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :shots

  def initialize(strokes)
    @shots = strokes.map { |stroke| Shot.new(stroke).score }
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
