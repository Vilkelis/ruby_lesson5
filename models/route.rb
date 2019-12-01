require_relative '../helpers/instance_counter.rb'
require_relative '../helpers/validate_helper.rb'
# Train route class
class Route
  include InstanceCounter
  include ValidateHelper

  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
    register_instance
  end

  def include_station(station)
    @stations.insert(-2, station) unless @stations.include?(station)
  end

  def exclude_station(station)
    @stations.delete(station) unless [@stations[0],
                                      @stations[-1]].include?(station)
  end

  def name
    @stations.map { |station| station.name }.join(' -> ')
  end

  protected

  def validate!
    raise AppException::RouteFirstStationEmptyError if stations[0].nil?
    raise AppException::RouteLastStationEmptyError if stations[-1].nil?
    raise AppException::RouteStationEmptyError if stations.include?(nil)
  end
end
