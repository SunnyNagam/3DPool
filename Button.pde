class Button{
  PVector loc, siz;
  int ind = -1;
  String text;
  Button(int x, int y, int len, int wid, String name, int in){
    loc = new PVector(x,y);
    siz = new PVector(len,wid);
    text = name;
    ind = in;
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
  
  boolean contained(int x, int y){
    if(x>loc.x && y>loc.y)
      if(x<loc.x+siz.x && y<loc.y+siz.y)
      return true;
    return false;
  }
  
}