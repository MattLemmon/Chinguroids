
#
#  BEGINNING GAMESTATE
#
class Beginning < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit } #, [:enter, :return] => OpeningCredits, :p => Pause, :r => lambda{current_game_state.setup} }
    $music = Song["media/audio/music/intro_song.ogg"]
    $music.volume = 0.8
    $music.play(true)
    after(10) { push_game_state(Chingu::GameStates::FadeTo.new(OpeningCredits.new, :speed => 5)) }
  end
end

#
#  PAUSE GAMESTATE
#
class Pause < Chingu::GameState
  def initialize(options = {})
    super
    @title = Chingu::Text.create(:text=>"PAUSED (press 'P' to un-pause, 'R' to reset)", :x=>100, :y=>100, :size=>30, :color => Color.new(0xFF00FF00), :zorder=>1000 )
    self.input = { :p => :un_pause, :r => :reset }
  end
  def un_pause
    pop_game_state(:setup => false)    # Return the previous game state, dont call setup()
  end  
  def reset
    pop_game_state(:setup => true)
  end
  def draw
    previous_game_state.draw    # Draw prev game state onto screen (in this case our level)
    super                       # Draw game objects in current game state, this includes Chingu::Texts
  end  
end

#
#  OPENING CREDITS GAMESTATE
#
class OpeningCredits < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => :intro, :p => Pause, :r => lambda{current_game_state.setup} }
    @beam = Highlight.create(:x => 66, :y => 300)
    @beam2 = Highlight2.create(:x => 0, :y => 300)
    @beam3 = Highlight.create(:x => -500, :y => 300)
    after (4300) {
      push_game_state(Chingu::GameStates::FadeTo.new(OpeningCredits2.new, :speed => 6))
    }
  end

  def intro
    push_game_state(Chingu::GameStates::FadeTo.new(Introduction.new, :speed => 10))
  end

  def draw
    Image["../media/assets/gosu-logo.png"].draw(0, 0, 0)
    super
  end
end

#
#  OPENING CREDITS 2 GAMESTATE
#
class OpeningCredits2 < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => :intro, :p => Pause, :r => lambda{current_game_state.setup} }
    Sparkle.destroy_all
    @sparkle = Sparkle.create(:x => 373, :y => 301, :zorder => 20)
    after(20) {
      @sparkle.turnify1
      after(100) {
        @sparkle.turnify2
        after(1500) {
          @sparkle.turnify3
          after(100) {
            @sparkle.turnify4
            after(100) {
              @sparkle.turnify5
              after(100) {
                @sparkle.turnify6
              }
            }
          }
        }
      }
    }
    after (4700) { push_game_state(Chingu::GameStates::FadeTo.new(Introduction.new, :speed => 10)) }
  end

  def intro
    push_game_state(Chingu::GameStates::FadeTo.new(Introduction.new, :speed => 10))
  end

  def draw
    Image["../media/assets/ruby-logo.png"].draw(0, 0, 0)
    super
  end
end


#
#  INTRODUCTION GAMESTATE
#
class Introduction < Chingu::GameState
  trait :timer
  def initialize
    super
    self.input = { [:enter, :return] => :next, :p => Pause, :r => lambda{current_game_state.setup} }
#    puts "Introduction"
  end

  def setup
    Chingu::Text.destroy_all
    Player.destroy_all
    EndPlayer.destroy_all
    Meteor.destroy_all
    $window.caption = "chinguroids"
    @counter = 0
    @count = 1
    @nxt = false
    @song_fade = false
    @fade_count = 0
    @knight = Knight.create(:x=>900,:y=>300)
    @click = Sound["media/audio/pickup_chime.ogg"]

    if $intro == false
      $music = Song["media/audio/music/intro_song.ogg"]
      $music.volume = 0.8
      $music.play(true)
    else
      $intro = false
    end

    after(600) {
      @text = Chingu::Text.create("Welcome to ChinguRoids", :y => 60, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange, :zorder => Zorder::GUI)
      @text.x = 800/2 - @text.width/2
      after(600) {
        @text2 = Chingu::Text.create("Press ENTER to play", :y => 510, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange, :zorder => Zorder::GUI)
        @text2.x =800/2 - @text2.width/2
        after(600) {
          @player = EndPlayer.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)
        }
      }
    }
  end
  
  def next
    if @nxt == true
      @nxt = false
      push_game_state(Level_1)
    else
      @nxt = true
      @click.play
      after(200) {
        if @text2 != nil; @text2.destroy; end
        after(200) {
          if @text != nil; @text.destroy; end
          after(200) {
            @count = 0
            @knight.movement
            after (1400) {
              @knight.speak
              after(3800) {
                @knight.enter_ship
                after(10) {
                  @song_fade = true
                  after(3000) {
                    $music.stop
                    push_game_state(Level_1)                    
                  }
                }
              }
            }
          }
        }
      }
    end
  end

def update
    super
    @counter += @count
    if @song_fade == true
      @fade_count += 1
      if @fade_count == 20
        @fade_count = 0
        $music.volume -= 0.1
      end
    end

    if(@counter >= 150)
      @random = rand(4)+1
      case @random
      when 1
        Meteor.create(x: rand(800)+1, y: 0,
                velocity_y: rand(5)+1, velocity_x: rand(-5..5),
                :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
      when 2
        Meteor.create(x: rand(800)+1, y: 600,
                velocity_y: rand(1..5)*-1, velocity_x: rand(-5..5),
                  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
      when 3
        Meteor.create(x: 0, y: rand(600)+1,
                velocity_x: rand(1..5), velocity_y: rand(-5..5),
                  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
      when 4
        Meteor.create(x: 800, y: rand(600)+1,
                velocity_x: rand(1..5)*-1, velocity_y: rand(-5..5),
                :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
      end
      @counter = 130
    end
    Meteor.destroy_if {|meteor| meteor.outside_window?}
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image: Raw Gosu Image.draw(x,y,zorder)-call
    super
  end
end

