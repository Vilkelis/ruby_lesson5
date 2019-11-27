require_relative '../helpers/instance_counter.rb'
# Station class
class Station
  include InstanceCounter

  attr_reader :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    register_instance
    @name = name
    @trains = []
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
end
