# frozen_string_literal: true

require_relative 'menu_base.rb'
require_relative '../models/cargo_train.rb'
require_relative '../models/passanger_train.rb'
require_relative '../tools/app_exception.rb'
require_relative '../helpers/menu_train_new_helper.rb'
require_relative '../helpers/menu_train_railcar_manage_helper.rb'
require_relative '../helpers/menu_train_route_manage_helper.rb'

# Train menu
class MenuTrain < MenuBase
  include MenuTrainNewHelper
  include MenuTrainRailcarManageHelper
  include MenuTrainRouteManageHelper

  def menu
    menu_show do
      list = []
      if @storage.trains.empty?
        menu_no_trains_show(list)
      else
        menu_trains_show(list)
      end
      list.push(key: 'N', name: 'Новый поезд', proc: :train_new_select_type)

      { header: 'Поезда', list: list }
    end
  end

  protected

  def menu_no_trains_show(list)
    list.push(name: 'нет ни одного поезда')
    list.push(name: MENU_DELIMITER)
  end

  def menu_trains_show(list)
    @storage.trains.each.with_index(1) do |train, index|
      list.push(key: index, name: 'поезд ' + train.name,
                proc: :train_control, data: train)
    end
    list.push(name: MENU_DELIMITER)
    list.push(name: 'Для просмотра и управления поездом укажите его номер')
  end

  def train_control(call_menu_item)
    train = call_menu_item[:data]
    menu_show do
      { header: train_control_menu_header(train),
        list: train_control_menu_list(train) }
    end
  end

  def train_control_menu_header(train)
    "Поезд #{train.name}\n"\
    "кол-во вагонов: #{train.railcars.count}\n"\
    "маршрут: #{train.route.nil? ? 'не указан' : train.route.name}\n"\
    'станция: ' +
      if train.current_station.nil?
        'не определена'
      else
        train.current_station.name
      end + "\n"
  end

  def train_control_menu_list(train)
    [{ key: 1, name: 'Управление маршрутом',
       proc: :train_route_manage, data: train },
     { key: 2, name: 'Управление вагонами',
       proc: :train_railcar_manage, data: train },
     { name: MENU_DELIMITER },
     { name: 'Укажите действие:' }]
  end
end
