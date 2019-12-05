require_relative '../helpers/menu_constant_helper.rb'
# Helper for MenuTrain class
module MenuTrainNewHelper
  include MenuConstantHelper

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
      train_new_end_show_header

      train_number = gets.chomp.strip

      break if train_number.upcase == MENU_EXIT_KEY
      break if train_new_created?(train_number, call_menu_item[:data])
    end
    :quit_menu
  end

  def train_by_number(train_number)
    @storage.trains.find do |train|
      train.name.downcase == train_number.downcase
    end
  end

  def train_new_created?(train_number, train_class)
    if !train_by_number(train_number)
      train_create_do(train_number, train_class)
    else
      puts "Поезд \"#{train_number}\" уже существует."\
           ' Используйте другой номер поезда'
      sleep_long
    end
  end

  def train_create_do(train_number, train_class)
    @storage.trains << train_class.new(train_number)
    puts "Поезд \"#{@storage.trains[-1].name}\" создан."
    sleep_short
    true
  rescue AppException::AppError => e
    puts e.message
    sleep_long
    false
  end

  def train_new_end_show_header
    puts "Новый поезд: номер поезда #{MENU_EXIT_MESSAGE}"
    puts MENU_DELIMITER
    puts 'Укажите номер поезда (формат XXX-XX): '
  end

  def route_new_first_station(_call_menu_item)
    if @storage.stations.count < 2
      puts 'Для создания маршрута необходимо наличие минимум 2-х станций'
      sleep_long
    else
      route_new_first_station_menu_show
    end
  end
end
