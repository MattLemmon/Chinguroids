require 'chingu'
include Gosu

require_relative 'rb/welcome.rb'
require_relative 'rb/pause.rb'
require_relative 'rb/gamestates.rb'
require_relative 'rb/objects.rb'
require_relative 'rb/gui.rb'

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
#
#  GameWindow Class
#
class GameWindow < Chingu::Window
  def initialize
  @NAME = "ChinguRoids 0.01 - Fractional"
  $max_x = 815
  $max_y = 615
  $scr_edge = 15
  $cooling_down = 70

    super(800,600,false)
    self.caption = @NAME
    @cursor = true # comment out to hide cursor
    self.input = { :esc => :exit,
                   :enter => :next,
                   :return => :next,
                   [:q, :l] => :pop,
                   :z => :log,
                   :r => lambda{current_game_state.setup}
                 }
    @nextgame = [ Level_1, Level_2, Level_3, Welcome ]
    @w = true
    @ng = -1
  end

  def setup
    retrofy
    push_game_state(Introduction)
  end

  def log
    puts $window.current_game_state
  end

  def next
    if @ng == 3
      @ng = 0
    else
        @ng += 1
    end
    push_game_state(@nextgame[@ng])
  end

  def pop
    if $window.current_game_state.to_s != "Pause" && $window.current_game_state.to_s != "GameOver" then
      if @ng == 0
        @ng = 13
      else
        @ng -= 1
      end
    end
    if $window.current_game_state.to_s != "Introduction" then
      pop_game_state(:setup => false)
    end
    if $window.current_game_state.to_s == "Introduction" then
      @ng = -1
    end
  end
end

#
#  Alternate Window Class (make small change below to activate)
#
class Game < Chingu::Window
	attr_reader :WIDTH, :HEIGHT, :NAME

	def initialize
		@WIDTH, @HEIGHT, @NAME = 800, 600, "ChinguRoids 0.01 - Fractional"
		super(800, 600, false)
		self.caption = @NAME
		self.input = { :escape => :exit}

		@gamestates = [Level_1, Introduction]
		game_state_next
	end

	def game_state_next
		for i in 0..@gamestates.size
			push_game_state(@gamestates[i])
		end
	end
end


GameWindow.new.show # change to Game.new.show to see alternate window class