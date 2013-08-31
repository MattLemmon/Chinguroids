
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
    @t2 = Chingu::Text.create(:text=>"Press enter", :y=>280, :size=>28)
    @t2.x = 400 - @t2.width/2
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
    $window.caption = "You win!"
    self.input = { :esc => :exit, [:enter, :return] => Introduction, :p => Pause, :r => lambda{current_game_state.setup}, [:q, :l] => :pop }
#    @t1 = Chingu::Text.create(:text=>"You died.", :y=>180, :size=>28)
#    @t1.x = 400 - @t1.width/2
#    @t2 = Chingu::Text.create(:text=>"Press enter", :y=>280, :size=>28)
#    @t2.x = 400 - @t2.width/2
    Bullet.destroy_all
    Player.destroy_all
    Star.destroy_all
    Meteor1.destroy_all
    Meteor2.destroy_all
    Meteor3.destroy_all
    Explosion.destroy_all
    if @player != nil; @player.destroy; end

    @player = Player.create(:x => $player_x, :y => $player_y, :angle => $player_angle, :velocity_x => $player_x_vel, :velocity_y => $player_y_vel, :zorder => Zorder::Main_Character)
    @accel = false
    @turn_left = false
    @turn_right = false
    @firing = false
    fly_away
  end

  def fly_away
    after(1000) { @turn_left = true }
    after(1200) { @accelerate = true }
    after(1500) { @turn_left = false }
    after(1300) { @firing = true }
    after(1600) { @firing = false }
    after(2000) { push_game_state(Chingu::GameStates::FadeTo.new(EndCredits.new, :speed => 10)) }
  end


  def pop
    pop_game_state(:setup => false)
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image: Raw Gosu Image.draw(x,y,zorder)-call
    super
  end

  def update
    if @turn_left == true
      @player.turn_left
    end
    if @turn_right == true
      @player.turn_right
    end
    if @accel == true
      @player. accelerate
    end
  end
end


#
#  ENDING GAMESTATE
#
class Ending
  # Add ending.........
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
    $window.caption = "ChinguRoids - Victory"
    $music = Song["media/audio/music/end_song.ogg"]
    $music.play(true)
    $music.volume = 0.7

    @t1 = Chingu::Text.create(:text=>"Credits" , :y=>610, :size=>40, :font => "GeosansLight")
    @t1.x = 400 - @t1.width/2
    @t2 = Chingu::Text.create(:text=>"Directed by fractional" , :y=>660, :size=>40, :font => "GeosansLight")
    @t2.x = 400 - @t2.width/2
    @t3 = Chingu::Text.create(:text=>"Executive Producer mpl" , :y=>710, :size=>40, :font => "GeosansLight")
    @t3.x = 400 - @t3.width/2
    @t4 = Chingu::Text.create(:text=>"Gosu by jlnr" , :y=>760, :size=>40, :font => "GeosansLight")
    @t4.x = 400 - @t4.width/2
    @t5 = Chingu::Text.create(:text=>"Chingu by ippa" , :y=>810, :size=>40, :font => "GeosansLight")
    @t5.x = 400 - @t5.width/2
    @t6 = Chingu::Text.create(:text=>"Ruby by Yukihiro Matsumoto" , :y=>860, :size=>40, :font => "GeosansLight")
    @t6.x = 400 - @t6.width/2
    @t7 = Chingu::Text.create(:text=>"Additional thanks to spooner, lol_ o2, et al" , :y=>910, :size=>40, :font => "GeosansLight")
    @t7.x = 400 - @t7.width/2
    @t8 = Chingu::Text.create(:text=>"Some Images and Sounds borrowed from starry-knight by gitorious" , :y=>960, :size=>40, :font => "GeosansLight")
    @t8.x = 400 - @t8.width/2
    @t9 = Chingu::Text.create(:text=>"Some Sounds remixed from SoundBible.com" , :y=>1010, :size=>40, :font => "GeosansLight")
    @t9.x = 400 - @t9.width/2
    @t10 = Chingu::Text.create(:text=>"Additional Attribution" , :y=>1060, :size=>40, :font => "GeosansLight")
    @t10.x = 400 - @t10.width/2
    @t11 = Chingu::Text.create(:text=>"Additional Attribution" , :y=>1110, :size=>40, :font => "GeosansLight")
    @t11.x = 400 - @t11.width/2
  end

  def pop
    pop_game_state(:setup => false)
  end

  def update
    @t1.y -= 1
    @t2.y -= 1
    @t3.y -= 1
    @t4.y -= 1
    @t5.y -= 1
    @t6.y -= 1
    @t7.y -= 1
    @t8.y -= 1
    @t9.y -= 1
    @t10.y -= 1
    @t11.y -= 1
  end
end
