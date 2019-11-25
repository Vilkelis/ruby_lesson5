require_relative 'menu_base.rb'
require_relative '../models/passanger_railcar.rb'
require_relative '../models/cargo_railcar.rb'
# Railcar menu
class MenuRailcar < MenuBase
  def menu
    menu_show do
      list = []
      if @storage.railcars.empty?
        list.push(name: 'нет ни одного вагона')
        list.push(name: MENU_DELIMITER)
      else
        @storage.railcars.each.with_index(1) do |railcar, index|
          list.push(key: index,
                    name: railcar.name +
                          if railcar.train.nil?
                            ''
                          else
                            ' - прицеплен к поезду ' + railcar.train.name
                          end,
                    proc: :railcar_info,
                    data: railcar)
        end
        list.push(name: MENU_DELIMITER)
        list.push(name: 'Для просмотра информации по вагону '\
                        'укажите его номер')
      end
      list.push(key: 'N', name: 'Новый вагон', proc: :railcar_new)

      { header: 'Вагоны', list: list }
    end
  end

  protected

  def railcar_new(_call_menu_item)
    menu_show do
      { header: 'Выберите тип вагона',
        list: [{ key: 1, name: 'пассажирский',
                 proc: :railcar_new_end, data: PassangerRailcar },
               { key: 2, name: 'грузовой',
                 proc: :railcar_new_end, data: CargoRailcar },
               { name: MENU_DELIMITER },
               { name: 'Укажите номер типа вагона:' }] }
    end
  end

  def railcar_new_end(call_menu_item)
    @storage.railcars << call_menu_item[:data].new
    puts "Вагон #{@storage.railcars[-1].name} создан."
    sleep_short
    :quit_menu
  end

  def railcar_info(call_menu_item)
    menu_show do
      railcar = call_menu_item[:data]
      train = railcar.train
      list = []
      list.push(name: railcar.name)
      list.push(name: 'прицеплен к поезду: ' +
                      if train.nil?
                        'не прицеплен'
                      else
                        train.name
                      end)
      list.push(name: 'следует по маршруту: ' +
                      if train.nil? || train.route.nil?
                        'маршрут не указан'
                      else
                        train.route.name
                      end)
      list.push(name: 'находится на станции: ' +
                      if train.nil? || train.current_station.nil?
                        'станция не определена'
                      else
                        train.current_station.name
                      end)
      list.push(name: MENU_DELIMITER)
      list.push(name: MENU_EXIT_MESSAGE)

      { header: 'Информация по вагону', list: list }
    end
  end
end
