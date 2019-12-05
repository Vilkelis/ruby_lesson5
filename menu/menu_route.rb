require_relative 'menu_base.rb'
require_relative '../models/route.rb'
require_relative '../tools/app_exception.rb'
require_relative '../helpers/menu_route_stations_manage_helper.rb'
require_relative '../helpers/menu_route_station_new_helper.rb'
# Route menu
class MenuRoute < MenuBase
  include MenuRouteStationsManageHelper
  include MenuRouteStationNewHelper

  def menu
    menu_show do
      list = []
      if @storage.routes.empty?
        menu_no_routes_show(list)
      else
        menu_routes_show(list)
      end
      list.push(key: 'N', name: 'Новый маршрут', proc: :route_new_first_station)

      { header: 'Маршруты', list: list }
    end
  end

  protected

  def menu_no_routes_show(list)
    list.push(name: 'нет ни одного маршрута')
    list.push(name: MENU_DELIMITER)
  end

  def menu_routes_show(list)
    @storage.routes.each.with_index(1) do |route, index|
      list.push(key: index, name: route.name, proc: :route, data: route)
    end
    list.push(name: MENU_DELIMITER)
    list.push(name: 'Для просмотра и управления '\
                    'маршрутом укажите его номер')
  end

  def route(call_menu_item)
    route = call_menu_item[:data]
    menu_show do
      list = []

      route_stations_show(route, list)
      route_stations_menu_finish_show(route, list)

      { header: 'Маршрут', list: list }
    end
  end

  def route_stations_menu_finish_show(route, list)
    if route.stations.count > 2
      list.push(name: 'Для исключения промежуточной станции'\
                      ' из маршрута укажите ее номер')
    end

    list.push(key: 'N', name: 'Добавить промежуточную станцию',
              proc: :route_include_station, data: route)
  end

  def route_stations_show(route, list)
    route.stations.each.with_index(1) do |station, index|
      list.push(key: index, name: station.name,
                proc: :route_exclude_station,
                data_station: station, data_route: route)
    end
    list.push(name: MENU_DELIMITER)
  end
end
