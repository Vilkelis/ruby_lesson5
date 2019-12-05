# frozen_string_literal: true

require_relative '../helpers/menu_constant_helper.rb'
# Helper for MenuRoute class
module MenuRouteStationNewHelper
  include MenuConstantHelper

  protected

  def route_new_first_station(_call_menu_item)
    if @storage.stations.count < 2
      puts 'Для создания маршрута необходимо наличие минимум 2-х станций'
      sleep_long
    else
      route_new_first_station_menu_show
    end
  end

  def route_new_first_station_menu_show
    menu_show do
      list = []
      @storage.stations.each.with_index(1) do |station, index|
        list.push(key: index, name: station.name,
                  proc: :route_new_last_station, data: station)
      end
      list.push(name: MENU_DELIMITER)
      list.push(name: 'Укажите станцию начала маршрута')

      { header: 'Станция начала маршрута', list: list }
    end
  end

  def route_new_last_station(call_menu_item)
    first_station = call_menu_item[:data]
    menu_show do
      list = []
      route_new_last_station_show(first_station, list)

      list.push(name: MENU_DELIMITER)
      list.push(name: 'Укажите станцию конца маршрута')
      { header: 'Станция окончания маршрута', list: list }
    end
    :quit_menu
  end

  def route_new_last_station_show(first_station, list)
    i = 0
    @storage.stations.each do |station|
      next if first_station == station

      i += 1
      list.push(key: i, name: station.name,
                proc: :route_new_end,
                data_first_station: first_station,
                data_last_station: station)
    end
  end

  def route_new_end(call_menu_item)
    begin
      @storage.routes << Route.new(call_menu_item[:data_first_station],
                                   call_menu_item[:data_last_station])
    rescue AppException::AppError => e
      puts e.message
      sleep_long
    end
    :quit_menu
  end
end
