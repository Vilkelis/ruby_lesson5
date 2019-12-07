# frozen_string_literal: true

require_relative '../tools/app_exception.rb'
# Module for mixing custom validation
module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  # Instance methods
  module InstanceMethods
    def valid?
      validate!
      true
    rescue AppException::AppError
      false
    end

    def validate!
      validations = methods.select { |name| /^validation_of_.+_/ =~ name.to_s }
      validations.each do |validation_method|
        send(validation_method)
      end
    end

    protected

    def register_instance
      self.class.send :register_instance
    end

    def validate_presence(name, var_name)
      value = instance_variable_get(var_name)
      return unless value.to_s.strip.empty?

      raise AppException::AttrValidationError, "#{name} is empty"
    end

    def validate_format(name, var_name, format)
      return if format =~ instance_variable_get(var_name)

      raise AppException::AttrValidationError, "#{name} has invalid format"
    end

    def validate_type(name, var_name, var_class)
      return if instance_variable_get(var_name).is_a?(var_class)

      raise AppException::AttrValidationError, "#{name} has invalid type"
    end
  end

  # Class methods
  module ClassMethods
    protected

    # Defines a validation condition for instance attribute
    # Instance method validate! will validate attributes by those rules
    # name - instance attribute name
    # type can be of
    # :presence -- validates that attribute not empty
    # :format  -- validates attribute according format
    #             (regexp in third parameter param)
    # :type -- validates attribute class (param)
    def validate(name, type, param = nil)
      method_name = "validation_of_#{name}_#{type}"
      var_name = "@#{name}"
      case type
      when :presence
        define_method(method_name) { validate_presence(name, var_name) }
      when :format
        define_method(method_name) { validate_format(name, var_name, param) }
      when :type
        define_method(method_name) { validate_type(name, var_name, param) }
      end
    end
  end
end
