# frozen_string_literal: true

class Player
  attr_accessor :name, :player_cards, :count, :money, :skip

  def initialize(name)
    @name = name
    @player_cards = []
    @count = 0
    @money = 100
    @skip = 0
  end
end
