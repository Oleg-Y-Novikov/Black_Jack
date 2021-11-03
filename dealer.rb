class Dealer
  attr_accessor :name, :dealer_cards, :count, :money

  def initialize
    @name = "Dealer"
    @dealer_cards = []
    @count = 0
    @money = 100
  end
end
