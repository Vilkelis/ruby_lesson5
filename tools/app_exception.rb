# frozen_string_literal: true

# Exceptions for Railway Application
module AppException
  # Base class for all application errors
  class AppError < RuntimeError; end

  # Station name is empty
  class StationNameEmptyError < AppError
    def initialize(msg = 'Не указано наименование станции.')
      super
    end
  end

  # Train not zero speed error
  class TrainSpeedNotZeroError < AppError
    def initialize(msg = 'Для выполнение действия'\
                         ' скорость поезда должна быть равна нулю.')
      super
    end
  end

  # Invalid train number format
  class TrainNumberFormatError < AppError
    def initialize(msg = 'Не правильный формат номера поезда.')
      super
    end
  end

  # Invalid railcar type for train
  class TrainRailCarTypeError < AppError
    def initialize(msg = 'Вагон такого типа нельзя прицеплять к этому поезду.')
      super
    end
  end

  # Route error: first station is empty
  class RouteFirstStationEmptyError < AppError
    def initialize(msg = 'Станция начала маршрута не может быть пустой.')
      super
    end
  end

  # Route error: last station is empty
  class RouteLastStationEmptyError < AppError
    def initialize(msg = 'Станция конца маршрута не может быть пустой.')
      super
    end
  end

  # Route error: there are nil stations
  class RouteStationEmptyError < AppError
    def initialize(msg = 'Не все станции маршрута определены.')
      super
    end
  end

  # Passanger railcar error: no free seats
  class RailcarNoFreeSeatsError < AppError
    def initialize(msg = 'В вагоне нет свободных мест.')
      super
    end
  end

  # Cargo railcar error: no free volume
  class RailcarNoFreeVolumeError < AppError
    def initialize(msg = 'В вагоне недостаточно свободного объема.')
      super
    end
  end

  # No seats sets to passanger railcar
  class RailcarNoSeatsError < AppError
    def initialize(msg = 'Количество пассажирских мест'\
                         ' в вагоне должно быть больше нуля.')
      super
    end
  end

  # No volume sets to cargo railcar
  class RailcarNoVolumeError < AppError
    def initialize(msg = 'Объем грузового вагона'\
                         ' должен быть больше нуля.')
      super
    end
  end
end
