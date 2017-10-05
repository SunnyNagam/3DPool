class Stick
{
 PVector start;
 PVector end;
 color col; //color of the pool stick
 float length = 200; //length of the pool stick
//More code

  Stick(){
    start = new PVector();
    end = new PVector();
  }
  
  void drawStick(){
    stroke(0);
    strokeWeight(8);
    line(start.x,start.y,end.x,end.y);
    noStroke();
  }
}