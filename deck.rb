# frozen_string_literal: true

class Deck
  attr_accessor :deck

  def initialize(card)
    @deck = card
  end

  def hand_out_cards(count, *players)
    players.each do |player|
      player.hand.card << deck.to_a.sample(count)
      deck.delete_if { |k, _v| player.hand.card.flatten.include?(k) }
    end
  end
end
