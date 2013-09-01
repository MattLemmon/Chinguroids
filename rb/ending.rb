
#
#   GAMEOVER GAMESTATE
#
class GameOver < Chingu::GameState
  def initialize
    super
    self.input = { :esc => :exit, [:enter, :return] => Introduction, :p => Pause, :r => lambda{current_game_state.setup}, [:q, :l] => :pop }
  end

  def setup
    @t1 = Chingu::Text.create(:text=>"You died.", :y=>180, :size=>28)
    @t1.x = 400 - @t1.width/2
    @t2 = Chingu::Text.create(:text=>"Game Over", :y=>280, :size=>28)
    @t2.x = 400 - @t2.width/2
    @t3 = Chingu::Text.create(:text=>"Press enter", :y=>380, :size=>28)
    @t3.x = 400 - @t2.width/2
    $window.caption = "Game Over"
  end

  def pop
    pop_game_state(:setup => false)
  end
end


#
#   WIN GAMESTATE
#
class Win < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => Introduction, :p => Pause, :r => lambda{current_game_state.setup}, [:q, :l] => :pop }
    $window.caption = "You win!"
    Bullet.destroy_all
    Player.destroy_all
    Star.destroy_all
    Meteor1.destroy_all
    Meteor2.destroy_all
    Meteor3.destroy_all
    Explosion.destroy_all
    if @player != nil; @player.destroy; end

    @player = Player.create(:x => $player_x, :y => $player_y, :angle => $player_angle, :velocity_x => $player_x_vel, :velocity_y => $player_y_vel, :zorder => Zorder::Main_Character)
#    @gui = GUI.create(@player)

    @accel = false
    @turn_left = false
    @turn_right = false
    @firing = false
    fly_away
  end

  def fly_away

    after(1000) { $music = Song["media/audio/music/end_song.ogg"]; $music.volume = 0.8; $music.play(true) }
    after(1000) { @turn_left = true }
    after(1200) { @accel = true }
    after(1300) { @player.fire }
    after(1350) { @player.fire }
    after(1400) { @player.fire }
    after(1400) { @accel = false }
    after(1500) { @turn_left = false }
    after(3000) { @turn_right = true }
    after(3200) { @firing = true }
    after(3600) { @player.speedify; @accel = true }
    after(3800) { @firing = false }
    after(3800) { @turn_right = false }
    after(7000) { push_game_state(Chingu::GameStates::FadeTo.new(Ending.new, :speed => 10)) }
  end

  def pop
    pop_game_state(:setup => false)
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image: Raw Gosu Image.draw(x,y,zorder)-call
    super
  end

  def update
    super
    if @turn_left == true; @player.turn_left; end
    if @turn_right == true; @player.turn_right; end
    if @accel == true; @player.accelerate; end
    if @firing == true; @player.fire; end
  end
end


#
#  ENDING GAMESTATE
#
class Ending < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => Ending2, :p => Pause, :r => lambda{current_game_state.setup} }

    @player = EndPlayer.create(:x => 400, :y => 640, :angle => 0, :velocity_x => 0, :velocity_y => 0, :zorder => Zorder::Main_Character)
    @earth = Earth1.create(:x => 400, :y => 200)

    after(5000) { @player.accelerate }
    after(10500) { @earth.motion }
    after(20000) { @earth.motion_easing }
    after(21000) { @player.shrink; @player.adjust_particles }
    after(25700) { @player.decelerate }
    after(33000) { push_game_state(Chingu::GameStates::FadeTo.new(Ending2.new, :speed => 10)) }
  end
end


#
#  ENDING2 GAMESTATE
#
class Ending2 < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => EndCredits, :p => Pause, :r => lambda{current_game_state.setup} }

    @player = EndPlayerSide.create(:x => 880, :y => 150, :angle => -90, :velocity_x => -0.7, :velocity_y => 0, :zorder => Zorder::Main_Character)
    @earth = Earth2.create(:x => 150, :y => 300)
    @y_change = 0.3

    after(19000) { @earth.motion_easing }
    after(28000) { push_game_state(Chingu::GameStates::FadeTo.new(EndCredits.new, :speed => 10)) }
  end

  def y_damp
    @y_change *= 0.997
  end

  def update
    super
    if @player.y <= 490
      @player.y += @y_change
    end
    if @player.x <= 650
      @player.factor *= 0.998
      @player.adjust_particles
    end
    if @player.y >= 440
      y_damp
    end
    if @player.x <= 100
      @player.velocity_x *= 0.995
    end
  end
