# frozen_string_literal: true

require './shot'

class Frame
  def initialize(first_shot, second_shot = 0, third_shot = 0)
    @first_shot = Shot.new(first_shot).score
    @second_shot = Shot.new(second_shot).score
    @third_shot = Shot.new(third_shot).score
  end

  def scores
    [@first_shot, @second_shot, @third_shot].sum
  end

  def strike?
    @first_shot == 10
  end

  def spare?
    @first_shot + @second_shot == 10
  end
end
