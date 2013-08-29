

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
#   GAMEOVER GAMESTATE
#
class GameOver < Chingu::GameState
  def initialize
    super
    self.input = {:esc => :exit }#:enter => Introduction }
    @t1 = Chingu::Text.create(:text=>"You died." ,       :x=>266, :y=>180, :size=>28)
    @t2 = Chingu::Text.create(:text=>"Press enter" ,  :x=>266, :y=>280, :size=>28)
    @t1.x = 400 - @t2.width/2
    @t2.x = 400 - @t2.width/2
    $window.caption = "Game Over"
  end
end


#
#   WIN GAMESTATE
#
class Win < Chingu::GameState
  def initialize
    super
    @t1 = Chingu::Text.create(:text=>"You win." , :y=>180, :size=>28)
    @t1.x = 400 - @t1.width/2
    $window.caption = "You Win"
    @music = Song["media/audio/music/end_song.ogg"]
    @music.play(true)
    @music.volume = 0.5
  end
end



#
#  OPENING CREDITS GAMESTATE
#
class OpeningCredits < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => Introduction, :p => Pause, :r => lambda{current_game_state.setup} }
    @text = Chingu::Text.create("Press enter at any time", :y => 560, :font => "GeosansLight", :size => 16, :zorder => Zorder::GUI)
    @text.x = 800/2 - @text.width/2
    $music = Song["media/audio/music/title_song.ogg"]
    $music.volume = 0.8
    $music.play(true)
    after(600) {
      puts "Opening Credits"
      after(600) {
        push_game_state(Introduction)
      }
    }
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
    puts "Introduction"



    @click = Sound["media/audio/keypress.OGG"]
#    @text = Chingu::Text.create("Welcome to ChinguRoids", :y => 600/4, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange, :zorder => Zorder::GUI)
#    @text.x = 800/2 - @text.width/2

#    @text2 = Chingu::Text.create("Press ENTER to play", :y => 600/4+600/4, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange, :zorder => Zorder::GUI)
#    @text2.x =800/2 - @text2.width/2

#    @player = Player.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)
#    self.input = {:return => :next}
  end

  def setup
    Chingu::Text.destroy_all
    Player.destroy_all
    Meteor.destroy_all
    $window.caption = "chinguroids"
    @counter = 0
    after(600) {
      @text = Chingu::Text.create("Welcome to ChinguRoids", :y => 600/4, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange, :zorder => Zorder::GUI)
      @text.x = 800/2 - @text.width/2
      after(600) {
        @text2 = Chingu::Text.create("Press ENTER to play", :y => 600/4+600/4, :font => "GeosansLight", :size => 45, :color => Colors::Dark_Orange, :zorder => Zorder::GUI)
        @text2.x =800/2 - @text2.width/2
        after(600) {
          @player = Player.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)
        }
      }
    }
  end
=begin
  def pop
    if $window.current_game_state.to_s != "Pause" && $window.current_game_state.to_s != "GameOver" then
      if @ng == 0
        @ng = 13
      else
        @ng -= 1
      end
    end
    if $window.current_game_state.to_s != "Introduction" then
      pop_game_state(:setup => false)
    end
    if $window.current_game_state.to_s == "Introduction" then
      @ng = -1
    end
  end
=end
  def update
    super
    @counter += 1

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

  def next
    @click.play
    $music.stop
    push_game_state(Level_1)
  end
end




#
#   WELCOME GAMESTATE
#
class Welcome < Chingu::GameState
  def initialize
    super
    self.input = { #:holding_space => :new_fire_cube,
                   #:left => :decrease_speed,
                   #:right => :increase_speed,
                   #:up => :increase_size,
                   #:down => :decrease_size,
                   :p => Pause    }

    #@t00 = Chingu::Text.create(:text=>"loader" ,         :x=>344, :y=>130, :size=>44)
#    @t01 = Chingu::Text.create(:text=>"local controls" ,     :x=>100, :y=>230, :size=>28)
    @t02 = Chingu::Text.create(:text=>"    spacebar" ,       :x=>266, :y=>180, :size=>28)
    @t03 = Chingu::Text.create(:text=>"   arrow keys" ,      :x=>266, :y=>220, :size=>28)
    @t04 = Chingu::Text.create(:text=>"enter       -         next gamestate" ,       :x=>308, :y=>260, :size=>28)
    @t05 = Chingu::Text.create(:text=>"P           -         pause  " ,              :x=>324, :y=>300, :size=>28) 
    @t06 = Chingu::Text.create(:text=>"R           -         reset  " ,              :x=>323, :y=>340, :size=>28)
    @t07 = Chingu::Text.create(:text=>"Z           -         status log" ,           :x=>324, :y=>380, :size=>28)
    @t08 = Chingu::Text.create(:text=>"Q           -         previous gamestate" ,   :x=>322, :y=>420, :size=>28)
    @t09 = Chingu::Text.create(:text=>"esc         -         exit" ,                 :x=>314, :y=>460, :size=>28)
#    @t10 = Chingu::Text.create(:text=>"global controls" ,    :x=>100, :y=>390, :size=>28)
  end

  def setup
    $window.caption = "chinguroids"
  end
end
