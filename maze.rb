# encoding :utf-8
require './position.rb'
require 'pp'
require 'benchmark'

include Benchmark

class Maze
  attr_accessor :nexts, :closed_list, :current
  START = Position.new(3, 9, "start")
  GOAL = Position.new(3, 0, "goal")
  MAP = [
    ['□', '□', '□', 'Ｇ', '□', '□', '□'],
    ['□', '□', '□', '□', '□', '□', '□'],
    ['□', '■', '■', '■', '■', '■', '□'],
    ['□', '□', '□', '□', '□', '□', '□'],
    ['□', '□', '□', '□', '□', '□', '□'],
    ['□', '□', '□', '□', '□', '□', '□'],
    ['□', '□', '□', '□', '□', '□', '□'],
    ['□', '□', '□', '□', '□', '□', '□'],
    ['□', '□', '□', '□', '□', '□', '□'],
    ['□', '□', '■', 'Ｓ', '■', '□', '□']
  ]

  def initialize
    @nexts = []
    @closed = []
  end

  def put_map(current = nil)
    copy = MAP.clone
    copy.each_with_index do |horizantaly, y|
      horizantaly.each_with_index do |verticaly, x|
        if (!current.nil?) && current.same?(x, y)
          print "◎"
        else
          print verticaly
        end
      end
      puts
    end
    puts
  end

  def chase
    put_map
    @current = START
    @closed << START

    count = 0
    Benchmark.bm 5 do |r|        # (計測したい処理)
      r.report "time" do
        loop do
          put_map(@current)
          set_points(@current)
          @current = next_position
          count += 1
          if GOAL.same?(@current.x, @current.y)
            break
          end
        end
      end
    end

    put_map(@current)
    puts "GOAL"
    printf("ユークリッド距離 : %d \n",count)
  end

  def next_position
    min = nil
    distinations = @nexts.select{|i|not i.same?(@current.x, @current.y)}
    distinations = distinations.select{|i|i.parent == @current}

    distinations.each do |i|
      if include_point?(@closed , i)
        next
      end
      if min.nil?
        min = i
        next
      end
      min = i if i.total_expected < min.total_expected
    end

    if min.nil?
      min = @current.parent
    end

    @closed << min
    return min
  end

  def set_points(point)
    left = nil
    right = nil
    up = nil
    down = nil

    unless point.y == 0
      up = Position.new(point.x, point.y - 1, point)
    end

    unless point.y == MAP.size - 1
      down = Position.new(point.x, point.y + 1, point)
    end

    unless point.x == 0
      left = Position.new(point.x - 1, point.y, point)
    end

    unless point.x == MAP[point.x].size - 1
      right = Position.new(point.x + 1, point.y, point)
    end

    append(MAP, left)
    append(MAP, right)
    append(MAP, up)
    append(MAP, down)
  end

  def include_point?(points, point)
    points.each do |locate|
      return locate if locate.same?(point.x, point.y)
    end
    return nil
  end

  def append(map, point)
    if point == nil
      return nil
    end

    unless (map[point.y][point.x] == "□") || (map[point.y][point.x] == "Ｇ")
      return nil
    end

    point.expected = START.distance(point.parent)
    point.total_expected = GOAL.distance(point)

    candidate = include_point?(@nexts, point)
    if candidate
      if candidate.expected > point.expected
        @nexts.delete(candidate)
        @nexts << point
      end
    else
      @nexts << point
    end

    chance = include_point?(@closed, point)
    if chance
      if chance.expected > point.expected
        @closed.delete(candidate)
        @closed << point
      end
    end
  end
end

@maze = Maze.new.chase
