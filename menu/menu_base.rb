require_relative '../helpers/menu_constant_helper.rb'
# Base text menu class
class MenuBase
  include MenuConstantHelper

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
      clear_console
      menu_settings = menu_settings_method.call

      menu_settings_show(menu_settings)

      item_key = gets.chomp.strip.upcase

      break if item_key == MENU_EXIT_KEY
      break if menu_show_action?(item_key, menu_settings)
    end
  end

  def menu_show_action?(item_key, menu_settings)
    menu_item = menu_show_action_find_item(item_key, menu_settings)

    if menu_item.nil?
      puts "Действие #{item_key} отсутсвует в списке."
      sleep_long
    elsif method(menu_item[:proc]).call(menu_item) == :quit_menu
      true
    end
  end

  def menu_show_action_find_item(item_key, menu_settings)
    return if item_key.empty?

    menu_settings[:list].find do |item|
      item[:key].to_s.upcase == item_key
    end
  end

  def menu_settings_show(menu_settings)
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
  end
end
