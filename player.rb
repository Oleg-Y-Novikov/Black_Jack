class Player
  attr_accessor :name, :player_cards, :count, :money, :skip

  def initialize(name)
    @name = name
    @player_cards = []
    @count = 0
    @money = 10
    @skip = 0
  end

end
