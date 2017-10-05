import ddf.minim.*;
Table table;
int hudX = 1100;
float rotX, rotZ, zoomlvl;
boolean[] keypress;
Button button[];
PVector mouse = new PVector(mouseX,mouseY);

void setup(){
  //noCursor();
  size(1400,600,P3D);
  //fullScreen(P3D);
  rotX=0;
  rotZ=0;
  zoomlvl=0;
  keypress = new boolean[128];
  lights();
  table = new Table(hudX,600);
  table.minim = new Minim(this);
  table.loadSounds();
  button = new Button[2];
  button[0] = new Button(hudX+20,350,260,100,"Make Pool Great Again",0);
  button[1] = new Button(hudX+20+60,460,100,100,"Restart",0);
}

void draw(){
  background(255);
  lights();
  mouse.add(mouseX-pmouseX,mouseY-pmouseY);
  
  directionalLight(255, 255, 255, rotX, 0, rotZ);
  checkKeys();
  pushMatrix();
  translate(hudX/2,height/2);
  translate(0,0,zoomlvl*10);
  rotateX(rotX);
  rotateZ(rotZ);
  
  translate(-hudX/2,-height/2);
  
  
  table.drawTable();
  table.updateTable();
  popMatrix();
  
  noLights();
  
  //Drawing score, buttons and gui
  hint(DISABLE_DEPTH_TEST);
  fill(255);
  pushMatrix();
  translate(hudX,0);
  rect(0,0,width-hudX,height);
  fill(0);
  textSize(30);
  text(table.themed?"States: ":"Score: ",100,50);
  text("   "+table.scoreA,100,100);
  
  text("Power: ",100,200);
  text("   "+table.powerLevel,100,250);
  //text(frameRate,100,300);
  
  popMatrix();
  for(int x=0; x<button.length; x++)
    button[x].drawButton();
  if(table.gameOver){
    textSize(30);
    fill(0,100);
    rect(0,0,hudX,height);
    fill(255);
    text(table.scoreA==15?"YOU WIN":"GAME OVER", (hudX)/2-100,height/2);
    zoomlvl -= 0.1;
    rotX +=0.01;
    rotZ +=0.01;
  }
  hint(ENABLE_DEPTH_TEST);
}

void mousePressed(){
  if(mouseX<=hudX)
    table.pressed();
  else{
    for(int x=0; x<button.length; x++){
      if(button[x].contained(mouseX,mouseY))
        if(x==0){
          table.themed = !table.themed;
          table.woodImg = !table.themed?loadImage("Wood.png"):loadImage("TheBestWall.jpg");
        }
        else if(x==1)
          setup();
    }
  }
}

void checkKeys(){
  for(int x=0; x<keypress.length; x++)
    if(keypress[x]){
      if (x == 'd') {
        rotZ+=0.1;
      } else if (x == 's') {
        rotX-=0.1;
      } else if (x == 'a') {
        rotZ-=0.1;
      } else if (x == 'w') {
        rotX+=0.1;
      } else if (x == 'q') {
        zoomlvl--;
      } else if (x == 'e') {
        zoomlvl++;
      }    
    }
}
void keyPressed() {
  keypress[key] = true;     
}
void keyReleased(){
  keypress[key] = false;
}
void mouseReleased(){
  if(mouseX<=hudX)
  if(!table.gameOver)
    table.released();
}