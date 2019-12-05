# frozen_string_literal: true

require_relative '../helpers/manufactor_helper.rb'
require_relative '../helpers/validate_helper.rb'
# Railcar base class
class Railcar
  include ManufactorHelper
  include ValidateHelper

  attr_reader :reg_number, :train
  attr_writer :train

  @@railcar_count = 0

  def initialize
    validate!
    @@railcar_count += 1
    @reg_number = @@railcar_count
  end

  def name
    "#{type} вагон рег.номер #{@reg_number}"
  end

  def type
    self.class.type
  end

  def self.type
    'универсальный'
  end

  def workload_info
    ''
  end
end
