# frozen_string_literal: true

require_relative '../helpers/menu_constant_helper.rb'
# Helper for MenuRoute class
module MenuRouteStationsManageHelper
  include MenuConstantHelper

  protected

  def route_exclude_station(call_menu_item)
    route = call_menu_item[:data_route]
    station = call_menu_item[:data_station]
    if [route.stations[0], route.stations[-1]].include? station
      puts 'Начальную или конечную станцию исключить нельзя из маршрута.'
      puts 'Можно исключать только промежуточные станции.'
      sleep_long
    else
      route_exclude_station_do(route, station)
      sleep_short
    end
  end

  def route_exclude_station_do(route, station)
    route.exclude_station(station)
    puts "Станция #{station.name} исключена из маршрута"
  end

  def route_include_station(call_menu_item)
    route = call_menu_item[:data]
    available_stations = @storage.stations - route.stations
    if available_stations.empty?
      puts 'Нет станций для включения в маршрут.'
      sleep_long
    else
      route_include_station_menu(route, available_stations)
    end
  end

  def route_include_station_menu(route, available_stations)
    menu_show do
      list = []
      route_include_station_show(route, available_stations, list)
      { header: 'Добавление промежуточной станции', list: list }
    end
  end

  def route_include_station_show(route, available_stations, list)
    available_stations.each.with_index(1) do |station, index|
      list.push(key: index, name: station.name,
                proc: :route_include_station_end,
                data_station: station,
                data_route: route)
    end

    list.push(name: MENU_DELIMITER)
    list.push(name: 'Для включения промежуточной станции'\
                    ' в маршрут укажите ее номер')
  end

  def route_include_station_end(call_menu_item)
    call_menu_item[:data_route].include_station(call_menu_item[:data_station])
    puts "Станция #{call_menu_item[:data_station].name} включена в маршрут."
    sleep_short
    :quit_menu
  end
end
