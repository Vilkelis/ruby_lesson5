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
    def self.extended(base)
      base.instance_variable_set(:@instance_count, 0)
    end

    def inherited(base)
      base.instance_variable_set(:@instance_count, 0)
    end

    def instances
      @instance_count
    end

    protected

    def register_instance
      @instance_count += 1
    end
  end
end
