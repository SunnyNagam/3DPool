class Table
{
 Stick st;
 Ball balls[];
 Ball cue;
 int wid=0,hei=0;
 int rad = 40;
 PImage background;
 PImage background_theme;
 PImage woodImg;
 boolean holed[] = new boolean[15];
 double triggered[] = new double[15];
 boolean cueDrag = false, gameOver = false;
 
 int scoreA = 0;
 int border = 30;
 int powerLevel=0;
 
 boolean themed = false;
 PImage cue_theme;
 PImage cue_theme_hit;
 
 AudioPlayer ballHit;
 Minim minim;
 
 Ball hole[];
 
 Table(int w, int h){
   
   wid = w;
   hei = h;
   
   background =       loadImage("Felt.jpg");
   woodImg =          loadImage("Wood.png");
   background_theme = loadImage("ElectoralMapTrump.gif");
   cue_theme =        loadImage("DonaldTrump.png");
   cue_theme_hit =    loadImage("DonaldTrumpTriggered.png");
   
   
   
   balls = new Ball[15];
   st = new Stick();
   
  int count = 1, y=wid-500, nx=1;
  
  for(int x=0; x<balls.length; x++,nx++){
    balls[x] = new Ball(y,(hei-(count*rad))/2 + rad*nx -rad/2,0,0);
    if(nx%count==0){
      nx=0;
      count++;
      y+=rad;
    }
  }
  
  cue = new Ball(200,hei/2,0,0);
  cue.col = color(255,255,255);
  
  hole = new Ball[6];
  for(int x=0; x<2; x++){
    for(y=0; y<3; y++){
      
      hole[x*3+y] = new Ball(y*wid/2,hei*x,0,0);
      hole[x*3+y].col = color(0);
      hole[x*3+y].rad = 50;
      if(y==0)
        hole[x*3+y].loc.add(50,x==0?50:-50);
      else if(y==2)
        hole[x*3+y].loc.add(-50,x==0?50:-50);
      else
        hole[x*3+y].loc.add(0,x==0?25:-25);
      
    }
  }
 }
 
 void drawTable(){
   lights();
  noStroke();
  fill(255);
  image(background,0,0,wid,hei);
  tint(255,scoreA*255/15);
  if(themed)
    image(background_theme,0,0,wid,hei);
  noTint();
  cue.drawBall();
  if(themed)
      cue.drawBall(cue_theme);
  for(int x=0; x<balls.length; x++){
    balls[x].drawBall();
    if(themed){
      if(System.nanoTime() - triggered[x] >=1000000000)
        triggered[x] = -1;
      balls[x].drawBall(triggered[x]!=-1?cue_theme_hit:cue_theme);
    }
  }
    
  fill(150);
  
  // Drawing the wood table 
  draw3dImg(woodImg,0,0,0,0,0,border,0,0,wid,border);
  draw3dImg(woodImg,PI/2,0,0,0,0,0,0,0,wid,border);
  draw3dImg(woodImg,PI/2,0,0,0,border,0,0,0,wid,border);
  
  draw3dImg(woodImg,0,PI/2,0,0,0,border,0,0,wid,border);
  draw3dImg(woodImg,0,PI/2,0,border,0,border,0,0,wid,border);
  draw3dImg(woodImg,PI/2,0,-PI/2,0,0,0,0,0,wid,border);
  draw3dImg(woodImg,PI/2,0,-PI/2,0,border,0,0,0,wid,border);
  
  draw3dImg(woodImg,0,0,0,0,0,border,0,0,border,hei);
  draw3dImg(woodImg,0,-PI/2,0,0,0,0,0,0,border,hei);
  draw3dImg(woodImg,0,-PI/2,0,border,0,0,0,0,border,hei);
  
  draw3dImg(woodImg,0,0,0,0,hei-border,border,0,0,wid,border);
  draw3dImg(woodImg,PI/2,0,0,0,hei-border,0,0,0,wid,border);
  draw3dImg(woodImg,PI/2,0,0,0,hei,0,0,0,wid,border);
  
  //draw3dImg(woodImg,0,PI/2,0,0,hei-border,border,0,0,wid,border);
  //draw3dImg(woodImg,0,PI/2,0,border,hei-border,border,0,0,wid,border);
  //draw3dImg(woodImg,PI/2,0,-PI/2,0,0,hei-border,0,0,wid,border);
  //draw3dImg(woodImg,PI/2,0,-PI/2,0,0,hei,0,0,wid,border);
  
  draw3dImg(woodImg,0,0,0,wid-border,0,border,0,0,border,hei);
  draw3dImg(woodImg,0,-PI/2,0,wid-border,0,0,0,0,border,hei);
  draw3dImg(woodImg,0,-PI/2,0,wid,0,0,0,0,border,hei);
  
  fill(0);
  for(int x=0; x<hole.length; x++){
    pushMatrix();
    translate(0,0,1);
    if(x==1||x==4)
    arc(hole[x].loc.x,hole[x].loc.y,hole[x].rad*2,hole[x].rad*2,x==1?0:-PI,x==1?PI:0);
    else
    ellipse(hole[x].loc.x,hole[x].loc.y,hole[x].rad*2,hole[x].rad*2);
    popMatrix();
  }
  
  st.drawStick();
 }
 void loadSounds(){
   ballHit = minim.loadFile("Bounce.wav");
 }
 void draw3dImg(PImage p,float rx, float ry, float rz, float tx, float ty, float tz, float sx, float sy, float scalex, float scaley){
   pushMatrix();
   translate(tx,ty,tz);
  rotateX(rx);
  rotateY(ry);
  rotateZ(rz);
  image(p,sx,sy,scalex,scaley);
  popMatrix();
 }
 void updateTable(){
   st.end = cue.loc.copy().sub(new PVector(mouse.x,mouse.y));
   float sc = st.length/st.end.mag();
   st.end = cue.loc.copy().sub(st.end.mult(sc));
   st.start = cue.loc.copy();//.sub(st.end.copy().mult(1/st.end.mag()));
   //st.end= cue.loc.copy().sub(cue.loc.copy().sub(new PVector(mouseX,mouseY))).add(st.end);

   
   //Check collisions with cue ball and other balls
  for(int x=0; x<balls.length; x++)
    if(checkColl(cue,balls[x])){
      collide(cue,balls[x]);
      ballHit.rewind();
      ballHit.play();
      if(themed)
        triggered[x] = System.nanoTime();
        
      break;
    }
      cue.update(wid,hei,border);
  
  powerLevel = (int)new PVector(mouse.x,mouse.y).sub(cue.loc).mult(1.0/(width/160.0)*-1).mag();
  if(powerLevel>20)
    powerLevel = 20;
  
  
  // Check collisions of balls with eachother
  for(int x=0; x<balls.length; x++){
    for(int y=x+1; y<balls.length; y++)
      if(checkColl(balls[y],balls[x])){
        collide(balls[y],balls[x]);
        ballHit.rewind();
      ballHit.play();
        if(themed){
          triggered[x] = System.nanoTime();
          triggered[y] = System.nanoTime();
        }
      }
      balls[x].update(wid,hei,border);
  }
  
  // Update all the balls and move them
  
  //for(int x=0; x<balls.length; x++)
    
    
    
  //Check collisions with holes
  for(int x=0; x<hole.length; x++){
    for(int y=0; y<balls.length; y++)
      if(checkColl(hole[x],balls[y])){
        deleteBall(y);
        scoreA++;
        if(scoreA==15)
          gameOver = true;
        y--;
      }
    if(checkColl(hole[x],cue)){
      gameOver = true;
      cue.speed.mult(0);
      cue.rad =0;
    }
  }
  
}
void deleteBall(int ind){
  for(int x = ind; x<balls.length-1; x++)
    balls[x] = new Ball(balls[x+1]);
  balls= (Ball[])shorten(balls);
}

boolean checkColl(Ball x, Ball y){
  float dx = (x.loc.x+x.speed.x)-(y.loc.x+y.speed.x);
  float dy = (x.loc.y+x.speed.y)-(y.loc.y+y.speed.y);
  return dx*dx+dy*dy< (x.rad+y.rad)*(x.rad+y.rad);
}

void collide4(Ball a, Ball b){
  //PVector dif = a.loc.copy().sub(b.loc);
  //float k = a.speed.copy().sub(b.speed).dot(dif)/dif.magSq();
  float k = ((a.speed.x-b.speed.x)*(a.loc.x-b.loc.x)+(a.speed.y-b.speed.y)*(a.loc.y-b.loc.y))/((a.loc.x-b.loc.x)*(a.loc.x-b.loc.x)+(a.loc.y-b.loc.y)*(a.loc.y-b.loc.y));
  float dx = a.loc.x - b.loc.x;
  float dy = a.loc.y - b.loc.y;
  a.speed.x -= k*dx;
  a.speed.y -= k*dy;
  b.speed.x += k*dx;
  b.speed.y += k*dy;
}

void collide(Ball a, Ball b){
  PVector dif = a.loc.copy().sub(b.loc);
  float k = a.speed.copy().sub(b.speed).dot(dif)/dif.magSq();
  a.speed.sub(dif.mult(k));
  b.speed.add(dif);
}

void pressed(){
  cueDrag = true;
}

void released(){
  cueDrag = false;
  PVector spedAdd  = new PVector(mouse.x,mouse.y).sub(cue.loc).mult(1.0/(width/160.0)*-1);
  if(spedAdd.mag()>20)
    spedAdd.mult(20/spedAdd.mag());
  cue.speed.add(spedAdd);
}

}