# frozen_string_literal: true

class Interface
  def self.run
    new.run
  end

  attr_reader :game

  def initialize
    @current_path = File.dirname(__FILE__)
    @start_image = File.readlines("#{@current_path}/../image/info.txt")
  end

  def run
    clear
    puts @start_image
    create_player
    loop do
      game.new_deck
      game.deal_cards(2, game.player, game.opponent)
      game.place_bets
      print_status
      player_step
      print_result
      puts "Хотите сыграть ещё раз? Введите y/n"
      choice = gets.chomp
      game.clean
      break if choice == "n"
    end
  end

  private

  def create_player
    print "Введите ваше имя: "
    player_name = gets.chomp
    raise "Вы не ввели своё имя!" if player_name.nil? || player_name == ""

    @game = Games.new(player_name)
  rescue RuntimeError => e
    puts e
    retry
  end

  def print_status(status = "skip")
    clear
    puts
    if status == "show"
      show
    else
      game.opponent.hand.card.flatten(1).to_h.each_key { print '🂠  ' }
      puts
      puts
      game.player.hand.card.flatten(1).to_h.each_key { |card| print "#{card}  " }
      puts "Сумма очков: #{game.player.hand.total_points}"
    end
  end

  def player_step
    while game.player.hand.card.flatten(1).size < 3
      if game.player.skip.zero?
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
      game.deal_cards(1, game.player)
      game.opponent_step
      print_status("show")
    when "skip"
      game.player.skip = 1
      game.opponent_step
      print_status
    when "show"
      print_status("show")
    end
  end

  def clear
    system "clear" or system "cls"
  end

  def show
    clear
    puts
    game.opponent.hand.card.flatten(1).to_h.each_key { |card| print "#{card}  " }
    puts "Сумма очков: #{game.opponent.hand.total_points}"
    puts
    game.player.hand.card.flatten(1).to_h.each_key { |card| print "#{card}  " }
    puts "Сумма очков: #{game.player.hand.total_points}"
  end

  def print_result
    case game.check_status
    when 0
      game.player.money += game.bank / 2
      game.opponent.money += game.bank / 2
      puts "Ничья, на счету $#{game.player.money}"
    when 1
      game.player.money += game.bank
      puts "Ура! Вы выйграли! 🎉 на счету $#{game.player.money}"
    else
      game.opponent.money += game.bank
      puts "Увы, вы проиграли...💸 Остаток на счету $#{game.player.money}"
    end
  end
end
