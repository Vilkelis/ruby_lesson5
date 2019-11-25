require_relative 'menu_base.rb'
require_relative '../models/station.rb'

# Station menu
class MenuStation < MenuBase
  def menu
    menu_show do
      list = []
      if @storage.stations.empty?
        list.push(name: 'список станций пуст')
        list.push(name: MENU_DELIMITER)
      else
        @storage.stations.each.with_index(1) do |station, index|
          list.push(key: index, name: station.name,
                    proc: :station_trains_list, data: station)
        end
        list.push(name: MENU_DELIMITER)
        list.push(name: 'Для просмотра поездов на станции'\
                        ' укажите номер станции')
      end
      list.push(key: 'N', name: 'Новая станция', proc: :station_new)

      { header: 'Станции', list: list }
    end
  end

  protected

  def station_new(_call_menu_item)
    loop do
      clear_console
      puts "Новая станция #{MENU_EXIT_MESSAGE}"
      puts MENU_DELIMITER
      puts 'Укажите наименование станции: '
      station_name = gets.chomp.strip

      break if station_name.upcase == MENU_EXIT_KEY

      station_found = @storage.stations.find do |station|
        station.name.downcase == station_name.downcase
      end
      if !station_found
        @storage.stations << Station.new(station_name)
        puts "Станция \"#{station_name}\" создана."
        sleep_short
        break
      else
        puts "Станция \"#{station_name}\" уже существует."\
             ' Используйте другое имя станции'
        sleep_long
      end
    end
  end

  def station_trains_list(call_menu_item)
    menu_show do
      station = call_menu_item[:data]
      list = []
      if station.trains.count > 0
        station.trains.each.with_index(1) do |train, index|
          list.push(name: "#{index}. #{train.name}")
        end
      else
        list.push(name: 'сейчас на станции нет ни одного поезда')
      end
      list.push(name: MENU_DELIMITER)
      list.push(name: MENU_EXIT_MESSAGE)

      { header: "Поезда на станции #{station.name}", list: list }
    end
  end
end
