DEBUG = false  # Set to true to see bounding circles used for collision detection

#
#
#  PLAYER CLASS
#
class Player < Chingu::GameObject
	attr_reader :health, :score
  trait :bounding_circle, :debug => DEBUG
	traits :velocity, :collision_detection
	def initialize(health)
		super
    @picture1 = Gosu::Image["assets/player.png"]
    @picture2 = Gosu::Image["assets/player_blink.png"]
		@width, @height = 32, 32
		@max_speed, @speed, @part_speed, @rotate_speed = 12, 0.4, 7, 5

    @shoot = Sound["media/audio/laser.OGG"]
    @max_x = $max_x
  	@max_y = $max_y
  	@scr_edge = $scr_edge
    @cooling_down = $cooling_down
    @blink = 14
#    @x_weapons = 0
#    @y_weapons = 0
	end

  def damage
    if @cooling_down == 0
      @cooling_down = $cooling_down
      $health -= 1
      Sound["media/audio/exploded.ogg"].play(0.2)
    end
  end

	def accelerate
    if self.velocity_x <= @max_speed and self.velocity_y <= @max_speed
  		self.velocity_x += Gosu::offset_x(self.angle, @speed)
	  	self.velocity_y += Gosu::offset_y(self.angle, @speed)
    end
	end

	def brake
		self.velocity_x *= 0.9
		self.velocity_y *= 0.9
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
    if $weapon >= 2
     if @angle <= 90
        Bullet.create(:x => @x + 20 - @angle / 4.5, :y => @y + @angle / 4.5, :angle => @angle, :zorder => Zorder::Projectile)
        Bullet.create(:x => @x - 20 + @angle / 4.5, :y => @y - @angle / 4.5, :angle => @angle, :zorder => Zorder::Projectile)
      elsif @angle <= 180
        Bullet.create(:x => @x + 20 - @angle / 9, :y => @y + @angle / 9, :angle => @angle, :zorder => Zorder::Projectile)
        Bullet.create(:x => @x - 20 + @angle / 9, :y => @y - @angle / 9, :angle => @angle, :zorder => Zorder::Projectile)
      elsif @angle <= 270
        Bullet.create(:x => @x + 20 - @angle / 13.5, :y => @y + @angle / 13.5, :angle => @angle, :zorder => Zorder::Projectile)
        Bullet.create(:x => @x - 20 + @angle / 13.5, :y => @y - @angle / 13.5, :angle => @angle, :zorder => Zorder::Projectile)
      else
        Bullet.create(:x => @x + 20 - @angle / 18, :y => @y + @angle / 18, :angle => @angle, :zorder => Zorder::Projectile)
        Bullet.create(:x => @x - 40 + @angle / 18, :y => @y - @angle / 18, :angle => @angle, :zorder => Zorder::Projectile)
      end
    end
  end

  def blink
    if @blink == 14
      @image = @picture2
      @blink = 0
    elsif @blink == 7
      @image = @picture1
      @blink +=1
    else
      @blink +=1
    end
  end

  def update
    self.velocity_x *= 0.99
    self.velocity_y *= 0.99

    if @cooling_down != 0  # player cannot be damaged during cool down
      @cooling_down -= 1
      blink
    else
      @image = @picture1
    end

    if @x < -@scr_edge; @x = @max_x; end  # wrap around beyond screen edges
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end

  # Particle -- Remember to fix the color error
		Chingu::Particle.create(:x => @x, :y => @y,
	  				:image => "assets/particle_1.png", 
						:color => 0xFF86EFFF, 
						:mode => :default,
						:fade_rate => -45,
						:angle => @angle,
						:zorder => Zorder::Main_Character_Particles)

		Chingu::Particle.each { |particle| particle.y -= Gosu::offset_y(@angle, @part_speed); particle.x -= Gosu::offset_x(@angle, @part_speed)}
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
  trait :bounding_circle, :debug => DEBUG
	has_traits :timer, :velocity, :collision_detection

	def initialize(options)
		super(options.merge(:image => Gosu::Image["assets/laser.png"]))
		@speed = 7

		self.velocity_x = Gosu::offset_x(@angle, @speed)
		self.velocity_y = Gosu::offset_y(@angle, @speed)
    @max_x, @max_y, @scr_edge = $max_x, $max_y, $scr_edge
	end

	def update
		@y += self.velocity_y
		@x += self.velocity_x
    if @x < -@scr_edge; @x = @max_x; end  # wrap beyond screen edge
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end
    after(550) {self.destroy}
	end
