class Player < Chingu::GameObject
	attr_reader :health,  :score
	has_traits :velocity
	def initialize(health)
		super
		@image = Gosu::Image["assets/player/player.png"]
		@width, @height = 32, 32

		@speed, @rotate_speed = 5, 5
	
		@health = 3
		@score = 0

		@shoot = Gosu::Sample.new($window, "media/sfx/laser.OGG")
	end

	def accelerate
		self.velocity_x = Gosu::offset_x(self.angle, @speed)
		self.velocity_y = Gosu::offset_y(self.angle, @speed)
	end

	def brake
		self.velocity_x *= 0.7
		self.velocity_y *= 0.7
	end

	def turn_left
		self.angle -= @rotate_speed
	end

	def turn_right
		self.angle += @rotate_speed
	end

	def fire
		@shoot.play(rand(0.05..0.1))
		Bullet.create(:x => @x, :y => @y, :angle => @angle, :zorder => Zorder::Projectile)
	end

	def update
		if(@x >= $window.WIDTH - @width/2)
			@x = $window.WIDTH - @width/2
		elsif(@x <= @width/2)
			@x = @width/2
		end

		if(@y >= $window.HEIGHT - @height/2)
			@y = $window.HEIGHT - @height/2
		elsif(@y <= @height/2)
			@y = @height/2
		end

		self.velocity_x *= 0.91
		self.velocity_y *= 0.91
	end
end

class Bullet < Chingu::GameObject
	has_traits :velocity
	def initialize(options)
		super(options.merge(:image => Gosu::Image["assets/player/laser.png"]))
		@speed = 7

		self.velocity_x = Gosu::offset_x(@angle, @speed)
		self.velocity_y = Gosu::offset_y(@angle, @speed)
	end
	def update
		@y += self.velocity_y
		@x += self.velocity_x
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