# frozen_string_literal: true

class Dealer
  attr_accessor :name, :hand, :count, :money

  def initialize
    @name = "Dealer"
    @hand = Hand.new
    @count = 0
    @money = 100
  end
end
