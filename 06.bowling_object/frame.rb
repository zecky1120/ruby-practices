# frozen_string_literal: true

require './shot'

class Frame
  def initialize(frame)
    @first_shot = Shot.new(frame[0]).score
    @second_shot = Shot.new(frame[1]).score
    @third_shot = Shot.new(frame[2]).score
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
