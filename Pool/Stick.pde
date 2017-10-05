class Stick
{
 PVector start;          // Start coordinates of stick
 PVector end;            // End coordinates of stick
 color col;              //color of the pool stick
 float length = 200;     //length of the pool stick


  Stick(){    
    start = new PVector();
    end = new PVector();
  }
  
  void drawStick(){
    stroke(table.powerLevel*255/20,0,0);      // Setting the redness of the stick based on the powerlevel
    strokeWeight(8);                          // Increasing the thickness of the stick
    line(start.x,start.y,end.x,end.y);
    noStroke();
  }
}