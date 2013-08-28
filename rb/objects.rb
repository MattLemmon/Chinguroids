DEBUG = true  # Set to true to see bounding circles used for collision detection



class Player < Chingu::GameObject
	attr_reader :health, :score
  trait :bounding_circle, :debug => DEBUG
	traits :velocity, :collision_detection
	def initialize(health)
		super
		@image = Gosu::Image["assets/player.png"]
		@width, @height = 32, 32
		@speed, @rotate_speed = 5, 5
		$health = 6

#		@shoot = Gosu::Sample.new($window, "media/sfx/laser.OGG")
        @shoot = Sound["media/audio/laser.OGG"]
        @max_x = 825
    	@max_y = 625
    	@scr_edge = 25
      @cooling_down = 0
	end

  def damage
    if @cooling_down == 0
      @cooling_down = 100
      $health -= 1
      Sound["media/audio/exploded.ogg"].play(0.2)
    end
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
        if @cooling_down != 0
          @cooling_down -= 1
        end
        if @x < -@scr_edge     # wrap around beyond screen edges
            @x = @max_x
        end
        if @y < -@scr_edge
            @y = @max_y
        end
        if @x > @max_x
            @x = -@scr_edge
        end
        if @y > @max_y
            @y = -@scr_edge
        end

		self.velocity_x *= 0.91
		self.velocity_y *= 0.91

		# Particle -- Remember to fix the color error
		Chingu::Particle.create(:x => @x, :y => @y,
								:image => "assets/particle_1.png", 
								:color => 0xFF86EFFF, 
								:mode => :default,
								:fade_rate => -45,
								:angle => @angle,
								:zorder => Zorder::Main_Character_Particles)

		Chingu::Particle.each { |particle| particle.y -= Gosu::offset_y(@angle, @speed); particle.x -= Gosu::offset_x(@angle, @speed)}
		Chingu::Particle.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }
  end
end

#
#   EXPLOSION
#
class Explosion < Chingu::GameObject
  trait :timer
  def setup
    @animation = Chingu::Animation.new(:file => "media/assets/explosion.png", :delay => 5)
  end
  def update
    @image = @animation.next
    after(100) {self.destroy}
  end
end


#
#   BULLET
#
class Bullet < Chingu::GameObject
	has_traits :velocity, :collision_detection, :bounding_circle

	def initialize(options)
		super(options.merge(:image => Gosu::Image["assets/laser.png"]))
		@speed = 7

		self.velocity_x = Gosu::offset_x(@angle, @speed)
		self.velocity_y = Gosu::offset_y(@angle, @speed)
	end

	def update
		@y += self.velocity_y
		@x += self.velocity_x
	end
end

#
#   STAR CLASS
#
class Star < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  trait :collision_detection
  
  def setup
    @animation = Chingu::Animation.new(:file => "../media/assets/Star.png", :size => 25)
    @image = @animation.next
    self.zorder = 200
    self.color = Gosu::Color.new(0xff000000)
    self.color.red = rand(255 - 40) + 40
    self.color.green = rand(255 - 40) + 40
    self.color.blue = rand(255 - 40) + 40
    self.x = rand * 800
    self.y = rand * 600
    cache_bounding_circle     # A cached bounding circle will not adapt to changes in size, but it will follow objects X / Y
  end
  
  def update
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation.next
  end
end



#
#   METEOR
#
class Meteor < Chingu::GameObject
	has_traits :velocity, :collision_detection, :bounding_circle

	def initialize(options)
		super(options.merge(:image => Gosu::Image["assets/meteor.png"]))
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

#
#   METEOR - BIG
#
class Meteor1 < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

  def setup
    @image = Image["media/assets/meteor1.png"]
    self.zorder = 500
#    self.x = rand * 800
#    self.y = rand * 600
    self.velocity_x = (3 - rand * 6) * 1
    self.velocity_y = (3 - rand * 6) * 1
    @max_x, @max_y, @scr_edge = 825, 625, 25
    @angle = rand(360)
    @rotate = 5 - rand(10)
#    if @rotate == 0; @rotate = 6; end
    cache_bounding_circle
  end

  def update
    @angle += @rotate
    if @x < -@scr_edge; @x = @max_x; end
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end

#
#   METEOR 2 - MEDIUM
#
class Meteor2 < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

  def setup
    @image = Image["media/assets/meteor2.png"]
    self.zorder = 500
#    self.x = rand * 800
#    self.y = rand * 600
    self.velocity_x = (3 - rand * 6) * 1
    self.velocity_y = (3 - rand * 6) * 1
    @angle = rand(360)
    @rotate = 5 - rand(10)
    @max_x, @max_y, @scr_edge = 825, 625, 25
    cache_bounding_circle
  end

  def update
    @angle += @rotate
    if @x < -@scr_edge; @x = @max_x; end
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end

#
#   METEOR 3 - SMALL
#
class Meteor3 < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

  def setup
    @image = Image["media/assets/meteor3.png"]
    self.zorder = 500
#    self.x = rand * 800
#    self.y = rand * 600
    self.velocity_x = (3 - rand * 6) * 2
    self.velocity_y = (3 - rand * 6) * 2
    @angle = rand(360)
    @rotate = 5 - rand(10)
    @max_x, @max_y, @scr_edge = 825, 625, 25
    cache_bounding_circle
  end

  def update
    @angle += @rotate
    if @x < -@scr_edge; @x = @max_x; end
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end



