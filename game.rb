# frozen_string_literal: true

class Game
  CARDS = {
    🂢: 2, 🂣: 3, 🂤: 4, 🂥: 5, 🂦: 6, 🂧: 7, 🂨: 8,
    🂩: 9, 🂪: 10, 🂫: 10, 🂭: 10, 🂮: 10, 🂡: 11,

    🂲: 2, 🂳: 3, 🂴: 4, 🂵: 5, 🂶: 6, 🂷: 7, 🂸: 8,
    🂹: 9, 🂺: 10, 🂻: 10, 🂽: 10, 🂾: 10, 🂱: 11,

    🃂: 2, 🃃: 3, 🃄: 4, 🃅: 5, 🃆: 6, 🃇: 7, 🃈: 8,
    🃉: 9, 🃊: 10, 🃋: 10, 🃍: 10, 🃎: 10, 🃁: 11,

    🃒: 2, 🃓: 3, 🃔: 4, 🃕: 5, 🃖: 6, 🃗: 7, 🃘: 8,
    🃙: 9, 🃚: 10, 🃛: 10, 🃝: 10, 🃞: 10, 🃑: 11
  }.freeze

  def self.run
    new.run
  end

  def run
    clear
    file = File.new("./image/info.txt", "r")
    puts file.read
    file.close
    create_players
    loop do
      hand_out_cards
      total_points
      print_status("skip")
      player_step
      print_result
      puts "Хотите сыграть ещё раз? Введите y/n"
      choice = gets.chomp
      @bank = 0
      @player.skip = 0
      break if choice == "n"
    end
  end

  private

  def create_players
    print "Введите ваше имя: "
    name = gets.chomp
    raise "Вы не ввели своё имя!" if name.nil? || name == ""

    @player = Player.new(name)
    @dealer = Dealer.new
  rescue RuntimeError => e
    puts e
    retry
  end

  def hand_out_cards
    @deck_of_cards = Marshal.load(Marshal.dump(CARDS))
    @player.player_cards = @deck_of_cards.keys.sample(2)
    @deck_of_cards.delete_if { |k, _v| @player.player_cards.include?(k) }
    @dealer.dealer_cards = @deck_of_cards.keys.sample(2)
    @deck_of_cards.delete_if { |k, _v| @dealer.dealer_cards.include?(k) }
    place_bets
  end

  def place_bets
    if @player.money < 10
      `play {{./audio/1.wav}}`
      clear
      abort "Вы проиграли все деньги...🤬"
    elsif @dealer.money < 10
      abort "Победа! Вы оставили казино без денег! 🤑🥳"
    else
      @bank = 20
      @player.money -= 10
      @dealer.money -= 10
    end
  end

  def show
    clear
    puts
    @dealer.dealer_cards.each { |card| print "#{card}  " }
    puts "Сумма очков: #{@dealer.count}"
    puts
    @player.player_cards.each { |card| print "#{card}  " }
    puts "Сумма очков: #{@player.count}"
  end

  def print_status(status)
    clear
    puts
    if status == "show"
      show
    else
      @dealer.dealer_cards.each { print '🂠  ' }
      puts
      puts
      @player.player_cards.each { |card| print "#{card}  " }
      puts "Сумма очков: #{@player.count}"
    end
  end

  def dealer_score
    @dealer.dealer_cards.each do |card|
      @dealer.count > 10 && CARDS[card] == 11 ? @dealer.count += 1 : @dealer.count += CARDS[card]
    end
  end

  def player_score
    @player.player_cards.each do |card|
      @player.count > 10 && CARDS[card] == 11 ? @player.count += 1 : @player.count += CARDS[card]
    end
  end

  def total_points
    @dealer.count = 0
    @player.count = 0
    dealer_score
    player_score
  end

  def player_step
    while @player.player_cards.size < 3
      if @player.skip.zero?
        puts "'skip'-пропустить ход,'take'-добавить карту,'show'-открыть карты:"
      else
        puts "Введите 'take'- добавить карту, 'show'- открыть карты:"
      end
      choice = gets.chomp
      next_step(choice)
      return if choice == "show"
    end
  end

  def next_step(choice)
    case choice
    when "take"
      @player.player_cards << @deck_of_cards.keys.sample
      @deck_of_cards.delete_if { |k, _v| @player.player_cards.include?(k) }
      dealer_step
      total_points
      print_status("show")
    when "skip"
      @player.skip = 1
      dealer_step
      total_points
      print_status("skip")
    when "show"
      print_status("show")
    end
  end

  def dealer_step
    return if @dealer.count >= 17 || @dealer.dealer_cards.size > 2

    @dealer.dealer_cards << @deck_of_cards.keys.sample
    @deck_of_cards.delete_if { |k, _v| @dealer.dealer_cards.include?(k) }
  end

  def clear
    system "clear" or system "cls"
  end

  def check_status
    return 0 if (21 - @player.count) == (21 - @dealer.count)

    return 1 if @dealer.count > 21

    return 1 if (21 - @player.count).abs < (21 - @dealer.count).abs
  end

  def print_result
    case check_status
    when 0
      @player.money += @bank / 2
      @dealer.money += @bank / 2
      puts "Ничья, на счету $#{@player.money}"
    when 1
      @player.money += @bank
      puts "Ура! Вы выйграли! 🎉 на счету $#{@player.money}"
    else
      @dealer.money += @bank
      puts "Увы, вы проиграли...💸 Остаток на счету $#{@player.money}"
    end
  end
end
