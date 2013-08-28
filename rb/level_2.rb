#
#   LEVEL 3 GAMESTATE
#
class Level_2 < Chingu::GameState
  def initialize
    super
    self.input = {:esc => :exit, :p => Pause }
    $score = 0
    @music = Song["media/audio/music/stageoids.ogg"]
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
	  @player = $Player#Player.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)
	  @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :holding_up => :accelerate, :holding_down => :brake, :space => :fire}
    2.times { new_meteor }
    Sound["media/audio/asplode.ogg"]  # cache sound
    Sound["media/audio/exploded.ogg"]
    @music.play(true)
    @music.volume = 0.16
    @gui = GUI.create(@player)
  end

  def new_meteor
    Meteor1.create(:x => rand * 800, :y => rand * 600)
    Meteor2.create(:x => rand * 800, :y => rand * 600)
    Meteor3.create(:x => rand * 800, :y => rand * 600)
    Star.create
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image: Raw Gosu Image.draw(x,y,zorder)-call
    super
  end

  def update
    super
    if $health == 0
      push_game_state(GameOver)
    end
    Bullet.destroy_if { |bullet| bullet.outside_window? }
#    @score_text.text = "Score: #{@score}"
#    $window.caption = "GosuTutorial - " + @score_text.text
#    if rand(100) < 5 && Star.all.size < 30
#      Star.create
#    end

    Player.each_collision(Star) do |player, star|    # Collide starships with stars
      star.destroy
      $score += 300
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
    if $score >= 2800
      push_game_state(Level_2)
      @music.stop
    end
  end
end