end

#
#   STAR CLASS
#
class Star < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  trait :collision_detection
  
  def setup
    @animation = Chingu::Animation.new(:file => "../media/assets/living.png", :size => 64)
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
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

	def initialize(options)
		super(options.merge(:image => Gosu::Image["assets/meteor.png"]))
		@angular_velocity = 5
    @max_x, @max_y, @scr_edge = 825, 625, 25
		@random = rand(2)+1
		if(@random == 1)
			@angular_velocity = -@angular_velocity
		end
	end

	def update
		@angle += @angular_velocity
    if @x < -@scr_edge; @x = @max_x; end
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end
	end
end

#
#   METEOR 1 - BIG
#
class Meteor1 < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

  def setup
    @image = Image["media/assets/meteor2.png"]
    self.zorder = 500
    self.velocity_x = (3 - rand * 6) * 2
    self.velocity_y = (3 - rand * 6) * 2
    @max_x, @max_y, @scr_edge = 825, 625, 25
    @angle = rand(360)
    @rotate = rand(10) + 5
    if @rotate == 0; @rotate = 6; end
    if rand(2) == 1; @rotate *= -1; end
    cache_bounding_circle
  end

  def meteor_placement
    if rand(2) == 1
      self.x = 0
      self.y = rand(600)
    else
      self.x = rand(800)
      self.y = 0
    end
  end

  def update
    @angle += @rotate
    if @x < -@scr_edge; @x = @max_x; end
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end
  end

end

#
#   METEOR 2 - MEDIUM
#
class Meteor2 < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

  def setup
    @image = Image["media/assets/meteor.png"]
    self.zorder = 500
#    self.factor = 1
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
#    self.factor = 0.9
    self.velocity_x = (3 - rand * 6) * 2.5
    self.velocity_y = (3 - rand * 6) * 2.5
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

end

#
#  SPARKLE
#
class Sparkle < Chingu::GameObject
  def setup
    @image = Image["media/assets/sparkle.png"]
    self.factor = 0.1
    @turning = 0.5
    @factoring = 1.0
    @angle = 35
  end

  def turnify1; @turning = 0.5; @factoring = 1.2;   end
  def turnify2; @turning = 0.5; @factoring = 1.02;  end
  def turnify3; @turning = 0.49; @factoring = 1.0;  end
  def turnify4; @turning = 0.47; @factoring = 1.0;  end
  def turnify5; @turning = 0.45; @factoring = 1.0;  end
  def turnify6; @turning = 0.43; @factoring = 1.0;  end

  def update
    @angle += @turning
    self.factor *= @factoring
    if self.factor >= 1.1
      @factoring = 1.0
    end
  end
end

#
#  HIGHLIGHT
#
class Highlight < Chingu::GameObject
  def setup
    @image = Image["media/assets/highlight.png"]
  end
  def update
    @x += 5
  end
end

#
#  HIGHLIGHT2
#
class Highlight2 < Chingu::GameObject
  def setup
    @image = Image["media/assets/highlight2.png"]
  end
  def update
    @x += 5
  end
end

#
#  KNIGHT
#
class Knight < Chingu::GameObject
  trait :timer
  def initialize(options)
    super
    @image = Image["media/assets/knight.png"]
    @voice = Sound["media/audio/mumble.ogg"]
    @velox = 0
    @veloy = 0
    @factoring = 1
  end

  def movement
    @velox = -7
  end

  def enter_ship
    @veloy = 2
    @factoring = 0.98
  end

  def speak
    @voice.play
  end

  def update
    self.factor *= @factoring
    @x += @velox
    @y += @veloy
    if @x <= 400; @velox = 0; end
    if @y >= 450; @veloy = 0; end
  end
end