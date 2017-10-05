/*    
*     Pool Game
*     Sunny (Satwik) Nagam  
*     Eng 233
*/
import ddf.minim.*;
Table table;                                      // Table where game is played
int hudX = 1100;                                  // x value at which menu begins, also represents width of game not inclding the menu on the right
float rotX, rotZ, zoomlvl;                        // Values to hold current rotation and zoom level, controled by keys: W,A,S,D,Q,E
boolean[] keypress;                              // Boolean array where keypress[x] holds wheather keyboard key with char value x is being pressed
Button button[];                                 // Buttons 
PVector mouse = new PVector(mouseX,mouseY);      // Vector to hold mouseX and mouseY values after being corrected for 3d rotations
float cameraZin;                                // Camera's inital z position, used to correct mouse movement in 3d
double timer = 0, timeLimit = 0;                // Values to hold starting time of game and time limit.

void setup(){
  size(1400,600,P3D);
  rotX=0;                                        // sets rotation and zom levels to default 0
  rotZ=0;
  zoomlvl=-3;
  
  keypress = new boolean[128];   
  table = new Table(hudX,600);              // initalizes table
  table.minim = new Minim(this);            // creates Minim in table with this class as parent
  table.loadSounds();                       // loads sound files into variables
  button = new Button[3];
  button[0] = new Button(hudX+20,380,260,80,"Make Pool Great Again");          // Iniitalizes buttons with locations and titles 
  button[1] = new Button(hudX+20,480,100,80,"Restart");
  button[2] = new Button(hudX+20+160,480,100,80,"Center");
                                                                
  cameraZin = ((height/2.0) / tan(PI*60.0/360.0));                              // calculates current distance in z direction (how far camera is initally away from table)
                                                                                // which is used to help correct mouse location in 3d after rotations
  
  float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));                          // Increases the max rendering distance
  perspective(PI/3, 1.0*width/height, cameraZ/10.0, cameraZ*100.0);

  timer = millis();                                                             // initalizes start time in 'timer' and the time limit to 5 minures 
  timeLimit = 60*5+1;    // 5 min, (+1 for a second for code to start)
}
/*    
*     Transforms and rotates the mouse vector position to correct for 3d transformations of camera.
*/
void calcMouse(){ 
  PVector cent = new PVector(hudX/2,height/2);            // Corrects mouse rotation and zoom
  mouse.set(mouseX,mouseY).sub(cent);
  mouse.rotate(-rotZ);
  mouse.add(cent);
  mouse.x = ((1.0/tan(PI/6))*width*(mouse.x-width/2))/(20*zoomlvl+(1.0/tan(PI/6))*width)+width/2;
  mouse.y = ((1.0/tan(PI/14))*height*(mouse.y-height/2))/(20*zoomlvl+(1.0/tan(PI/14))*height)+height/2;
                                                                                                                                                                                                                                                mouse.y = (sqrt(3)*height*(mouse.y-height/2))/(20*zoomlvl+sqrt(3)*height)+height/2;
  pushMatrix();
  translate(hudX/2,height/2);
  translate(0,0,zoomlvl*10);
  rotateX(rotX);
  rotateZ(rotZ);
  translate(-hudX/2,-height/2);
  fill(0,0,255);
  ellipse(mouse.x, mouse.y,20,20);            // draws where mouse is registered on the table as a blue circle
  popMatrix();
}
void draw(){
  background(#12CDFF);
  lights();                // Add lighting to 3d space
  calcMouse();            // Corrects mouse posiiton 
  checkKeys();
  
  pushMatrix();
  translate(hudX/2,height/2);                  // move and rotate based on user input
  translate(0,0,zoomlvl*10);
  rotateX(rotX);
  rotateZ(rotZ);
  
  translate(-hudX/2,-height/2);
  
  table.drawTable();                           // Display and update table
  table.updateTable();
  popMatrix();
  noLights();
  
                                                //Drawing score, buttons and User interface/menus on the right
  hint(DISABLE_DEPTH_TEST);      // Prints right infrount of camera, ignoring Z axis
  fill(255);
  pushMatrix();
  translate(hudX,0);
  rect(0,0,width-hudX,height);
  fill(0);
  textSize(26);
  textAlign(CENTER);                            // Center text at x coordinate
  float mid = (width-hudX)/2;
  
  int greenTurn = (table.scoreA+table.scoreB!=table.scoreBefore)?(table.turn+1)%2:(table.turn)%2;          // Determine who's turn it currently is depending on if they scored this turn
  fill(0,greenTurn*255,0);
  text("Player A "+(table.themed?"States: ":"Score: ")+table.scoreA,mid,40);          // Displaying Current Score
  fill(0,(greenTurn+1)%2*255,0);
  text("Player B "+(table.themed?"States: ":"Score: ")+table.scoreB,mid,70);
  fill(0);
  
  text("Power: "+table.powerLevel,mid,120);                               // Displaying current power level
  
  int timeLeft = (int)(timeLimit-((millis()-timer)/1000));                // Calculates Time left, and ends game when time is over
  if(timeLeft<0)
    table.gameOver = true;
  text("Timer: "+timeLeft,mid,170);                                       // Displays time left
  
  text("Move:",mid,220);                                                  // Display controls
  text("W+A+S+D+Q+E", mid,260);
  text("Power:",mid,310);
  text("MouseWheel",mid,350);
  
  textAlign(LEFT);
  popMatrix();
  
  for(int x=0; x<button.length; x++)                                      // Draw each button
    button[x].drawButton();
    
  if(table.gameOver){                                            // Prints result of game and constantly rotates and zooms out if game is over
    textSize(30);
    fill(0,100);
    rect(0,0,hudX,height);
    fill(255);
    if(table.scoreA+table.scoreB==15)
      text(table.scoreA>table.scoreB?"PLAYER A WON":"PLAYER B WON", (hudX)/2-100,height/2);
    else
      text(table.turn%2==1?"PLAYER A WON":"PLAYER B WON", (hudX)/2-100,height/2);
    zoomlvl -= 0.1;
    rotX +=0.01;
    rotZ +=0.01;
  }
  hint(ENABLE_DEPTH_TEST);
}

void mousePressed(){
  if(mouseX<=hudX)                                    // If click is inside game runs corressponding function in Table class
    table.pressed();
  else{                                                // If click is on the menu
    for(int x=0; x<button.length; x++){  
      if(button[x].contained(mouseX,mouseY))        // Checks if mouse is pressed on each button and performs that buttons corresponding function
        if(x==0){                              // Toggles theme
          table.themed = !table.themed;
          table.woodImg = !table.themed?loadImage("Wood.png"):loadImage("TheBestWall.jpg");
        }
        else if(x==1)                        // Restarts game
          setup();
        else if(x==2){                      // Re-centers camera zoom and angle
          rotX = 0;
          rotZ = 0;
          zoomlvl = -3;
        }
    }
  }
}

/*  
*      For each keyboard control, checks if corresponding key is being pressed and performs that control's function.
*/
void checkKeys(){
  if (keypress['d']) {          // rotates or zooms if corresponding keys are pressed
    rotZ+=0.1;
  } if (keypress['s']) {
    rotX-=0.1;
  } if (keypress['a']) {
    rotZ-=0.1;
  } if (keypress['w']) {
    rotX+=0.1;
  } if (keypress['q']) {
    zoomlvl--;
  } if (keypress['e']) {
    zoomlvl++;
  } 
}
void mouseWheel(MouseEvent event){
  table.changePower(event.getCount());      // changes power based on mousewheel
}
void keyPressed() {
  keypress[key] = true;         // Sets pressed key to true in the the keypress array    
}
void keyReleased(){
  keypress[key] = false;        // Sets released key to true in the the keypress array    
}
void mouseReleased(){
  if(mouseX<=hudX)    
    if(!table.gameOver)
      table.released();      // Runs corresponding released function in Table class if click is in the game field and game is not over
}