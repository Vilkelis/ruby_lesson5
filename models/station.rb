# frozen_string_literal: true

require_relative '../helpers/instance_counter.rb'
require_relative '../helpers/validation.rb'
# Station class
class Station
  include InstanceCounter
  include Validation

  attr_reader :name

  validate :name, :presence
  validate :name, :type, String

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

  def each_train(&block)
    @trains.each.with_index(1, &block)
  end
end
