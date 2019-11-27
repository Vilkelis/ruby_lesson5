require_relative '../helpers/instance_counter.rb'
# Train route class
class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(first_station, last_station)
    register_instance
    @stations = [first_station, last_station]
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
end
