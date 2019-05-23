  
boolean hasClicked = false;  
float xSide= 400;
float ySide = 400;
  
  //runs once and sets up screen size and color
  void setup(){
      size(1024, 600);
    background(0, 0, 0);
  }
  
  
  //draw() is run continuously
  void draw(){
    if(hasClicked){
    rect(600, 100, xSide, ySide, 7);
    }
  }
  
  //after a mouse click, it updates variables
  void mouseClicked(){
    hasClicked = !hasClicked;
  }
