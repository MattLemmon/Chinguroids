class GUI < Chingu::GameObject
	def initialize(player)
		super()
		@gui_player = player
		@heart_full = Gosu::Image.new($window, "assets/icons/heart.png")
		@heart_half = Gosu::Image.new($window, "assets/icons/heart_half.png")
		@heart_empty = Gosu::Image.new($window, "assets/icons/heart_empty.png")

		@health_bar = Array.new(2)

		@score_text = Chingu::Text.create("Score: #{$score}", :y => 0, :font => "GeosansLight", :size => 20, :color => Colors::White, :zorder => Zorder::GUI)
		@score_text.x = $window.WIDTH/2 - @score_text.width/2
	end

	def update
		super
		@score_text.text = "Score: #{$score}"
	end

	def draw
		super
		for i in 0..@health_bar.size
			if(@gui_player.health <= i)
				@heart_empty.draw(16*i, 0, Zorder::GUI)
			elsif(@gui_player.health == i+0.5)
				@heart_half.draw(16*i, 0, Zorder::GUI)
			elsif(@gui_player.health >= i)
				@heart_full.draw(16*i, 0, Zorder::GUI)
			end
		end
	end
end
