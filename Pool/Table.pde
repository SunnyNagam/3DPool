class Table
{
 Stick st;
 Ball balls[];
 Ball cue;
 int wid=0,hei=0;            // Width and height of game field
 int rad = 40;                // Standard radius
 PImage background;            // Images used in game
 PImage floor;
 PImage background_theme;
 PImage woodImg;
 
 double triggered[] = new double[15];              // Array to hold time since balls have been hit, used only for the theme mode to change picture of face
 boolean gameOver = false;        // If game is over
 
 int scoreA = 0, scoreB = 0;      //Scores for players A and B respectively
 int scoreBefore =0;              //Value to hold total score before turn is taken to determine next turn
 int border = 30;                 // border width of the wood around the table
 int powerLevel=10;               // power level of stick
 int turn = 1;                    // Turn number the game is currently on
 
 boolean themed = false;          // Boolean value to hold if game is currently themed or not
 PImage cue_theme;                // Themed images 
 PImage cue_theme_hit;  
 
 AudioSample ballHit;             //Ball collision sound
 Minim minim;
 
 Ball hole[];                     // Holes evaluate as balls
 
 Table(int w, int h){                          // Table constructor given width and height of display of game
   
   wid = w;
   hei = h;
   
   background =       loadImage("Felt.jpg");                  // Loading image resourses 
   floor =       loadImage("Floor.jpg");
   woodImg =          loadImage("Wood.png");
   background_theme = loadImage("ElectoralMapTrump.gif");
   cue_theme =        loadImage("DonaldTrump.png");
   cue_theme_hit =    loadImage("DonaldTrumpTriggered.png");
   
   
   
   balls = new Ball[15];  
   st = new Stick();
   
  int count = 1, y=wid-500, nx=1;
  for(int x=0; x<balls.length; x++,nx++){                                      //Initalizing the balls in correct location
    balls[x] = new Ball(y,(hei-(count*rad))/2 + rad*nx -rad/2,0,0);
    if(nx%count==0){
      nx=0;
      count++;
      y+=rad;
    }
  }
  
  balls[0].col = color(#F6FF03);        // Setting colors of the balls
  balls[1].col = color(#4D21FF);
  balls[2].col = color(#B23D3D);
  balls[3].col = color(#60EA2B);
  balls[4].col = color(#0A0A0A);
  balls[5].col = color(#FFAF0D);
  balls[6].col = color(#F6FF03);
  balls[7].col = color(#FFAF0D);
  balls[8].col = color(#FF2015);
  balls[9].col = color(#B34CD8);
  balls[10].col = color(#FF2015);
  balls[11].col = color(#60EA2B);
  balls[12].col = color(#B34CD8);
  balls[13].col = color(#4D21FF);
  balls[14].col = color(#B23D3D);
  
  cue = new Ball(200,hei/2,0,0);        // Initalizing cue ball
  cue.col = color(255,255,255);    
  
  hole = new Ball[6];          // Inializing holes in correct locations 
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
  
  image(background,0,0,wid,hei);          // Drawing felt background
  
  translate(0,0,-wid/2);                  // Drawing floor and tiling floor image repeatedly
  beginShape();
  texture(floor);
  textureMode(NORMAL);
  textureWrap(REPEAT); 
  vertex(-6000,-6000,0,0);
  vertex(6000,-6000,3,0);
  vertex(6000,6000,3,3);
  vertex(-6000,6000,0,3);
  endShape();
  translate(0,0,wid/2);
  
  tint(255,(scoreA+scoreB)*255/15);                    //Drawing themed background map
  if(themed)
    image(background_theme,0,0,wid,hei);
  noTint();
  
  cue.drawBall();
  if(themed)
      cue.drawBall(cue_theme);
      
  for(int x=0; x<balls.length; x++){          //Drawing each ball
    balls[x].drawBall();
    if(themed){
      if(System.nanoTime() - triggered[x] >=1000000000)              // if themed sets time since hit and draws image based on time since hit
        triggered[x] = -1;
      balls[x].drawBall(triggered[x]!=-1?cue_theme_hit:cue_theme);
    }
  }
  
  drawWood();                // draws 3d wooden frame model on table
  
  fill(0);
  for(int x=0; x<hole.length; x++){        //Drawing each hole
    pushMatrix();
    translate(0,0,1);
    if(x==1||x==4)          // Semi circle for middle holes
      arc(hole[x].loc.x,hole[x].loc.y,hole[x].rad*2,hole[x].rad*2,x==1?0:-PI,x==1?PI:0);
    else
      ellipse(hole[x].loc.x,hole[x].loc.y,hole[x].rad*2,hole[x].rad*2);
    popMatrix();
  }
  
  st.drawStick();
 }
 
/*
    Loads sound files into variables.
*/
 void loadSounds(){
   ballHit = minim.loadSample("Bounce.wav");
 }
 
/*
    Draws a given image after transalting, roating, and scaling it based on given parameters
    @param  PImage p: Image to draw
    @param  float rx:  rotation on the x-axis
    @param  float ry:  rotation on the y-axis
    @param  float rz:  rotation on the z-axis
    @param  float tx:  translation horizontally
    @param  float ty:  translation vertically
    @param  float tz:  translation along z-axis
    @param  float scalex: new width of image after scaling
    @param  float scaley: new height of image after scaling
*/
 void draw3dImg(PImage p,float rx, float ry, float rz, float tx, float ty, float tz,float scalex, float scaley){
  pushMatrix();
  translate(tx,ty,tz);
  rotateX(rx);
  rotateY(ry);
  rotateZ(rz);
  image(p,0,0,scalex,scaley);
  popMatrix();
 }
 
 void updateTable(){
   st.end = cue.loc.copy().sub(new PVector(mouse.x,mouse.y));                      // updates stick's start and end locations
   st.end = new PVector(mouse.x,mouse.y).sub(st.end.normalize().mult(st.length));
   st.start = new PVector(mouse.x,mouse.y);
   
   //Check collisions with cue ball and other balls
  for(int x=0; x<balls.length; x++)
    if(checkColl(cue,balls[x])){
      collide(cue,balls[x]);
      ballHit.trigger();
      if(themed)
        triggered[x] = System.nanoTime();
        
      break;
    }
  cue.update(wid,hei,border);        // updates cue ball
  
  // Check collisions of balls with all other balls and updates each one
  for(int x=0; x<balls.length; x++){
    for(int y=x+1; y<balls.length; y++)
      if(checkColl(balls[y],balls[x])){
        collide(balls[y],balls[x]);
        ballHit.trigger();
        if(themed){
          triggered[x] = System.nanoTime();
          triggered[y] = System.nanoTime();
        }
      }
      balls[x].update(wid,hei,border);
  }
  
  //Check collisions with holes
  for(int x=0; x<hole.length; x++){
    for(int y=0; y<balls.length; y++)        
      if(checkColl(hole[x],balls[y])){      // Check if each ball is in hole and if so adjust players score accordingly
        deleteBall(y);    //deletes ball
        if(turn%2==0)
          scoreA++;
        else
          scoreB++;
        if(scoreA+scoreB==15)    
          gameOver = true;
        y--;
      }
    if(checkColl(hole[x],cue)){             // Checks if cue is in hole and ends game
      gameOver = true;
      cue.speed.mult(0);    //Stops ball
    }
  }
  
}
/*
    Function that deletes a ball fromt the global balls array given index of ball to delete
    @param  int ind: index of ball to delete from array balls
*/
void deleteBall(int ind){
  for(int x = ind; x<balls.length-1; x++)      //Copy over every ball except one that must be deleted and shorten array to delete it
    balls[x] = balls[x+1];
  balls= (Ball[])shorten(balls);
}

/*  Function calculates if two given balls (Ball x and Ball y) are colliding 
    by checking if they are intersecting and if they are moving towards
    eachother.
    @param Ball a: A ball to check collision with
    @param Ball b: Another ball to check collision with ball a
    @return boolean representing if balls x and y are colliding
*/
boolean checkColl(Ball x, Ball y){                          // Checks if balls are colliding
  return x.loc.copy().sub(y.loc).mag() < x.rad+y.rad   // if balls are intersecting
      && y.speed.copy().sub(x.speed).dot(x.loc.copy().sub(y.loc)) > 0;    // and if balls are moving towards eachother
}

/*
*      Changes velocities of two given Balls as they collide
*      @param Ball a: One of the balls involved in collison
*      @param Ball b: The other ball involved in collison
*/
void collide(Ball a, Ball b){
  PVector dif = a.loc.copy().sub(b.loc);
  float k = a.speed.copy().sub(b.speed).dot(dif)/dif.magSq();
  a.speed.sub(dif.mult(k));                          // Adjusts speeds of a and b according to collision
  b.speed.add(dif);
}

/*
*      Changes powerlevel based on mouseWheel input
*      @param int count: mouseWheel count
*/
void changePower(int count){
  table.powerLevel+=count;              
  if(table.powerLevel>20)          //Changes power with max of 20 and min of 1
    table.powerLevel = 20;
  else if(table.powerLevel<1)
    table.powerLevel = 1;
}

void pressed(){    // Occurs when user clicks in the game
}
/*
*      If cueball is clicked then recalculates current turn and hits cue ball to change it's speed.
*/
void released(){
  if(new PVector(mouse.x,mouse.y).sub(cue.loc).mag()>cue.rad*2)      // If mouse is not clicked on cue ball quits function
    return;
    
  if(scoreA+scoreB==scoreBefore)          // Calculating change in turn
    turn++;
  scoreBefore = scoreA+scoreB;
  
  PVector spedAdd  = new PVector(mouse.x,mouse.y).sub(cue.loc);          // Changes speed of cueball based on mouse location and powerlevel 
  spedAdd.mult(-powerLevel/spedAdd.mag());
  cue.speed.add(spedAdd);
  ballHit.trigger();        // Plays ball hitting sound
}

/*
*      Function that draws 3-dimentional wooden table frame through printing a long image through various transformations, rotations, and scales.
*/
void drawWood(){
  // Drawing the wood table 
  draw3dImg(woodImg,0,0,0,0,0,border,wid,border);      // drawing walls on top
  draw3dImg(woodImg,PI/2,0,0,0,0,0,wid,border);
  draw3dImg(woodImg,PI/2,0,0,0,border,0,wid,border);
  
  draw3dImg(woodImg,0,0,0,0,0,border,border,hei);
  draw3dImg(woodImg,0,-PI/2,0,0,0,0,border,hei);
  draw3dImg(woodImg,0,-PI/2,0,border,0,0,border,hei);
  
  draw3dImg(woodImg,0,0,0,0,hei-border,border,wid,border);
  draw3dImg(woodImg,PI/2,0,0,0,hei-border,0,wid,border);
  draw3dImg(woodImg,PI/2,0,0,0,hei,0,wid,border);
  
  draw3dImg(woodImg,0,0,0,wid-border,0,border,border,hei);
  draw3dImg(woodImg,0,-PI/2,0,wid-border,0,0,border,hei);
  draw3dImg(woodImg,0,-PI/2,0,wid,0,0,border,hei);
  
  wid /=2;
  
 for(int x=0, wt = hudX-border, ht = hei - border; x<2; x++)          // Drawing wooden legs
    for(int y=0; y<2; y++){
      pushMatrix();
      translate(x*wt,y*ht);
      draw3dImg(woodImg,0,PI/2,0,0,0,border,wid,border);
      draw3dImg(woodImg,0,PI/2,0,border,0,border,wid,border);
      draw3dImg(woodImg,PI/2,0,-PI/2,0,0,0,wid,border);
      draw3dImg(woodImg,PI/2,0,-PI/2,0,border,0,wid,border);
      popMatrix();
    }
    
  wid*=2;
}

}