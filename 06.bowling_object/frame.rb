# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :shots

  def initialize(frame)
    @shots = frame.map { |f| Shot.new(f).score }
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
