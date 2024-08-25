# frozen_string_literal: true

require 'optparse'
require './frame'

class Game
  def initialize(shot)
    @shot = shot
  end

  def shots
    @shot.split(',')
  end

  def build_frames
    numbers = shots.map { |s| Shot.new(s).score }
    frame = []
    frames = []
    numbers.each do |n|
      frame << n
      if frames.length < 10
        if frame.length >= 2 || n == 10
          frames << frame.dup
          frame.clear
        end
      else
        frames.last << n
      end
    end
    frames
  end


  def score
    total = 0
    build_frames.take(10).each do |build_frame|
      @first_shot = build_frame[0]
      @second_shot = build_frame[1]
      @third_shot = build_frame[2]
      frame = Frame.new(@first_shot, @second_shot, @third_shot)
      total += frame.scores
    end
    total + add_bonus
  end

  def add_bonus
    bonus = 0
    build_frames.take(9).each_with_index do |f, i|
      rolls = build_frames[i.succ].size >= 2
      next_shot = build_frames[i.succ].first(2).sum
      next_frame = rolls ? next_shot : build_frames[i.succ].sum + build_frames[i.succ + 1][0]
      strike = f[0] == 10
      spare = f.sum == 10
      if strike
        bonus += next_frame
      elsif spare
        bonus += build_frames[i + 1][0]
      else
        0
      end
    end
    bonus
  end
end

game = Game.new(ARGV[0])
puts game.score
