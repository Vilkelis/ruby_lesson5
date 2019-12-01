require_relative '../helpers/instance_counter.rb'
require_relative '../helpers/validate_helper.rb'
# Station class
class Station
  include InstanceCounter
  include ValidateHelper

  attr_reader :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
    @@stations << self
  end

  def take_train(train)
    @trains << train unless @trains.include?(train)
  end

  def depart_train(train)
    @trains.delete(train)
  end

  def trains(train_class = nil)
    if train_class.nil?
      @trains
    else
      @trains.select { |e| e.is_a?(train_class) }
    end
  end

  protected

  def validate!
    raise AppException::StationNameEmptyError if !name || name.to_s.strip.empty?
  end
end
