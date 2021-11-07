# frozen_string_literal: true

class Hand
  attr_accessor :card

  def initialize
    @card = []
  end

  def total_points
    total_points = 0
    card.flatten(1).to_h.each_value do |value|
      total_points > 10 && value == 11 ? total_points += 1 : total_points += value
    end
    total_points
  end
end
