# frozen_string_literal: true

class Games
  attr_reader :player, :opponent, :bank

  def initialize(player_name)
    @player = Player.new(player_name)
    @opponent = Dealer.new
    @bank = 0
    @playing_cards = Card.new
  end

  def clean
    @bank = 0
    @player.skip = 0
    @player.hand.card.clear
    @opponent.hand.card.clear
  end

  def new_deck
    @deck = Deck.new(@playing_cards.card)
  end

  def deal_cards(count, *players)
    @deck.hand_out_cards(count, *players)
  end

  def check_status
    return 0 if (21 - @player.hand.total_points) == (21 - @opponent.hand.total_points)

    return if @player.hand.total_points > 21

    return 1 if @opponent.hand.total_points > 21

    return 1 if (21 - @player.hand.total_points) < (21 - @opponent.hand.total_points)
  end

  def opponent_step
    return if @opponent.hand.total_points >= 17 || @opponent.hand.card.flatten(1).to_h.size > 2

    @deck.hand_out_cards(1, @opponent)
  end

  def place_bets
    if @player.money < 10
      `play {{./../audio/1.wav}}`
      abort "Вы проиграли все деньги...🤬"
    elsif @opponent.money < 10
      abort "Победа! Вы оставили казино без денег! 🤑🥳"
    else
      @bank = 20
      @player.money -= 10
      @opponent.money -= 10
    end
  end
end
