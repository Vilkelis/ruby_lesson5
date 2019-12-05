# frozen_string_literal: true

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
    def instances
      @instances ||= 0
    end

    protected

    def register_instance
      instances
      @instances += 1
    end
  end
end
