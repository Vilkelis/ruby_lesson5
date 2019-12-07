# frozen_string_literal: true

require_relative './tools/app_exception.rb'
require_relative './helpers/accessors.rb'
require_relative './helpers/validation.rb'
require_relative './models/train.rb'

puts '=>Проверка validation в классе Train'
puts 'Проверка Presence validation'
begin
  Train.new(nil)
  puts 'Поезд создан'
rescue AppException::AppError => e
  puts 'Ошибка создания поезда Train.new(nil): ' + e.message
end

begin
  Train.new('')
  puts 'Поезд создан'
rescue AppException::AppError => e
  puts "Ошибка создания поезда Train.new(''): " + e.message
end

puts 'Проверка Type validation'
begin
  Train.new(123)
  puts 'Поезд создан'
rescue AppException::AppError => e
  puts 'Ошибка создания поезда Train.new(123): ' + e.message
end

puts 'Проверка Format validation'
begin
  Train.new('DDDD-1112')
  puts 'Поезд создан'
rescue AppException::AppError => e
  puts "Ошибка создания поезда Train.new('DDDD-1112'): " + e.message
end

puts 'Проверка создания поезда без ошибки '
begin
  Train.new('DDD-11')
  puts 'Поезд создан'
rescue AppException::AppError => e
  puts "Ошибка создания поезда Train.new('DDD-11'): " + e.message
end

puts
puts '=>Проверка validation при наследованиии'

# Base class for test
class A
  include Validation

  validate :name, :presence
  validate :name, :type, String
  validate :name, :format, /^[0-9]+$/

  attr_accessor :name
end

# Test class
class B < A
  validate :forma, :presence

  attr_accessor :forma
end

b = B.new
b.name = 10
b.forma = 'test forma'
puts b.valid? ? 'b is valid' : 'b is invalid'
begin
  b.validate!
  puts 'validate successfully'
rescue AppException::AppError => e
  puts 'Ошибка валидации: ' + e.message
end

b.name = '10'
b.forma = nil
puts b.valid? ? 'b is valid' : 'b is invalid'
begin
  b.validate!
  puts 'проверка прошла успешно'
rescue AppException::AppError => e
  puts 'Ошибка валидации: ' + e.message
end

b.name = '10'
b.forma = 'test_forma'
puts b.valid? ? 'b is valid' : 'b is invalid'
begin
  b.validate!
  puts 'проверка прошла успешно'
rescue AppException::AppError => e
  puts 'Ошибка валидации: ' + e.message
end

puts
puts '=>Проверка accessors'
# Accessors test class
class AccessorsTest
  extend Accessors

  attr_accessor_with_history :h, :g
  strong_attr_accessor :strong, Array
end

puts 'история b.h'
b = AccessorsTest.new
b.h = 1
b.h = 10
b.h = 12
puts b.h_history.to_s

puts 'история b.g'
b.g = 100
b.g = 101
b.g = 102
puts b.g_history.to_s

puts 'тест атрибута b.strong'
begin
  b.strong = 10
  puts "Присвоение числа прошло успешно, b.strong = #{b.strong}"
rescue ArgumentError => e
  puts 'Ошибка b.strong = 10 : ' + e.message
end

begin
  b.strong = [10, 11, 12]
  puts "Присвоение массива прошло успешно, b.strong = #{b.strong}"
rescue ArgumentError => e
  puts 'Ошибка b.strong = [10, 11, 12] : ' + e.message
end
