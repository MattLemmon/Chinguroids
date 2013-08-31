class GUI < Chingu::GameObject
	def initialize(player)
		super()
		@gui_player = player
		@heart_full = Gosu::Image.new($window, "media/assets/heart.png")
		@heart_half = Gosu::Image.new($window, "media/assets/heart_half.png")
		@heart_empty = Gosu::Image.new($window, "media/assets/heart_empty.png")
		@star_full = Gosu::Image.new($window, "media/assets/star_full.png")
#		@star_half = Gosu::Image.new($window, "media/assets/star_half.png")
		@star_empty = Gosu::Image.new($window, "media/assets/star_empty.png")

#		@health_bar = Array.new(2)
#		@star_bar = Array.new(2)

		@score_text = Chingu::Text.create("Score: #{$score}", :y => 0, :font => "GeosansLight", :size => 20, :color => Colors::White, :zorder => Zorder::GUI)
		@score_text.x = 800/2 - @score_text.width/2
	end

	def update
		super
		@score_text.text = "Score: #{$score}"
	end

	def draw
		if $health == 6
			for i in 0..2
				@heart_full.draw(18*i+2, 0, Zorder::GUI)
			end
		elsif $health == 5
			for i in 0..1
				@heart_full.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 2..2
				@heart_half.draw(18*i+2, 0, Zorder::GUI)
			end
		elsif $health == 4
			for i in 0..1
				@heart_full.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 2..2
				@heart_empty.draw(18*i+2, 0, Zorder::GUI)
			end
		elsif $health == 3
			for i in 0..0
				@heart_full.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 1..1
				@heart_half.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 2..2
				@heart_empty.draw(18*i+2, 0, Zorder::GUI)
			end
		elsif $health == 2
			for i in 0..0
				@heart_full.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 1..2
				@heart_empty.draw(18*i+2, 0, Zorder::GUI)
			end
		elsif $health == 1
			for i in 0..0
				@heart_half.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 1..2
				@heart_empty.draw(18*i+2, 0, Zorder::GUI)
			end		
		end

		if $stars == 0
			for i in 0..2
				@star_empty.draw(18*i+70, 0, Zorder::GUI)
			end
		elsif $stars == 1
			for i in 0..0
				@star_full.draw(18*i+70, 0, Zorder::GUI)
			end
			for i in 1..2
				@star_empty.draw(18*i+70, 0, Zorder::GUI)
			end
		elsif $stars == 2
			for i in 0..1
				@star_full.draw(18*i+70, 0, Zorder::GUI)
			end
			for i in 2..2
				@star_empty.draw(18*i+70, 0, Zorder::GUI)
			end
		elsif $stars == 3
			for i in 0..2
				@star_full.draw(18*i+70, 0, Zorder::GUI)
			end
		end
	end
end



=begin
#		elseif($health == 5)

		for i in 0..@health_bar.size
			if($health <= 4)
#			if(@gui_player.health <= i)
				@heart_empty.draw(16*i, 0, Zorder::GUI)
			elsif($health <= 5)
#			elsif(@gui_player.health == i+0.5)
				@heart_half.draw(16*i, 0, Zorder::GUI)
			elsif($health == 6)
#			elsif(@gui_player.health >= i)
				@heart_full.draw(16*i, 0, Zorder::GUI)
			end
		end
	end
end
=end