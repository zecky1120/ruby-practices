# frozen_string_literal: true

require './shot'

class Frame
  attr_reader :shot

  def initialize(rolls)
    @shot = rolls.map { |roll| Shot.new(roll) }
  end

  def scores
    @shot.sum(&:score)
  end

  def strike?
    @shot[0].score == 10
  end

  def spare?
    @shot[0].score + @shot[1].score == 10
  end
end
