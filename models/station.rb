# Station class
class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
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
