require_relative '../helpers/menu_constant_helper.rb'
# Helper for MenuRailcar class
module MenuRailcarInfoHelper
  include MenuConstantHelper

  protected

  def railcar_info(call_menu_item)
    menu_show do
      railcar = call_menu_item[:data]
      train = railcar.train
      list = []
      list.push(name: railcar.name)
      railcar_info_fill_list_for_train(train, list)
      railcar_info_fill_list_for_railcar(railcar, list)

      list.push(name: MENU_EXIT_MESSAGE)

      { header: 'Информация по вагону', list: list }
    end
  end

  def railcar_info_fill_list_for_train(train, list)
    if train.nil?
      list.push(name: 'не прицеплен к поезду')
    else
      list.push(name: 'прицеплен к поезду: ' + train.name)

      railcar_info_fill_list_for_train_info(train, list)

    end
  end

  def railcar_info_fill_list_for_train_info(train, list)
    route = train.route
    text = route.nil? ? 'маршрут не указан' : route.name
    list.push(name: 'следует по маршруту: ' + text)

    station = train.current_station
    text = station.nil? ? 'станция не определена' : station.name
    list.push(name: 'находится на станции: ' + text)
  end

  def railcar_info_fill_list_for_railcar(railcar, list)
    list.push(name: "информация по загрузке: #{railcar.workload_info}")
    list.push(name: MENU_DELIMITER)

    if railcar.is_a?(PassangerRailcar)
      list.push(key: 1, name: 'Занять место',
                proc: :take_one_seat, data: railcar)
    else
      list.push(key: 1, name: 'Загрузить груз',
                proc: :take_volume, data: railcar)
    end
  end

  def take_one_seat(call_menu_item)
    railcar = call_menu_item[:data]
    begin
      railcar.take_one_seat
      puts 'Одно место занято'
      sleep_short
    rescue AppException::AppError => e
      puts e.message
      sleep_long
    end
  end

  def take_volume(call_menu_item)
    railcar = call_menu_item[:data]
    loop do
      clear_console
      take_volume_show_header(railcar)

      volume = gets.chomp.strip

      break if volume.upcase == MENU_EXIT_KEY
      break if volume_entered?(railcar, volume)
    end
  end

  def volume_entered?(railcar, volume)
    volume = volume.to_f
    begin
      railcar.take_volume(volume)
      puts 'Вагон загружен'
      true
    rescue AppException::AppError => e
      puts e.message
      sleep_long
      false
    end
  end

  def take_volume_show_header(railcar)
    puts "Загрузка вагона #{MENU_EXIT_MESSAGE}"
    puts railcar.workload_info
    puts MENU_DELIMITER
    puts 'Укажите объем груза (м2): '
  end
end
