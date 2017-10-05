class Ball{
  float rad = 20;      // Radius of ball
  PVector speed;       
  PVector loc;          // Location of ball
  color col;
  
  public Ball(){                  // Default constructor for ball
    speed = new PVector();
    loc = new PVector();
    col = color(random(0,255),random(0,255),random(0,255));
  }
  public Ball(float x, float y, float dx, float dy){          // Constructor for ball with x and y coordinates for location and dx and dy values for speed in x and y direction
    speed = new PVector(dx,dy);
    loc = new PVector(x,y);
    col = color(random(0,255),random(0,255),random(0,255));
  }
  
  /*
  *      Updates Ball given width and height of display and width of border around table
  */
  void update(int wid, int hei, int bord){
    if(loc.x+rad>wid-bord || loc.x-rad<0+bord){      // Bounces ball off of walls of table if hit and plays sound
      table.ballHit.trigger();
      speed.x*=-0.7;
      if(loc.x+rad>wid-bord)
        loc.x = wid-bord-rad;
      else
        loc.x = bord+rad;
    }
    if(loc.y+rad>hei-bord || loc.y-rad<0+bord){
      speed.y*=-0.7;
      table.ballHit.trigger();
      if(loc.y+rad>hei-bord)
        loc.y = hei-bord-rad;
      else
        loc.y = bord+rad;
    }
    
    loc.add(speed);          // Updating the location based on the code.
    
    float spFac = 20-speed.mag();                                      // Slowing down the ball with friction and deceleration
    speed.mult((spFac>0)?(float)Math.pow(0.986,(spFac)/7):0.986);
  }
  
  /*
  *      Draws Ball
  */
  void drawBall(){
    fill(col);
    
    pushMatrix();
      translate(loc.x,loc.y,rad+loc.z);      // Moving to correct location
      sphere(rad);                           // Drawing sphere 
    popMatrix();
  }
  /*
  *      Draws given image on top of ball 
  *      @param PImage theme: Image to draw
  */
  void drawBall(PImage theme){
    pushMatrix();
      translate(0,0,rad*2+loc.z);
      image(theme,loc.x-rad, loc.y-rad, rad*2,rad*2);
    popMatrix();
  }
}