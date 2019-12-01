require_relative 'train.rb'
require_relative 'passanger_railcar.rb'
# Passanger train class
class PassangerTrain < Train
  def include_railcar(railcar)
    unless railcar.is_a?(PassangerRailcar)
      raise AppException::TrainRailCarTypeError,
            'К пассажирскому поезду можно прицеплять только пассажирские вагоны'
    end

    super railcar
  end

  def self.type
    'пассажирский'
  end

  protected

  def power
    2
  end
end
