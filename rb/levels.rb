
#
#   LEVEL 1 GAMESTATE
#
class Level_1 < Chingu::GameState
  trait :timer
  def initialize
    super
    $health = 6
    $score = 0
    $stars = 0
    $weapon = 1
    self.input = { [:enter, :return] => Level_2, :p => Pause, :r => lambda{ current_game_state.setup } }
    $music.stop
  end

  def setup
    super
    Bullet.destroy_all
    Player.destroy_all
    Star.destroy_all
    Meteor.destroy_all
    Meteor1.destroy_all
    Meteor2.destroy_all
    Meteor3.destroy_all
    Explosion.destroy_all
    if @player != nil; @player.destroy; end

    @player = Player.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)#(:x => $player_x, :y => $player_y, :angle => $player_angle, :zorder => Zorder::Main_Character)
    @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :holding_up => :accelerate, :holding_down => :brake, :space => :fire}
    @gui = GUI.create(@player)

    $music = Song["media/audio/music/stageoids.ogg"]
    Sound["media/audio/asplode.ogg"]  # cache sound
    Sound["media/audio/exploded.ogg"]

    @player.cool_down
    1.times { new_meteor }

    after(100) {
      $music.play(true)
      $music.volume = 0.25
    }
  end

  def new_meteor
    Meteor1.create(:x => rand * 800, :y => rand * 600)
    Meteor2.create(:x => rand * 800, :y => rand * 600)
    Meteor3.create(:x => rand * 800, :y => rand * 600)
    Star.create
    Star.create
    Star.create
  end

  def collision_check
    Player.each_collision(Star) do |player, star|    # Collide starships with stars
      star.destroy
      $score += 300
      $stars += 1
      if $stars != 3
        $star_grab.play
      else
        $power_up.play
        $stars = 0
        $weapon += 1
      end
    end
    Bullet.each_collision(Meteor1) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/explosion.ogg"].play(0.2)
    end
    Bullet.each_collision(Meteor2) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
    end
    Bullet.each_collision(Meteor3) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
    end
    Player.each_collision(Meteor1) do |starship, meteor|    # Collide starships with meteors
      @player.damage
    end
    Player.each_collision(Meteor2) do |starship, meteor|    # Collide starships with meteors
      @player.damage
    end
    Player.each_collision(Meteor3) do |starship, meteor|    # Collide starships with meteors
      @player.damage
    end
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image: Raw Gosu Image.draw(x,y,zorder)-call
    super
  end

  def update
    super
    collision_check
    $player_x, $player_y = @player.x, @player.y  # save player's position for next level
    $player_angle, $player_x_vel, $player_y_vel = @player.angle, @player.velocity_x, @player.velocity_y
    if Meteor1.size + Meteor2.size + Meteor3.size == 0
      after(1000) { push_game_state(Level_2) }
    end
    if $health == 0
      Explosion.create(:x => @player.x, :y => @player.y)
      @player.destroy
      $music.stop
      after(1000) { push_game_state(Chingu::GameStates::FadeTo.new(GameOver.new, :speed => 10)) }
    end
  end
end



