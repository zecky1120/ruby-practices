# frozen_string_literal: true

require './shot'

class Frame
  def initialize(frame)
    @shots = frame.map { |f| Shot.new(f).score }
    # @first_shot = Shot.new(frame[0]).score
    # @second_shot = Shot.new(frame[1]).score
    # @third_shot = Shot.new(frame[2]).score
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

frame = Frame.new([6, 3])
p frame.strike?
