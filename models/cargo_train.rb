require_relative 'train.rb'
require_relative 'cargo_railcar.rb'
# Cargo train
class CargoTrain < Train
  def include_railcar(railcar)
    unless railcar.is_a?(CargoRailcar)
      raise 'К грузовому поезду можно прицеплять только грузовые вагоны'
    end

    super railcar
  end

  def self.type
    'грузовой'
  end
end
