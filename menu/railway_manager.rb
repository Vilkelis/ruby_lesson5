# frozen_string_literal: true

require_relative 'menu_main.rb'
# Railway manager class
class RailwayManager
  attr_reader :stations, :trains, :railcars, :routes

  def initialize
    @stations = []
    @trains = []
    @railcars = []
    @routes = []
  end

  def menu
    MenuMain.new(self).menu
  end
end
