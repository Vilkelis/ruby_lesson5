# Counter methods for classes and instances
module InstanceCounter
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  # Instance methods
  module InstanceMethods
    protected

    def register_instance
      self.class.send :register_instance
    end
  end

  # Class methods
  module ClassMethods
    attr_reader :instances

    def self.extended(base)
      base.instance_variable_set(:@instances, 0)
    end

    def inherited(base)
      base.instance_variable_set(:@instances, 0)
    end

    protected

    def register_instance
      @instances += 1
    end
  end
end
