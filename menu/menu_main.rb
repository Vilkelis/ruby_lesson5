require_relative 'menu_base.rb'
require_relative 'menu_station.rb'
require_relative 'menu_route.rb'
require_relative 'menu_train.rb'
require_relative 'menu_railcar.rb'
# Main menu
class MenuMain < MenuBase
  def menu
    menu_show do
      { header: 'Меню',
        list: [{ key: 1, name: 'Станции',  proc: :stations_list },
               { key: 2, name: 'Маршруты', proc: :routes_list },
               { key: 3, name: 'Поезда',   proc: :trains_list },
               { key: 4, name: 'Вагоны',   proc: :railcars_list },
               { name: MENU_DELIMITER },
               { name: 'Укажите номер пункта меню:' }] }
    end
  end

  protected

  def stations_list(_call_menu_item)
    MenuStation.new(@storage).menu
  end

  def routes_list(_call_menu_item)
    MenuRoute.new(@storage).menu
  end

  def trains_list(_call_menu_item)
    MenuTrain.new(@storage).menu
  end

  def railcars_list(_call_menu_item)
    MenuRailcar.new(@storage).menu
  end
end
