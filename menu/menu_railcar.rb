# frozen_string_literal: true

require_relative 'menu_base.rb'
require_relative '../models/passanger_railcar.rb'
require_relative '../models/cargo_railcar.rb'
require_relative '../tools/app_exception.rb'
require_relative '../helpers/menu_railcar_new_helper.rb'
require_relative '../helpers/menu_railcar_info_helper.rb'
# Railcar menu
class MenuRailcar < MenuBase
  include MenuRailcarNewHelper
  include MenuRailcarInfoHelper

  def menu
    menu_show do
      list = []
      menu_railcars_show(list)

      list.push(key: 'N', name: 'Новый вагон', proc: :railcar_new)
      { header: 'Вагоны', list: list }
    end
  end

  protected

  def menu_railcars_show(list)
    if @storage.railcars.empty?
      menu_railcars_no_railcars_show(list)
    else
      menu_railcars_railcars_show(list)
      menu_railcar_railcars_show_end(list)
    end
  end

  def menu_railcars_no_railcars_show(list)
    list.push(name: 'нет ни одного вагона')
    list.push(name: MENU_DELIMITER)
  end

  def menu_railcars_railcars_show(list)
    @storage.railcars.each.with_index(1) do |railcar, index|
      text = unless railcar.train.nil?
               ' - прицеплен к поезду ' + railcar.train.name
             end
      list.push(key: index,
                name: railcar.name + text.to_s,
                proc: :railcar_info, data: railcar)
    end
  end

  def menu_railcar_railcars_show_end(list)
    list.push(name: MENU_DELIMITER)
    list.push(name: "Для просмотра информации по вагону\n"\
                    'и изменения загрузки вагона укажите его номер')
  end
end
