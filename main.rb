require 'Chingu'

class Game < Chingu::Window
	attr_reader :WIDTH, :HEIGHT

	def initialize
		@WIDTH, @HEIGHT = 800, 600
		super(800, 600, false)

		self.input = { :escape => :exit}

		push_game_state(Play)
	end
end

class Player < Chingu::GameObject
	def move_left; @x -= 5; end
	def move_right; @x += 5; end
	def move_up; @y -= 5; end
	def move_down; @y += 3; end

	def fire
		Bullet.create(:x => @x, :y => @y)
	end
end

class Bullet < Chingu::GameObject
	def initialize(options)
		super(options.merge(:image => Gosu::Image["assets/player/laser.png"]))
	end
	def update
		@y -= 2
	end
end

class Play < Chingu::GameState
	def initialize
		super 
		# OBJECTS
		@player = Player.create(:x => 400, :y => 300, :image => Gosu::Image["assets/player/player.png"])
		@player.input = {:holding_left => :move_left, :holding_right => :move_right, :holding_up => :move_up, :holding_down => :move_down, :space => :fire}
	end

	def debug
		push_game_state(Chingu::GameStates::Debug.new)
	end

	def draw
		Gosu::Image["assets/window/background.png"].draw(0, 0, 0)
	end

	def update
		super
		Bullet.destroy_if {|bullet| bullet.outside_window?}
		$window.caption = "ChinguRoids 0.01 FPS: #{$window.fps}"
	end
end

Game.new.show