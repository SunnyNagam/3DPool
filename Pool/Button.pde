class Button{
  PVector loc, siz;    // Location and size of ball
  String text;          // Text on button
  
  // Constructor for button with location, size (width and length), and text on button.
  Button(int x, int y, int len, int wid, String name){
    loc = new PVector(x,y);
    siz = new PVector(len,wid);
    text = name;
  }
  
  void drawButton(){
    fill(255);
    stroke(1);
    strokeWeight(2);
    rect(loc.x,loc.y,siz.x,siz.y);
    fill(0);
    textSize(22);
    text(text,loc.x+10,loc.y+siz.y/2+10);
  }
  
  /*
    Returns true if provided coordinates lie inside the button, used to check if user clicked on button
    @param int x: x coordinate of point to check
    @param int y: y coordinate of point to check
    @return boolean value representing if points lie inside button
  */
  boolean contained(int x, int y){
    if(x>loc.x && y>loc.y)
      if(x<loc.x+siz.x && y<loc.y+siz.y)
      return true;
    return false;
  }
  
}