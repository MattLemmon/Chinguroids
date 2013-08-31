require 'chingu'
include Gosu

require_relative 'rb/beginning.rb'
require_relative 'rb/levels.rb'
require_relative 'rb/objects.rb'
require_relative 'rb/gui.rb'
require_relative 'rb/ending.rb'

module Zorder
	GUI = 400
	Text = 300
	Main_Character = 200
	Main_Character_Particles = 199
	Object = 50
	Projectile = 15
	Particle = 5
end

module Colors
	Dark_Orange = Gosu::Color.new(0xFFCC3300)
	White = Gosu::Color.new(0xFFFFFFFF)
	Blue_Laser = Gosu::Color.new(0xFF86EFFF)
end


#
#  GameWindow Class
#
class GameWindow < Chingu::Window
  def initialize
    super(800,600,false)
    $intro = true
    $max_x = 815
    $max_y = 615
    $scr_edge = 15
    $cooling_down = 70
    $star_grab = Sound["media/audio/star_pickup.ogg"]
    $power_up = Sound["media/audio/power_up.ogg"]
    self.caption = "ChinguRoids"
    @cursor = true # comment out to hide cursor
    self.input = { :esc => :exit,
#                   :enter => :next,
#                   :return => :next,
                 [:q, :l] => :pop,
                 :z => :log,
                 :r => lambda{current_game_state.setup}
               }
    retrofy
  end

  def setup
    push_game_state(Beginning)
  end

  def log
    puts $window.current_game_state
  end

  def next
    push_game_state(Beginning)
  end

  def pop
    if $window.current_game_state.to_s == "Introduction" or $window.current_game_state.to_s == "Level_1" then
      pop_game_state(:setup => true)
    elsif $window.current_game_state.to_s != "OpeningCredits"
      pop_game_state(:setup => false)
    end
  end
end


GameWindow.new.show # change to Game.new.show to see alternate window class