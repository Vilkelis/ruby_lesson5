# frozen_string_literal: true

require_relative 'railcar.rb'
require_relative '../tools/app_exception.rb'
# Passanger railcar
class PassangerRailcar < Railcar
  attr_reader :seats_count, :seats_taken_count

  def initialize(seats_count)
    @seats_count = seats_count
    @seats_taken_count = 0
    super()
  end

  def seats_free_count
    @seats_count - @seats_taken_count
  end

  def take_one_seat
    unless @seats_taken_count < @seats_count
      raise AppException::RailcarNoFreeSeatsError
    end

    @seats_taken_count += 1
  end

  def self.type
    'пассажирский'
  end

  def workload_info
    "занято #{seats_taken_count} мест, свободно #{seats_free_count} мест"
  end

  protected

  def validate!
    raise AppException::RailcarNoSeatsError unless @seats_count.positive?

    super
  end
end
