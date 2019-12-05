# frozen_string_literal: true

require_relative '../helpers/menu_constant_helper.rb'
# Helper for MenuTrain class
module MenuTrainRouteManageHelper
  include MenuConstantHelper

  protected

  def train_route_manage(call_menu_item)
    train = call_menu_item[:data]
    menu_show do
      { header: train_route_manage_menu_header(train),
        list: train_route_manage_menu_list(train) }
    end
  end

  def train_route_manage_menu_list(train)
    [{ key: 1, name: 'Сменить маршрут',
       proc: :train_route_change, data: train },
     { key: 2, name: 'Переместить по маршруту вперед',
       proc: :train_route_go_forward, data: train },
     { key: 3, name: 'Переместить по маршруту назад',
       proc: :train_route_go_backward, data: train },
     { name: MENU_DELIMITER },
     { name: 'Укажите действие:' }]
  end

  def train_route_manage_menu_header(train)
    "Поезд #{train.name}\n"\
    "маршрут: #{train.route.nil? ? 'не указан' : train.route.name}\n"\
    'станция: ' +
      if train.current_station.nil?
        'не определена'
      else
        train.current_station.name
      end + "\n"
  end

  def train_route_change(call_menu_item)
    train = call_menu_item[:data]

    if @storage.routes.empty?
      train_route_no_routes_menu_show
    else
      menu_show do
        list = []
        train_route_change_menu_show(train, list)

        { header: "Выберите маршрут для поезда #{train.name}", list: list }
      end
    end
  end

  def train_route_no_routes_menu_show
    puts 'Не определено ни одного маршрута.'
    sleep_short
  end

  def train_route_change_menu_show(train, list)
    @storage.routes.each.with_index(1) do |route, index|
      list.push(key: index, name: route.name,
                proc: :train_route_change_end,
                data_train: train, data_route: route)
    end
    list.push(name: MENU_DELIMITER)
    list.push(name: 'Укажите номер маршрута:')
  end

  def train_route_change_end(call_menu_item)
    train = call_menu_item[:data_train]
    route = call_menu_item[:data_route]
    train.route = route
    puts "Для поезда #{train.name} установлен маршрут #{route.name}."
    sleep_short
    :quit_menu
  end

  def train_route_go_forward(call_menu_item)
    train = call_menu_item[:data]
    if train.route.nil?
      puts 'Поезду не назначен маршрут. Перемешение невозможно.'
      sleep_long
    else
      train.go_forward
    end
  end

  def train_route_go_backward(call_menu_item)
    train = call_menu_item[:data]
    if train.route.nil?
      puts 'Поезду не назначен маршрут. Перемешение невозможно.'
      sleep_long
    else
      train.go_backward
    end
  end
end
