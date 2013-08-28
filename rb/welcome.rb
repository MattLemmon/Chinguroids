#
#   WELCOME SCREEN GAMESTATE
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

=begin
  def new_fire_cube
    FireCube.create(:x => rand($window.width - 400), :y => rand($window.height - 300))
  end
  def increase_size
    FireCube.each { |go| go.factor += 1 }
  end
  def decrease_size
    FireCube.each { |go| go.factor -= 1 if go.factor > 1  }
  end
  def increase_speed
    FireCube.each { |go| go.velocity_x *= 4; go.velocity_y *= 4; }
  end
  def decrease_speed
    FireCube.each { |go| go.velocity_x *= 0.25; go.velocity_y *= 0.25; }
  end
=end
