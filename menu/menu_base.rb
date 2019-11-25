# Base text menu class
class MenuBase
  MENU_DELIMITER = '----------'.freeze
  MENU_EXIT_MESSAGE = '(Q - выйти)'.freeze
  MENU_EXIT_KEY = 'Q'.freeze
  SLEEP_LONG = 2
  SLEEP_SHORT = 1

  def initialize(storage)
    @storage = storage
  end

  protected

  def sleep_short
    sleep(SLEEP_SHORT)
  end

  def sleep_long
    sleep(SLEEP_LONG)
  end

  def clear_console
    system('cls') || system('clear') || puts('\e[H\e[2J')
    ''
  end

  def menu_show(&menu_settings_method)
    loop do
      menu_settings = menu_settings_method.call

      clear_console
      puts "#{menu_settings[:header]} #{MENU_EXIT_MESSAGE}"
      puts MENU_DELIMITER

      menu_settings[:list].each do |data|
        if data[:key]
          puts "#{data[:key]}#{data[:key].to_s =~ /^[0-9]*$/ ? '.' : ' - '}"\
               " #{data[:name]}"
        else
          puts data[:name]
        end
      end

      item_key = gets.chomp.strip.upcase

      break if item_key == MENU_EXIT_KEY

      menu_item = menu_settings[:list].find do |item|
        item[:key].to_s.upcase == item_key
      end

      if menu_item.nil?
        puts "Действие #{item_key} отсутсвует в списке."
        sleep_long
      elsif method(menu_item[:proc]).call(menu_item) == :quit_menu
        break
      end
    end
  end
end
