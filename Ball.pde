class Ball{
  float rad = 20;
  PVector speed;
  PVector loc;
  color col;
  
  public Ball(){
    speed = new PVector();
    loc = new PVector();
    col = color(random(0,255),random(0,255),random(0,255));
  }
  public Ball(Ball clone){
    speed= new PVector(clone.speed.x,clone.speed.y);
    loc= new PVector(clone.loc.x,clone.loc.y);
    col = color(clone.col);
  }
  public Ball(float x, float y, float dx, float dy){
    speed = new PVector(dx,dy);
    loc = new PVector(x,y);
    col = color(random(0,255),random(0,255),random(0,255));
  }
  
  public void update(int wid, int hei, int bord){
  if(loc.x+rad>wid-bord || loc.x-rad<0+bord){
    table.ballHit.rewind();
    table.ballHit.play();
    speed.x*=-0.7;
    if(loc.x+rad>wid-bord)
      loc.x = wid-bord-rad;
    else
      loc.x = bord+rad;
  }
  if(loc.y+rad>hei-bord || loc.y-rad<0+bord){
    speed.y*=-0.7;
    table.ballHit.rewind();
    table.ballHit.play();
    if(loc.y+rad>hei-bord)
      loc.y = hei-bord-rad;
    else
      loc.y = bord+rad;
  }
  
  loc.add(speed);
  
  //if(speed.mag()!=0)
  //  speed.mult(1-(0.01*10/speed.mag()));
  float spFac = 20-speed.mag();
  speed.mult((spFac>0)?(float)Math.pow(0.986,(spFac)/5):0.986);
  }
  public void drawBall(){
    fill(col);
    
    pushMatrix();
      translate(loc.x,loc.y,rad+loc.z);
      sphere(rad);
    //ellipse(loc.x,loc.y,rad,rad);
    popMatrix();
  }
  public void drawBall(PImage theme){
    pushMatrix();
      translate(0,0,rad*2+loc.z);
      image(theme,loc.x-rad, loc.y-rad, 
      rad*2,rad*2);
    popMatrix();
  }
}