# frozen_string_literal: true

require_relative '../helpers/manufactor_helper.rb'
require_relative '../helpers/instance_counter.rb'
require_relative '../helpers/validate_helper.rb'
# Train class
class Train
  include ManufactorHelper
  include InstanceCounter
  include ValidateHelper

  NUMBER_FORMAT = /^[0-9a-zа-я]{3}[-]*[0-9a-zа-я]{2}$/i.freeze

  attr_reader :number, :railcars, :route, :speed

  @@trains = {}

  def initialize(number)
    @number = number
    @railcars = []
    @speed = 0
    validate!
    register_instance
    @@trains[@number.to_s.downcase] = self
  end

  def self.find(train_number)
    @@trains[train_number.to_s.downcase]
  end

  def name
    "#{type} № #{number}"
  end

  def increase_speed
    @speed += power
  end

  def decrease_speed
    @speed -= power
    @speed = 0 if @speed.negative?
  end

  def include_railcar(railcar)
    unless speed.zero?
      raise AppException::TrainSpeedNotZeroError, 'Необходимо остановить поезд'\
            ' перед включением в него вагона.'
    end
    @railcars << railcar unless @railcars.include?(railcar)
    railcar.train = self
  end

  def exclude_railcar(railcar)
    unless speed.zero?
      raise AppException::TrainSpeedNotZeroError, 'Необходимо остановить поезд'\
            ' перед исключением из него вагона.'
    end
    @railcars.delete(railcar)
    railcar.train = nil
  end

  def route=(route)
    @route = route
    self.current_station_index = 0
  end

  def go_forward
    self.current_station_index += 1
  end

  def go_backward
    self.current_station_index -= 1
  end

  def current_station
    route.stations[current_station_index] unless current_station_index.nil?
  end

  def next_station
    route.stations[current_station_index + 1] unless current_station_index.nil?
  end

  def prev_station
    route.stations[current_station_index - 1] if current_station_index.positive?
  end

  def type
    self.class.type
  end

  def self.type
    'универсальный'
  end

  def each_railcar(&block)
    @railcars.each.with_index(1, &block)
  end

  protected

  attr_reader :current_station_index

  def power
    1
  end

  def current_station_index=(index)
    if index != @current_station_index &&
       index >= 0 && index < route.stations.count
      current_station&.depart_train(self)

      @current_station_index = index

      current_station.take_train(self)
    end
  end

  def validate!
    raise AppException::TrainNumberFormatError unless NUMBER_FORMAT =~ number
  end
end
