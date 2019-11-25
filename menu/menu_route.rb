require_relative 'menu_base.rb'
require_relative '../models/route.rb'
# Route menu
class MenuRoute < MenuBase
  def menu
    menu_show do
      list = []
      if @storage.routes.empty?
        list.push(name: 'нет ни одного маршрута')
        list.push(name: MENU_DELIMITER)
      else
        @storage.routes.each_with_index do |route, index|
          list.push(key: index + 1, name: route.name, proc: :route, data: route)
        end
        list.push(name: MENU_DELIMITER)
        list.push(name: 'Для просмотра и управления '\
                        'маршрутом укажите его номер')
      end
      list.push(key: 'N', name: 'Новый маршрут', proc: :route_new_first_station)

      { header: 'Маршруты', list: list }
    end
  end

  protected

  def route(call_menu_item)
    route = call_menu_item[:data]
    menu_show do
      list = []
      route.stations.each_with_index do |station, index|
        list.push(key: index + 1, name: station.name,
                  proc: :route_exclude_station,
                  data_station: station, data_route: route)
      end
      list.push(name: MENU_DELIMITER)
      if route.stations.count > 2
        list.push(name: 'Для исключения промежуточной станции'\
                        ' из маршрута укажите ее номер')
      end

      list.push(key: 'N', name: 'Добавить промежуточную станцию',
                proc: :route_include_station, data: route)

      { header: 'Маршрут', list: list }
    end
  end

  def route_exclude_station(call_menu_item)
    route = call_menu_item[:data_route]
    station = call_menu_item[:data_station]
    if [route.stations[0], route.stations[-1]].include? station
      puts 'Начальную или конечную станцию исключить нельзя из маршрута.'
      puts 'Можно исключать только промежуточные станции.'
      sleep_long
    else
      route.exclude_station(station)
      puts "Станция #{call_menu_item[:data_station].name} исключена из маршрута"
      sleep_short
    end
  end

  def route_include_station(call_menu_item)
    route = call_menu_item[:data]
    available_stations = @storage.stations - route.stations
    if available_stations.empty?
      puts 'Нет станций для включения в маршрут.'
      sleep_long
    else
      menu_show do
        list = []

        available_stations.each_with_index do |station, index|
          list.push(key: index + 1, name: station.name,
                    proc: :route_include_station_end,
                    data_station: station,
                    data_route: route)
        end

        list.push(name: MENU_DELIMITER)
        list.push(name: 'Для включения промежуточной станции'\
                        ' в маршрут укажите ее номер')
        { header: 'Добавление промежуточной станции', list: list }
      end
    end
  end

  def route_include_station_end(call_menu_item)
    call_menu_item[:data_route].include_station(call_menu_item[:data_station])
    puts "Станция #{call_menu_item[:data_station].name} включена в маршрут."
    sleep_short
    :quit_menu
  end

  def route_new_first_station(_call_menu_item)
    if @storage.stations.count < 2
      puts 'Для создания маршрута необходимо наличие минимум 2-х станций'
      sleep_long
    else
      menu_show do
        list = []
        @storage.stations.each_with_index do |station, index|
          list.push(key: index + 1, name: station.name,
                    proc: :route_new_last_station, data: station)
        end
        list.push(name: MENU_DELIMITER)
        list.push(name: 'Укажите станцию начала маршрута')

        { header: 'Станция начала маршрута', list: list }
      end
    end
  end

  def route_new_last_station(call_menu_item)
    first_station = call_menu_item[:data]
    menu_show do
      list = []
      i = 0
      @storage.stations.each do |station|
        next if first_station == station

        i += 1
        list.push(key: i, name: station.name,
                  proc: :route_new_end,
                  data_first_station: first_station,
                  data_last_station: station)
      end
      list.push(name: MENU_DELIMITER)
      list.push(name: 'Укажите станцию конца маршрута')
      { header: 'Станция окончания маршрута', list: list }
    end
    :quit_menu
  end

  def route_new_end(call_menu_item)
    @storage.routes << Route.new(call_menu_item[:data_first_station],
                                 call_menu_item[:data_last_station])
    :quit_menu
  end
end
