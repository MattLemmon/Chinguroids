#
#  OPENING CREDITS GAMESTATE
#
class OpeningCredits < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => Introduction, :p => Pause, :r => lambda{current_game_state.setup} }

    $music = Song["media/audio/music/title_song.ogg"]
    $music.volume = 0.8
    $music.play(true)

    @white = Colors::White#Color.new(0xFFFFFFFF)
    @black = Color.new(0xFF000000)
    @text = Chingu::Text.create("press enter to skip intro", :y => 560, :font => "GeosansLight", :size => 18, :color => @black, :zorder => Zorder::GUI)
    @text.x = 800/2 - @text.width/2
    @logo = GosuLogo.create(:x => 400, :y => 300)



    after(600) {
#      @text = Chingu::Text.create("press enter to skip intro", :y => 560, :font => "GeosansLight", :size => 18, :color => @black, :zorder => Zorder::GUI)
#      @text.x = 800/2 - @text.width/2
      puts "hello"
      after(600) {
#        @logo = GosuLogo.create(:x => 400, :y => 300)
        after(600) {
          @beam = Highlight.create(:x => 200, :y => 300)
          after(5000) {
            push_game_state(Introduction)
          }
        }
      }
    }
  end

  def draw
#    fill(@white)
    Image["../media/assets/blank.png"].draw(0, 0, 0)
    super
  end
end









#
#  LEVEL_1 GAMESTATE
#
class Level_1 < Chingu::GameState
  def initialize
    super
    $health = 6
    $score = 0
    self.input = {:esc => :exit, :p => Pause, [:enter, :return] => Level_2, :c => :count_meteors  }
    @music = Song["media/audio/music/end_song.ogg"]
  end

  def setup
    super
    Bullet.destroy_all
    Player.destroy_all
    Star.destroy_all
    Meteor.destroy_all
    Explosion.destroy_all
    if @player != nil; @player.destroy; end

    @player = Player.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)
    @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :holding_up => :accelerate, :holding_down => :brake, :space => :fire}

    @gui = GUI.create(@player)

    Sound["media/audio/asplode.ogg"]  # cache sound
    Sound["media/audio/exploded.ogg"]
    @music.play(true)
    @music.volume = 0.16

    6.times { new_meteor }
  end

  def count_meteors
    puts Meteor.size
  end

  def new_meteor
    Star.create
    2.times { meteor_cases }
  end

  def meteor_cases
    @random = rand(4)+1
    case @random
    when 1
      Meteor.create(x: rand(800)+1, y: 0,
              velocity_y: rand(5)+1, velocity_x: rand(-5..5),
              :factor => rand(0.5)+0.4, :zorder => Zorder::Object)
    when 2
      Meteor.create(x: rand(800)+1, y: 600,
              velocity_y: rand(1..5)*-1, velocity_x: rand(-5..5),
                :factor => rand(0.5)+0.4, :zorder => Zorder::Object)
    when 3
      Meteor.create(x: 0, y: rand(600)+1,
              velocity_x: rand(1..5), velocity_y: rand(-5..5),
                :factor => rand(0.5)+0.4, :zorder => Zorder::Object)
    when 4
      Meteor.create(x: 800, y: rand(600)+1,
              velocity_x: rand(1..5)*-1, velocity_y: rand(-5..5),
              :factor => rand(0.5)+0.4, :zorder => Zorder::Object)
    end
  end

  def draw
    Gosu::Image["assets/background.png"].draw(0, 0, 0)
    super
  end

  def update
    super
    check_for_collision
    $player_x, $player_y, $player_angle = @player.x, @player.y, @player.angle  #save player's position for next level
    if Meteor.size == 0
      push_game_state(Level_2)
    end
  end


  def check_for_collision
    Bullet.each_collision(Meteor) do |projectile, meteor|
      Explosion.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      projectile.destroy
      $score += 100
      Sound["media/audio/explosion.ogg"].play(0.2)
    end
    Player.each_collision(Meteor) do |player, meteor|
      @player.damage
    end
  end
end





#
#   LEVEL 2 GAMESTATE
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




#
#   LEVEL 3 GAMESTATE
#
class Level_3 < Chingu::GameState
  def initialize
    super
    self.input = {:esc => :exit, :p => Pause }
#    $score = 2800
#    $score_text = Text.create("Score: #{$score}", :x => 10, :y => 10, :zorder => 55, :size=>20)
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
  @player = Player.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)
  @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :holding_up => :accelerate, :holding_down => :brake, :space => :fire}
    4.times { new_meteor }
    Sound["media/audio/asplode.ogg"]  # cache sounds
    Sound["media/audio/exploded.ogg"]
#    Sound["media/audio/phaser.ogg"]
#    Song["intromusic.ogg"]
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
    Bullet.destroy_if { |bullet| bullet.outside_window? }
#    $score_text.text = "Score: #{$score}"
#    $window.caption = "GosuTutorial - " + $score_text.text
#    if rand(100) < 5 && Star.all.size < 30
#      Star.create
#    end

    Player.each_collision(Star) do |starship, star|    # Collide starships with stars
      star.destroy
      $score += 300
    end
    Bullet.each_collision(Meteor1) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
    end
    Bullet.each_collision(Meteor2) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
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
    Player.each_collision(Meteor1) do |starship, meteor|    # Collide starship with meteors
      starship.destroy
      Sound["media/audio/exploded.ogg"].play(0.2)
      push_game_state(GameOver)
    end
    Player.each_collision(Meteor2) do |starship, meteor|    # Collide starship with meteors
      starship.destroy
      Sound["media/audio/exploded.ogg"].play(0.2)
      push_game_state(GameOver)
    end
    Player.each_collision(Meteor3) do |starship, meteor|    # Collide starship with meteors
      starship.destroy
      Sound["media/audio/exploded.ogg"].play(0.2)
      push_game_state(GameOver)
    end
    if $score >= 5200
      push_game_state(Win)
    end
  end
end


#    @meteor1 = Meteor1.create#(:x => rand * 800, :y => rand * 600)
#    @meteor1.meteor_placement
#    Meteor1.create(if rand(2) == 1; :x => 0, :y => rand * 600; else; :x => rand * 800, :y => 0; end)

#  def meteor_placement
#    if rand(2) == 1
#      self.x = 0
#      self.y = rand(600)
#    else
#      self.x = rand(800)
#      self.y = 0
#    end
#  end




=begin
  def meteor_cases
    @random = rand(4)+1
    case @random
    when 1
      self.x = rand(800)+1
      self.y = 0
      self.velocity_y = rand(5)+1
      self.velocity_x = rand(-5..5),
    end
    when 2
      self.x = rand(800)+1
      self.y = 600
      self.velocity_y = rand(1..5)*-1
      self.velocity_x = rand(-5..5)
    end
    when 3
      self.x = 0
      self.y = rand(600)+1
      self.velocity_x = rand(1..5)
      self.velocity_y = rand(-5..5)
    end
    when 4
      self.x = 800
      self.y = rand(600)+1
      self.velocity_x = rand(1..5)*-1
      self.velocity_y = rand(-5..5)
    end
  end
=end