require_relative 'railcar.rb'
require_relative '../tools/app_exception.rb'
# Cargo railcar
class CargoRailcar < Railcar
  attr_reader :volume, :volume_taken

  def initialize(volume)
    @volume = volume.to_f.round(2)
    @volume_taken = 0
    super()
  end

  def volume_free
    @volume - @volume_taken
  end

  def take_volume(volume_to_take)
    unless @volume_taken + volume_to_take.to_f.round(2) < @volume
      raise AppException::RailcarNoFreeVolumeError
    end

    @volume_taken += volume_to_take.to_f.round(2)
  end

  def self.type
    'грузовой'
  end

  def workload_info
    "занято #{volume_taken.round(2)} м2, свободно #{volume_free.round(2)} м2"
  end

  protected

  def validate!
    raise AppException::RailcarNoVolumeError unless @volume > 0

    super
  end
end
