require_relative 'menu_base.rb'
require_relative '../models/passanger_railcar.rb'
require_relative '../models/cargo_railcar.rb'
require_relative '../tools/app_exception.rb'
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
        list.push(name: "Для просмотра информации по вагону\n"\
                        'и изменения загрузки вагона укажите его номер')
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
                 proc: :railcar_new_passanger, data: PassangerRailcar },
               { key: 2, name: 'грузовой',
                 proc: :railcar_new_cargo, data: CargoRailcar },
               { name: MENU_DELIMITER },
               { name: 'Укажите номер типа вагона:' }] }
    end
  end

  def railcar_new_passanger(call_menu_item)
    loop do
      clear_console
      puts "Кол-во мест в пассажирском вагоне #{MENU_EXIT_MESSAGE}"
      puts MENU_DELIMITER
      puts 'Укажите количество мест в вагоне: '
      seats_count = gets.chomp.strip

      break if seats_count.upcase == MENU_EXIT_KEY

      seats_count = seats_count.to_i

      break if railcar_create(call_menu_item[:data], seats_count)
    end
    :quit_menu
  end

  def railcar_new_cargo(call_menu_item)
    loop do
      clear_console
      puts "Объем грузового вагона #{MENU_EXIT_MESSAGE}"
      puts MENU_DELIMITER
      puts 'Укажите объем грузового вагона (м2): '
      volume = gets.chomp.strip

      break if volume.upcase == MENU_EXIT_KEY

      volume = volume.to_f

      break if railcar_create(call_menu_item[:data], volume)
    end
    :quit_menu
  end

  def railcar_create(railcar_class, new_param)
    @storage.railcars << railcar_class.new(new_param)
    puts "Вагон #{@storage.railcars[-1].name} создан."
    sleep_short
    true
  rescue AppException::AppError => e
    puts e.message
    sleep_long
    false
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
      list.push(name: "информация по загрузке: #{railcar.workload_info}")
      list.push(name: MENU_DELIMITER)
      if railcar.is_a?(PassangerRailcar)
        list.push(key: 1, name: 'Занять место',
                  proc: :take_one_seat, data: railcar)
      else
        list.push(key: 1, name: 'Загрузить груз',
                  proc: :take_volume, data: railcar)
      end

      list.push(name: MENU_EXIT_MESSAGE)

      { header: 'Информация по вагону', list: list }
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
      puts "Загрузка вагона #{MENU_EXIT_MESSAGE}"
      puts railcar.workload_info
      puts MENU_DELIMITER
      puts 'Укажите объем груза (м2): '
      volume = gets.chomp.strip

      break if volume.upcase == MENU_EXIT_KEY

      volume = volume.to_f
      begin
        railcar.take_volume(volume)
        puts 'Вагон загружен'
        break
      rescue AppException::AppError => e
        puts e.message
        sleep_long
        false
      end
    end
  end
end
