class Introduction < Chingu::GameState
	def initialize
		super
		puts "Introduction"
		@music = Gosu::Song.new($window, "media/music/backgroundmusic.ogg")
		@music.volume = 0.0
		@music.play(true)

		@text = Chingu::Text.new("Welcome to ChinguRoids", :y => $window.HEIGHT/4, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange)
		@text.x = $window.WIDTH/2 - @text.width/2

		@text2 = Chingu::Text.new("Press ENTER to play", :y => $window.HEIGHT/4+$window.HEIGHT/4, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange)
		@text2.x = $window.WIDTH/2 - @text2.width/2

		self.input = {:return => :next}
	end

	def update

	end

	def draw
		@text.draw
		@text2.draw
	end

	def next
		@music.stop
		close
	end
end

class Play < Chingu::GameState
	def initialize
		super 
		puts "Play"
		@player = Player.create(:x => 400, :y => 300)
		@player.input = {:holding_left => :move_left, :holding_right => :move_right, :holding_up => :move_up, :holding_down => :move_down, :space => :fire}
	end

	def draw
		super
		Gosu::Image["assets/window/background.png"].draw(0, 0, 0)
	end

	def update
		super
		Bullet.destroy_if {|bullet| bullet.outside_window?}
	end
end