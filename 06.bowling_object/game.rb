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

  def main
    @frames = frames
    total = 0
    (0..8).each do |n|
      frame = Frame.new(@frames[n])
      total += frame.scores
      total += add_bonus(frame, n)
    end
    total + @frames.last.sum
  end

  def frames
    scores = shots.map { |shot| Shot.new(shot).score }
    frame = []
    frames = []
    scores.each do |score|
      frame << score
      if frames.length < 10
        if frame.length >= 2 || score == 10
          frames << frame.dup
          frame.clear
        end
      else
        frames.last << score
      end
    end
    frames
  end

  def add_bonus(frame, idx)
    bonus = 0
    frame_size = frames[idx.succ].size >= 2
    next_shot = frames[idx.succ].first(2).sum
    next_frame = frame_size ? next_shot : next_shot + frames[idx.succ + 1][0]
    if frame.strike?
      bonus += next_frame
    elsif frame.spare?
      bonus += frames[idx + 1][0]
    else
      0
    end
    bonus
  end
end

game = Game.new(ARGV[0])
puts game.main
