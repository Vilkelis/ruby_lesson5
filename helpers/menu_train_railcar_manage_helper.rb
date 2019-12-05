require_relative '../helpers/menu_constant_helper.rb'
# Helper for MenuTrain class
module MenuTrainRailcarManageHelper
  include MenuConstantHelper

  protected

  def train_railcar_manage(call_menu_item)
    train = call_menu_item[:data]
    menu_show do
      list = []
      train_railcar_manage_menu_show(train, list)
      { header: "Вагоны поезда #{train.name}", list: list }
    end
  end

  def train_railcar_manage_menu_show(train, list)
    if train.railcars.empty?
      train_railcar_manage_no_railcars_show(list)
    else
      train_railcar_manage_railcars_show(train, list)
    end
    train_railcar_manage_menu_action_show(train, list)
  end

  def train_railcar_manage_menu_action_show(train, list)
    list.push(key: 'N',
              name: 'Прицепить вагон',
              proc: :train_railcar_include,
              data: train)
  end

  def train_railcar_manage_railcars_show(train, list)
    train.each_railcar do |railcar, index|
      list.push(key: index,
                name: "#{railcar.name} (#{railcar.workload_info})",
                proc: :train_railcar_exclude,
                data_train: train,
                data_railcar: railcar)
    end
    list.push(name: MENU_DELIMITER)
    list.push(name: 'Чтобы отцепить вагон от поезда укажите его номер')
  end

  def train_railcar_manage_no_railcars_show(list)
    list.push(name: 'нет ни одного вагона у поезда')
    list.push(name: MENU_DELIMITER)
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
      puts 'Нет ни одного свободного вагона'
      sleep_long
    else
      train_railcar_include_menu(train, available_railcars)
    end
  end

  def train_railcar_include_menu(train, available_railcars)
    menu_show do
      list = []
      train_railcar_include_menu_show(train, available_railcars, list)

      { header: 'Свободные вагоны', list: list }
    end
  end

  def train_railcar_include_menu_show(train, available_railcars, list)
    available_railcars.each.with_index(1) do |railcar, index|
      list.push(key: index,
                name: railcar.name,
                proc: :train_railcar_include_end,
                data_train: train,
                data_railcar: railcar)
    end
    list.push(name: MENU_DELIMITER)
    list.push(name: 'Укажите номер вагона, чтобы прицепить его к поезду')
  end

  def train_railcar_include_end(call_menu_item)
    train = call_menu_item[:data_train]
    railcar = call_menu_item[:data_railcar]
    begin
      train_railcar_include_end_do(train, railcar)
      :quit_menu
    rescue AppException::AppError => e
      puts e.message
      sleep_long
    end
  end

  def train_railcar_include_end_do(train, railcar)
    train.include_railcar(railcar)
    puts "#{railcar.name} прицеплен к поезду #{train.name}"
    sleep_short
  end
end
