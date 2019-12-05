require_relative '../helpers/menu_constant_helper.rb'
# Helper for MenuRailcar class
module MenuRailcarNewHelper
  include MenuConstantHelper

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
      railcar_new_passanger_show_header

      seats_count = gets.chomp.strip

      break if seats_count.upcase == MENU_EXIT_KEY

      seats_count = seats_count.to_i

      break if railcar_create(call_menu_item[:data], seats_count)
    end
    :quit_menu
  end

  def railcar_new_passanger_show_header
    puts "Кол-во мест в пассажирском вагоне #{MENU_EXIT_MESSAGE}"
    puts MENU_DELIMITER
    puts 'Укажите количество мест в вагоне: '
  end

  def railcar_new_cargo(call_menu_item)
    loop do
      clear_console
      railcar_new_cargo_show_header

      volume = gets.chomp.strip

      break if volume.upcase == MENU_EXIT_KEY

      volume = volume.to_f

      break if railcar_create(call_menu_item[:data], volume)
    end
    :quit_menu
  end

  def railcar_new_cargo_show_header
    puts "Объем грузового вагона #{MENU_EXIT_MESSAGE}"
    puts MENU_DELIMITER
    puts 'Укажите объем грузового вагона (м2): '
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
end
