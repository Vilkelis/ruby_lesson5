# frozen_string_literal: true

require_relative 'menu_base.rb'
require_relative '../models/station.rb'
require_relative '../tools/app_exception.rb'

# Station menu
class MenuStation < MenuBase
  def menu
    menu_show do
      list = []
      if @storage.stations.empty?
        menu_show_no_stations(list)
      else
        menu_show_stations(list)
      end
      list.push(key: 'N', name: 'Новая станция', proc: :station_new)

      { header: 'Станции', list: list }
    end
  end

  protected

  def menu_show_no_stations(list)
    list.push(name: 'список станций пуст')
    list.push(name: MENU_DELIMITER)
  end

  def menu_show_stations(list)
    @storage.stations.each.with_index(1) do |station, index|
      list.push(key: index, name: station.name,
                proc: :station_trains_list, data: station)
    end
    list.push(name: MENU_DELIMITER)
    list.push(name: 'Для просмотра поездов на станции'\
                    ' укажите номер станции')
  end

  def station_new(_call_menu_item)
    loop do
      clear_console
      puts "Новая станция #{MENU_EXIT_MESSAGE}"
      puts MENU_DELIMITER
      puts 'Укажите наименование станции: '
      station_name = gets.chomp.strip

      break if station_name.upcase == MENU_EXIT_KEY
      break if station_new_create?(station_name)
    end
  end

  def station_new_create?(station_name)
    if !station_by_name(station_name)
      station_new_create_do(station_name)
    else
      puts "Станция \"#{station_name}\" уже существует."\
           ' Используйте другое имя станции'
      sleep_long
    end
  end

  def station_by_name(station_name)
    @storage.stations.find do |station|
      station.name.downcase == station_name.downcase
    end
  end

  def station_new_create_do(station_name)
    @storage.stations << Station.new(station_name)
    puts "Станция \"#{station_name}\" создана."
    sleep_short
    true
  rescue AppException::AppError => e
    puts e.message
    sleep_long
    false
  end

  def station_trains_list(call_menu_item)
    menu_show do
      station = call_menu_item[:data]
      list = []

      station_trains_list_show(station, list)

      list.push(name: MENU_DELIMITER)
      list.push(name: MENU_EXIT_MESSAGE)

      { header: "Поезда на станции #{station.name}", list: list }
    end
  end

  def station_trains_list_show(station, list)
    if station.trains.count.positive?
      station.each_train do |train, index|
        list.push(name: "#{index}. #{train.name}"\
                        " (кол-во вагонов: #{train.railcars.count})")
      end
    else
      list.push(name: 'сейчас на станции нет ни одного поезда')
    end
  end
end
