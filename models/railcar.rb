# Railcar base class
class Railcar
  attr_reader :reg_number, :train
  attr_writer :train

  @@railcar_count = 0

  def initialize
    @@railcar_count += 1
    @reg_number = @@railcar_count
    @train = nil
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
end
