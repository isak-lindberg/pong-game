require 'gosu'

# Min class, under denna har jag alla mina funktioner osv.
class Pong < Gosu::Window
  # Initialize, definierar alla mina variabler, bestämmer storleken av spelrutan, bestämmer min font osv.
  def initialize
    @score_font = Gosu::Font.new(30)
    super 600, 600
    self.caption = "Pong"

    @ball_x = 300
    @ball_y = 300
    @ball_x_velocity = 4
    @ball_y_velocity = 4

    @player1_y = 250
    @player2_y = 250

    @player1_velocity = 5
    @player2_velocity = 5

    @player1_height = 50
    @player2_height = 50

    @player1_score = 0
    @player2_score = 0

    @times_hit = 0
  end

  def update
    #Uppdaterande funktionen, denna uppdateras under spelets gång.
    @ball_x += @ball_x_velocity
    @ball_y += @ball_y_velocity
    #Detta är bollens rörelse, för varje gång update körs ändras bollens x och y position med hastigheten 
    #den har i dessa riktningar.

    if @ball_y > 580 || @ball_y < 20
      @ball_y_velocity = -@ball_y_velocity
    end
    #Ifall bollen studsar i taket eller botten byts dess hastighet i y-led mot negativa hastigheten i y-led; 
    #den studsar.

    if @ball_x < 30 && @ball_y > @player1_y && @ball_y < @player1_y + 50
      section_of_player1 = ((@ball_y - @player1_y) / (@player1_height / 5)).floor
      @ball_y_velocity = section_of_player1 - 2
      @ball_x_velocity = -@ball_x_velocity
      @ball_x_velocity += 1
      @times_hit += 1
    end

    if @ball_x > 570 && @ball_y > @player2_y && @ball_y < @player2_y + 50
      section_of_player2 = ((@ball_y - @player2_y) / (@player2_height / 5)).floor
      @ball_y_velocity = section_of_player2 - 2
      @ball_x_velocity = -@ball_x_velocity
      @ball_x_velocity -= 1
      @times_hit += 1
    end
    #De här två if satserna över gör så att bollen har kollision med båda spelarna. Vad den säger är att om 
    #bollen är under eller över värdet av spelaren i x-led, som är konstant, och bollen är större än spelarens
    #lägsta y-värde och mindre än spelarens högsta y-värde (spelaren har en höjd) så ska bollen kollidera och
    #studsa (x-värdet inverteras) och variabeln times_hit blir en större. Jag delar även här upp spelaren i
    #5 olika delar och kollar vart på spelaren bollen träffade, vilket påverkar åt vilket håll i y-led bollen
    #studsar.

    if @ball_x < 0
      @player2_score += 1
      @ball_x = rand(250..350)
      @ball_y = rand(250..350)
      velocity_x1 = [-4, 4]
      @ball_x_velocity = velocity_x1.sample
      @ball_y_velocity = rand(-2..2)
      @times_hit = 0
    end

    if @ball_x > 600
      @player1_score += 1
      @ball_x = rand(250..350)
      @ball_y = rand(250..350)
      velocity_x2 = [-4, 4]
      @ball_x_velocity = velocity_x2.sample
      @ball_y_velocity = rand(-2..2)
      @times_hit = 0
    end
    #Här bestämmer jag vad som händer när spelaren inte lyckas ta bollen och den åker ut ur planen,
    #spelaren som vann får ett poäng, bollen sätts någonstans i mitten och åker på slump åt något av hållen.
    #times_hit variabeln sätts tillbaka till 0.

    if button_down?(Gosu::KB_W)
      @player1_y -= @player1_velocity + (@times_hit * 0.1)
    end

    if button_down?(Gosu::KB_S)
      @player1_y += @player1_velocity + (@times_hit * 0.1)
    end

    if button_down?(Gosu::KB_UP)
      @player2_y -= @player2_velocity + (@times_hit * 0.1)
    end

    if button_down?(Gosu::KB_DOWN)
      @player2_y += @player2_velocity + (@times_hit * 0.1)
    end
    #Om man trycker ner tangenterna så rör sig spelaren i y-led, spelaren rör sig lite snabbare beroende på
    #hur många gånger bollen träffats för att hinna ikapp bollen som går snabbare och snabbare.
  end

  def draw
    draw_quad(10, @player1_y, Gosu::Color::WHITE,
              10, @player1_y + 50, Gosu::Color::WHITE,
              20, @player1_y + 50, Gosu::Color::WHITE,
              20, @player1_y, Gosu::Color::WHITE)

    draw_quad(580, @player2_y, Gosu::Color::WHITE,
              580, @player2_y + 50, Gosu::Color::WHITE,
              590, @player2_y + 50, Gosu::Color::WHITE,
              590, @player2_y, Gosu::Color::WHITE)

    draw_quad(@ball_x - 10, @ball_y - 10, Gosu::Color::WHITE,
              @ball_x - 10, @ball_y + 10, Gosu::Color::WHITE,
              @ball_x + 10, @ball_y + 10, Gosu::Color::WHITE,
              @ball_x + 10, @ball_y - 10, Gosu::Color::WHITE)
    
    draw_rect(10, 10, 50, 30, Gosu::Color::GREEN, 0)
    draw_rect(550, 10, 50, 30, Gosu::Color::GREEN, 0)
              @score_font.draw_text(@player1_score.to_s, 10, 10, 1, 1, 1, Gosu::Color::BLACK)
              @score_font.draw_text(@player2_score.to_s, 550, 10, 1, 1, 1, Gosu::Color::BLACK)
  end
  #Målar all grafik, inget särskikt värt att kommentera.
end

Pong.new.show
#Sätter igång programmet.