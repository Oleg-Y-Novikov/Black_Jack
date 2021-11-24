# frozen_string_literal: true

class Player
  attr_accessor :name, :hand, :count, :money, :skip

  def initialize(name)
    @name = name
    @hand = Hand.new
    @count = 0
    @money = 100
    @skip = 0
  end
end
