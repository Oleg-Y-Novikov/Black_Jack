# frozen_string_literal: true

class Card
  BLACK_JACK = {
    🂢: 2, 🂣: 3, 🂤: 4, 🂥: 5, 🂦: 6, 🂧: 7, 🂨: 8,
    🂩: 9, 🂪: 10, 🂫: 10, 🂭: 10, 🂮: 10, 🂡: 11,

    🂲: 2, 🂳: 3, 🂴: 4, 🂵: 5, 🂶: 6, 🂷: 7, 🂸: 8,
    🂹: 9, 🂺: 10, 🂻: 10, 🂽: 10, 🂾: 10, 🂱: 11,

    🃂: 2, 🃃: 3, 🃄: 4, 🃅: 5, 🃆: 6, 🃇: 7, 🃈: 8,
    🃉: 9, 🃊: 10, 🃋: 10, 🃍: 10, 🃎: 10, 🃁: 11,

    🃒: 2, 🃓: 3, 🃔: 4, 🃕: 5, 🃖: 6, 🃗: 7, 🃘: 8,
    🃙: 9, 🃚: 10, 🃛: 10, 🃝: 10, 🃞: 10, 🃑: 11
  }.freeze

  attr_reader :card

  def initialize(card = BLACK_JACK)
    @card = Marshal.load(Marshal.dump(card))
  end
end
