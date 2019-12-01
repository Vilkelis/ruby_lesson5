require_relative 'menu_base.rb'
require_relative '../models/cargo_train.rb'
require_relative '../models/passanger_train.rb'
require_relative '../tools/app_exception.rb'

# Train menu
class MenuTrain < MenuBase
  def menu
    menu_show do
      list = []
      if @storage.trains.empty?
        list.push(name: 'нет ни одного поезда')
        list.push(name: MENU_DELIMITER)
      else
        @storage.trains.each.with_index(1) do |train, index|
          list.push(key: index, name: 'поезд ' + train.name,
                    proc: :train_control, data: train)
        end
        list.push(name: MENU_DELIMITER)
        list.push(name: 'Для просмотра и управления поездом укажите его номер')
      end
      list.push(key: 'N', name: 'Новый поезд', proc: :train_new_select_type)

      { header: 'Поезда', list: list }
    end
  end

  protected

  def train_new_select_type(_call_menu_item)
    menu_show do
      { header: 'Выберите тип поезда',
        list: [{ key: 1, name: 'пассажирский',
                 proc: :train_new_end, data: PassangerTrain },
               { key: 2, name: 'грузовой',
                 proc: :train_new_end, data: CargoTrain },
               { name: MENU_DELIMITER },
               { name: 'Укажите номер типа поезда:' }] }
    end
  end

  def train_new_end(call_menu_item)
    loop do
      clear_console
      puts "Новый поезд: номер поезда #{MENU_EXIT_MESSAGE}"
      puts MENU_DELIMITER
      puts 'Укажите номер поезда: '
      train_number = gets.chomp.strip

      break if train_number.upcase == MENU_EXIT_KEY

      train_found = @storage.trains.find do |train|
        train.name.downcase == train_number.downcase
      end

      if !train_found
        begin
          @storage.trains << call_menu_item[:data].new(train_number)
          puts "Поезд \"#{@storage.trains[-1].name}\" создан."
          sleep_short
          break
        rescue AppException::AppError => e
          puts e.message
          sleep_long
        end
      else
        puts "Поезд \"#{train_number}\" уже существует."\
             ' Используйте другой номер поезда'
        sleep_long
      end
    end
    :quit_menu
  end

  def train_control(call_menu_item)
    train = call_menu_item[:data]
    menu_show do
      { header: "Поезд #{train.name}\n"\
       "кол-во вагонов: #{train.railcars.count}\n"\
       "маршрут: #{train.route.nil? ? 'не указан' : train.route.name}\n"\
       'станция: ' +
        if train.current_station.nil?
          'не определена'
        else
          train.current_station.name
        end + "\n",
        list: [{ key: 1, name: 'Управление маршрутом',
                 proc: :train_route_manage, data: train },
               { key: 2, name: 'Управление вагонами',
                 proc: :train_railcar_manage, data: train },
               { name: MENU_DELIMITER },
               { name: 'Укажите действие:' }] }
    end
  end

  def train_railcar_manage(call_menu_item)
    train = call_menu_item[:data]
    menu_show do
      list = []
      if train.railcars.empty?
        list.push(name: 'нет ни одного вагона у поезда')
        list.push(name: MENU_DELIMITER)
      else
        train.railcars.each.with_index(1) do |railcar, index|
          list.push(key: index,
                    name: railcar.name,
                    proc: :train_railcar_exclude,
                    data_train: train,
                    data_railcar: railcar)
        end
        list.push(name: MENU_DELIMITER)
        list.push(name: 'Чтобы отцепить вагон от поезда укажите его номер')
      end
      list.push(key: 'N',
                name: 'Прицепить вагон',
                proc: :train_railcar_include,
                data: train)

      { header: "Вагоны поезда #{train.name}", list: list }
    end
  end

  def train_railcar_exclude(call_menu_item)
    train = call_menu_item[:data_train]
    railcar = call_menu_item[:data_railcar]
    train.exclude_railcar(railcar)
    puts "#{railcar.name} отцеплен от поезда #{train.name}"
    sleep_short
  end

  def train_railcar_include(call_menu_item)
    train = call_menu_item[:data]
    available_railcars = @storage.railcars.select do |railcar|
      railcar.train.nil?
    end
    if available_railcars.empty?
      push 'Нет ни одного свободного вагона'
      sleep_long
    else
      menu_show do
        list = []
        available_railcars.each.with_index(1) do |railcar, index|
          list.push(key: index,
                    name: railcar.name,
                    proc: :train_railcar_include_end,
                    data_train: train,
                    data_railcar: railcar)
        end
        list.push(name: MENU_DELIMITER)
        list.push(name: 'Укажите номер вагона, чтобы прицепить его к поезду')

        { header: 'Свободные вагоны', list: list }
      end
    end
  end

  def train_railcar_include_end(call_menu_item)
    train = call_menu_item[:data_train]
    railcar = call_menu_item[:data_railcar]
    begin
      train.include_railcar(railcar)
      puts "#{railcar.name} прицеплен к поезду #{train.name}"
      sleep_short
      :quit_menu
    rescue AppException::AppError => e
      puts e.message
      sleep_long
    end
  end

  def train_route_manage(call_menu_item)
    train = call_menu_item[:data]
    menu_show do
      { header: "Поезд #{train.name}\n"\
       "маршрут: #{train.route.nil? ? 'не указан' : train.route.name}\n"\
       'станция: ' +
        if train.current_station.nil?
          'не определена'
        else
          train.current_station.name
        end + "\n",
        list: [{ key: 1, name: 'Сменить маршрут',
                 proc: :train_route_change, data: train },
               { key: 2, name: 'Переместить по маршруту вперед',
                 proc: :train_route_go_forward, data: train },
               { key: 3, name: 'Переместить по маршруту назад',
                 proc: :train_route_go_backward, data: train },
               { name: MENU_DELIMITER },
               { name: 'Укажите действие:' }] }
    end
  end

  def train_route_change(call_menu_item)
    train = call_menu_item[:data]

    if @storage.routes.empty?
      puts 'Не определено ни одного маршрута.'
    else
      menu_show do
        list = []
        @storage.routes.each.with_index(1) do |route, index|
          list.push(key: index, name: route.name,
                    proc: :train_route_change_end,
                    data_train: train, data_route: route)
        end
        list.push(name: MENU_DELIMITER)
        list.push(name: 'Укажите номер маршрута:')

        { header: "Выберите маршрут для поезда #{train.name}", list: list }
      end
    end
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