#
#   LEVEL 2 GAMESTATE
#
class Level_2 < Chingu::GameState
  trait :timer
  def initialize
    super
    self.input = { [:enter, :return] => Level_3, :p => Pause, :r => lambda{ current_game_state.setup } }
  end

  def setup
    super
    Bullet.destroy_all
    Player.destroy_all
    Star.destroy_all
    Meteor1.destroy_all
    Meteor2.destroy_all
    Meteor3.destroy_all
    Explosion.destroy_all
    if @player != nil; @player.destroy; end

	  @player = Player.create(:x => $player_x, :y => $player_y, :angle => $player_angle, :velocity_x => $player_x_vel, :velocity_y => $player_y_vel, :zorder => Zorder::Main_Character)
	  @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :holding_up => :accelerate, :holding_down => :brake, :space => :fire}
    @gui = GUI.create(@player)

    Sound["media/audio/asplode.ogg"]  # cache sound
    Sound["media/audio/exploded.ogg"]

    @player.cool_down
    2.times { new_meteor }

  end

  def new_meteor
    Meteor1.create(:x => rand * 800, :y => rand * 600)
    Meteor2.create(:x => rand * 800, :y => rand * 600)
    Meteor3.create(:x => rand * 800, :y => rand * 600)
    Star.create
    Star.create
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image: Raw Gosu Image.draw(x,y,zorder)-call
    super
  end

  def collision_check
    Player.each_collision(Star) do |player, star|    # Collide starships with stars
      star.destroy
      $score += 300
      $stars += 1
      if $stars != 3
        $star_grab.play
      else
        $power_up.play
        $stars = 0
        $weapon = 2
      end
    end
    Bullet.each_collision(Meteor1) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/explosion.ogg"].play(0.2)
    end
    Bullet.each_collision(Meteor2) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
    end
    Bullet.each_collision(Meteor3) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
    end
    Player.each_collision(Meteor1) do |starship, meteor|    # Collide starships with meteors
      @player.damage
    end
    Player.each_collision(Meteor2) do |starship, meteor|    # Collide starships with meteors
      @player.damage
    end
    Player.each_collision(Meteor3) do |starship, meteor|    # Collide starships with meteors
      @player.damage
    end
  end

  def update
    super
    collision_check
    $player_x, $player_y = @player.x, @player.y  # save player's position for next level
    $player_angle, $player_x_vel, $player_y_vel = @player.angle, @player.velocity_x, @player.velocity_y
    if Meteor1.size + Meteor2.size + Meteor3.size == 0
      after(1000) { push_game_state(Level_3) }
    end
    if $health == 0
      Explosion.create(:x => @player.x, :y => @player.y)
      @player.destroy
      $music.stop
      after(1000) { push_game_state(Chingu::GameStates::FadeTo.new(GameOver.new, :speed => 10)) }
    end
  end
end


#
#   LEVEL 3 GAMESTATE
#
class Level_3 < Chingu::GameState
  trait :timer
  def initialize
    super
    self.input = { [:enter, :return] => Win, :p => Pause, :r => lambda{ current_game_state.setup } }
  end

  def setup
    super
    Bullet.destroy_all
    Player.destroy_all
    Star.destroy_all
    Meteor1.destroy_all
    Meteor2.destroy_all
    Meteor3.destroy_all
    Explosion.destroy_all
    if @player != nil; @player.destroy; end

    @player = Player.create(:x => $player_x, :y => $player_y, :angle => $player_angle, :velocity_x => $player_x_vel, :velocity_y => $player_y_vel, :zorder => Zorder::Main_Character)
    @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :holding_up => :accelerate, :holding_down => :brake, :space => :fire}
    @gui = GUI.create(@player)

    @song_fade = false
    @fade_count = 0
    Sound["media/audio/asplode.ogg"]  # cache sound
    Sound["media/audio/exploded.ogg"]

    @player.cool_down
    3.times { new_meteor }

  end

  def new_meteor
    Meteor1.create(:x => rand * 800, :y => rand * 600)
    Meteor2.create(:x => rand * 800, :y => rand * 600)
    Meteor3.create(:x => rand * 800, :y => rand * 600)
    Star.create
    Star.create
  end

  def collision_check
    Player.each_collision(Star) do |player, star|    # Collide starships with stars
      star.destroy
      $score += 300
      $stars += 1
      if $stars != 3
        $star_grab.play
      else
        $power_up.play
        $stars = 0
        $weapon += 1
      end
    end
    Bullet.each_collision(Meteor1) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/explosion.ogg"].play(0.2)
    end
    Bullet.each_collision(Meteor2) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
    end
    Bullet.each_collision(Meteor3) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
    end
    Player.each_collision(Meteor1) do |starship, meteor|    # Collide starships with meteors
      @player.damage
    end
    Player.each_collision(Meteor2) do |starship, meteor|    # Collide starships with meteors
      @player.damage
    end
    Player.each_collision(Meteor3) do |starship, meteor|    # Collide starships with meteors
      @player.damage
    end
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image: Raw Gosu Image.draw(x,y,zorder)-call
    super
  end

  def update
    super
    collision_check
    $player_x, $player_y = @player.x, @player.y  # save player's position for next level
    $player_angle, $player_x_vel, $player_y_vel = @player.angle, @player.velocity_x, @player.velocity_y
    if $health == 0
      Explosion.create(:x => @player.x, :y => @player.y)
      @player.destroy
      $music.stop
      after(1000) { push_game_state(Chingu::GameStates::FadeTo.new(GameOver.new, :speed => 10)) }
    end
    if Meteor1.size + Meteor2.size + Meteor3.size == 0
      after(5000) { push_game_state(Win) }
    end
    if @song_fade == true
      @fade_count += 1
      if @fade_count == 20
        @fade_count = 0
        $music.volume -= 0.1
      end
    end
  end
end

