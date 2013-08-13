class Player < Chingu::GameObject
	def initialize(options = {})
		super
		@image = Gosu::Image["assets/player/player.png"]
		@speed = 5
		@width, @height = 32, 32

		@shoot = Gosu::Sample.new($window, "media/sfx/laser.OGG")
	end

	def move_left
		if(@x > @speed + (@width/2))
			@x -= @speed
		end
	end

	def move_right
		if(@x < $window.WIDTH - @speed - (@width/2) )
			@x += @speed
		end
	end

	def move_up
		if(@y - @speed - (@height/2) > 0)
	 		@y -= @speed
	 	end 
	end

	def move_down
		if(@y + @speed + (@height/2) < $window.HEIGHT)
	 		@y += @speed
	 	end
	end

	def fire
		@shoot.play(rand(0.05..0.1))
		Bullet.create(:x => @x, :y => @y-32)
	end
end

class Bullet < Chingu::GameObject
	def initialize(options)
		super(options.merge(:image => Gosu::Image["assets/player/laser.png"]))
	end
	def update
		@y -= 5
	end
end

class Meteor < Chingu::GameObject
	has_traits :velocity

	def initialize(options)
		super(options.merge(:image => Gosu::Image["assets/objects/meteor.png"]))
		@angular_velocity = 5

		@random = rand(2)+1
		if(@random == 1)
			@angular_velocity = -@angular_velocity
		end
	end

	def update
		@angle += @angular_velocity
	end
end