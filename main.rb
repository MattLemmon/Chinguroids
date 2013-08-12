require 'chingu'

require_relative 'rb/objects.rb'
require_relative 'rb/gamestates.rb'

module Colors
	Dark_Orange = Gosu::Color.new(0xFFCC3300)
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

		game_states_next
	end

	def game_states_next
		for i in 0..@gamestates.size
			push_game_state(@gamestates[i])
		end
	end
end

Game.new.show