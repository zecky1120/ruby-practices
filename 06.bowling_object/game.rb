# frozen_string_literal: true

require 'optparse'
require './frame'

class Game
  def initialize(shot)
    @shot = shot
  end

  def shot_scores
    @shot.split(',')
  end

  def main
    @frames = frames
    total = 0
    (0..8).each do |i|
      frame = Frame.new(@frames[i])
      total += frame.scores
      total += add_bonus(frame, i)
      add_bonus(frame, i)
    end
    total + @frames.last.sum
  end

  def frames
    shots = shot_scores.map { |shot| Shot.new(shot).score }
    frame = []
    frames = []
    shots.each do |s|
      frame << s
      if frames.length < 10
        if frame.length >= 2 || s == 10
          frames << frame.dup
          frame.clear
        end
      else
        frames.last << s
      end
    end
    frames
  end

  def add_bonus(frame, i)
    bonus = 0
    frame_size = frames[i.succ].size >= 2
    next_shot = frames[i.succ].first(2).sum
    next_frame = frame_size ? next_shot : next_shot + frames[i.succ + 1][0]
    if frame.strike?
      bonus += next_frame
    elsif frame.spare?
      bonus += frames[i + 1][0]
    else
      0
    end
    bonus
  end

end

game = Game.new(ARGV[0])
puts game.main
