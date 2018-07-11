# encoding: utf-8

class Position
  attr_accessor :x, :y, :parent, :expected, :total_expected
  def initialize(x, y, parent = nil, expected = nil, total_expected = nil)
    @x = x
    @y = y
    @parent = parent
    @expected = expected
    @total_expected = total_expected
  end

  def distance(point)
    x_diff = x - point.x
    y_diff = y - point.y
    x_diff.abs + y_diff.abs
  end

  def same?(x, y)
    if @x == x && @y == y
      return true
    end
    return false
  end
end

