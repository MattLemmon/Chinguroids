#
#  KNIGHT
#
class Knight < Chingu::GameObject
#  trait :timer
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

#
#  END KNIGHT
#
class EndKnight < Chingu::GameObject
  def setup
    @image = Image["media/assets/knight_left.png"]
  end
  def update
    @x -= 1.9
  end
end


#
#  CHARACTERS
#
class Characters < Chingu::GameObject
  def initialize(options={})
    super
    self.x = rand(800)
    if rand(6) == 1
      self.y = rand(400)
    elsif rand(5) == 1
      self.y = rand(300)
    elsif rand(4) == 1
      self.y = rand(200)
    elsif rand(3) == 1
      self.y = rand(150)
    elsif rand(2) == 1
      self.y = rand(100)
    elsif rand(2) == 1
      self.y = rand(75)
    else
      self.y = rand(50)
    end
  end

  def update 
    self.factor = (@y + 100)/600.0
    self.zorder = @y
    if rand(50) == 1; @x += @motion; end
    if rand(50) == 1; @x -= @motion; end
    if rand(150) == 1; @y += @motion; end
    if rand(150) == 1; @y -= @motion; end
  end
end


class Char2 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char2.png"]
  end
end

class Char3 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char3.png"]
  end
end

class Char4 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char4.png"]
  end
end

class Char5 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char5.png"]
  end
end

class Char6 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char6.png"]
  end
end

class Char7 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char7.png"]
  end
end

class Char8 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char8.png"]
  end
end

class Char9 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char9.png"]
  end
end

class Char10 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char10.png"]
  end
end

class Char11 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char11.png"]
  end
end

class Char12 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char12.png"]
  end
end

class Char13 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char13.png"]
  end
end

class Char14 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char14.png"]
  end
end

class Char15 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char15.png"]
  end
end


#
#  CHARACTER 1 
#
#class Char1 < Characters
class Char1 < Chingu::GameObject
  def setup
#    self.factor = 1.1
    @motion = 1
    @image = Gosu::Image["assets/characters/char1.png"]
    self.input = [:holding_left, :holding_right, :holding_up, :holding_down ]
#    @last_x = @x
  end

  def holding_left
    @x -= 8
#    @frame_name = :left
  end
  def holding_right
    @x += 8
#    @frame_name = :right
  end
  def holding_up
    @y -= 8
#    @frame_name = :up
  end
  def holding_down
    @y += 8
#    @frame_name = :down
  end

  def update 
    self.factor = (@y + 100)/500.0
    self.zorder = @y
    if rand(20) == 1; @x += @motion; end
    if rand(20) == 1; @x -= @motion; end
    if rand(20) == 1; @y += @motion; end
    if rand(20) == 1; @y -= @motion; end
#    @last_x = @x
  end
end
