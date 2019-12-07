# frozen_string_literal: true

# Module for mixing custom accessors
module Accessors
  def attr_accessor_with_history(*args)
    args.each do |name|
      name_history = "#{name}_history"
      var_name = "@#{name}"
      var_history = "@#{name_history}"

      define_attr_reader(name, var_name)
      define_attr_with_history_writer("#{name}=", var_name, var_history)
      define_attr_reader(name_history, var_history)
    end
  end

  def strong_attr_accessor(name, var_class)
    var_name = "@#{name}"
    define_attr_reader(name, var_name)
    define_attr_strong_writer("#{name}=", var_name, var_class)
  end

  protected

  def define_attr_reader(method_name, var_name)
    define_method(method_name) { instance_variable_get(var_name) }
  end

  def define_attr_with_history_writer(method_name, var_name, var_history)
    define_method(method_name) do |value|
      if value != instance_variable_get(var_name)
        instance_variable_set(var_name, value)
        unless instance_variable_defined?(var_history)
          instance_variable_set(var_history, [])
        end
        instance_variable_get(var_history) << value
      end
    end
  end

  def define_attr_strong_writer(method_name, var_name, var_class)
    define_method(method_name) do |value|
      unless value.is_a?(var_class)
        raise ArgumentError, "Assigning value must be of #{var_class} type"
      end

      instance_variable_set(var_name, value)
    end
  end
end
