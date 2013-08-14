require 'chingu'

require_relative 'rb/objects.rb'
require_relative 'rb/gamestates.rb'
require_relative 'rb/gui.rb'

module Zorder
	GUI = 400
	Text = 300
	Character = 200
	Object = 50
	Projectile = 1
end

module Colors
	Dark_Orange = Gosu::Color.new(0xFFCC3300)
	White = Gosu::Color.new(0xFFFFFFFF)
end

class Game < Chingu::Window
	attr_reader :WIDTH, :HEIGHT, :NAME

	def initialize
		# Window START
		@WIDTH, @HEIGHT, @NAME = 800, 600, "ChinguRoids 0.01 - Fractional"
		super(800, 600, false)
		self.caption = @NAME
		# Window END

		self.input = { :escape => :exit}

		@gamestates = [Play, Introduction]

		game_state_next
	end

	def game_state_next
		for i in 0..@gamestates.size
			push_game_state(@gamestates[i])
		end
	end
end

Game.new.show