end


#
#   END CREDITS GAMESTATE
#
class EndCredits < Chingu::GameState
  def initialize
    super
    self.input = { :esc => :exit, [:enter, :return] => Introduction, :p => Pause, :r => lambda{current_game_state.setup}, [:q, :l] => :pop }
  end

  def setup
    $window.caption = "Credits"
    @scroll_speed = 0.7
    @st = 650
    @sp = 50

    @t1 = Chingu::Text.create(:text=>"Credits" , :y=>675, :size=>40, :font => "GeosansLight")
    @t1.x = 400 - @t1.width/2
    @t2 = Chingu::Text.create(:text=>"Produced by fractional and mpl" , :y=>@st+@sp*2, :size=>40, :font => "GeosansLight")
    @t2.x = 400 - @t2.width/2
    @t3 = Chingu::Text.create(:text=>"Gosu by jlnr" , :y=>@st+@sp*3, :size=>40, :font => "GeosansLight")
    @t3.x = 400 - @t3.width/2
    @t4 = Chingu::Text.create(:text=>"Chingu by ippa" , :y=>@st+@sp*4, :size=>40, :font => "GeosansLight")
    @t4.x = 400 - @t4.width/2
    @t5 = Chingu::Text.create(:text=>"Ruby by Yukihiro Matsumoto" , :y=>@st+@sp*5, :size=>40, :font => "GeosansLight")
    @t5.x = 400 - @t5.width/2
    @t6 = Chingu::Text.create(:text=>"Intro Music borrowed from StarryKnight/Metro by burtlo" , :y=>@st+@sp*6, :size=>40, :font => "GeosansLight")
    @t6.x = 400 - @t6.width/2
    @t7 = Chingu::Text.create(:text=>"Game Music borrowed from Stageoids by ExplodingCookie " , :y=>@st+@sp*7, :size=>40, :font => "GeosansLight")
    @t7.x = 400 - @t7.width/2
    @t8 = Chingu::Text.create(:text=>"End Music by ______" , :y=>@st+@sp*8, :size=>40, :font => "GeosansLight")
    @t8.x = 400 - @t8.width/2
    @t9 = Chingu::Text.create(:text=>"Knight and Voice borrowed from StarryKnight/Metro by burtlo" , :y=>@st+@sp*9, :size=>40, :font => "GeosansLight")
    @t9.x = 400 - @t9.width/2
    @t10 = Chingu::Text.create(:text=>"Some Sounds remixed from soundbible.com" , :y=>@st+@sp*10, :size=>40, :font => "GeosansLight")
    @t10.x = 400 - @t10.width/2
    @t11 = Chingu::Text.create(:text=>"Additional thanks to Spooner, lol _ o2, et al" , :y=>@st+@sp*11, :size=>40, :font => "GeosansLight")
    @t11.x = 400 - @t11.width/2
    @t12 = Chingu::Text.create(:text=>"Additional Attribution" , :y=>@st+@sp*11, :size=>40, :font => "GeosansLight")
    @t12.x = 400 - @t11.width/2
    @t13 = Chingu::Text.create(:text=>"Additional Attribution" , :y=>@st+@sp*11, :size=>40, :font => "GeosansLight")
    @t13.x = 400 - @t11.width/2

  end

  def pop
    pop_game_state(:setup => false)
  end

  def update
    @t1.y -= @scroll_speed
    @t2.y -= @scroll_speed
    @t3.y -= @scroll_speed
    @t4.y -= @scroll_speed
    @t5.y -= @scroll_speed
    @t6.y -= @scroll_speed
    @t7.y -= @scroll_speed
    @t8.y -= @scroll_speed
    @t9.y -= @scroll_speed
    @t10.y -= @scroll_speed
    @t11.y -= @scroll_speed
  end
end
