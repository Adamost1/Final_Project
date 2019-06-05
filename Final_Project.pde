boolean hasClicked = false;

//=============== FIELD VARIABLES ===========================

//Magnetic field coordinates (stays the same)
float xField = 500; //x coor of center of field
//float xEnd = xField + 300; 
float yField = 800; //y coor of center of field
//float yEnd = yField +300;
float fieldWidth = 300; //half of width of field (to be implemented with RectMode(RADIUS) later on)
float fieldLength = 600; //half of length of field

boolean isFieldIn = true; //true if the field is into page, false if field is out of page



//Formula Variables
float theta = 90; //change if we want to implement rotate
//B and A can be used to calculate dFlux


float bField = 10; //to be changeable

float loops = 1;
float timeStart;
float timeEnd;
float dTime = 0;

//=================WIRE VARIABLES=============================
float xWire;
float yWire;
float wireLength = 100;
float wireWidth = 100;

boolean overWire = false;
boolean locked = false; //Is the wire being moved by the cursor?

boolean isInField = false; //is any part of the wire in the field?
PFont f;


float fluxInitial;
float fluxFinal;
float dFlux;



HScrollbar hs1;
//https://processing.org/examples/mousefunctions.html


//runs once and sets up screen size and color
void setup() {
  size(2000, 1500);
  background(0, 0, 0);


  xWire= width/2.0; //center x coor
  yWire = height/2.0; //center y coor
  rectMode(RADIUS);
  ellipseMode(RADIUS);
  f = createFont("Arial", 16);
}


float flux(float B, float area) {
  return B*area;
}

float areaInsideField() {
  
  float leftField = xField - fieldWidth; //left edge of field
   float rightField = xField + fieldWidth; //right edge of field
   float upperField = yField - fieldLength; //upper edge of field
   float lowerField = yField + fieldLength; //lower edge of field
   
   float leftWire = xWire - wireWidth; //left edge of wire
   float rightWire = xWire + wireWidth; //right edge of wire
   float upperWire = yWire - wireLength; //upper edge of wire
   float lowerWire = yWire + wireLength; //lower edge of wire
   

  float xOverlap;
  float yOverlap;

  if (leftWire < leftField) { //if the wire extends past the left of field
    xOverlap = rightWire - leftField;
  } else if (rightWire < rightField) { //if the width of the wire is contained in the field
    xOverlap = rightWire - leftWire;
  } else { //if wire extends past right of field
    xOverlap = rightField - leftWire;
  }

  if ( upperWire < upperField) { //if wire extends above field
    yOverlap = lowerWire - upperField;
  } else if (lowerWire < lowerField) { //if length of the wire is contained in the field
    yOverlap = lowerWire - upperWire;
  } else { //if the wire extends below the field
    yOverlap = lowerField - upperWire;
  }

  float returnVal = xOverlap * yOverlap;

  if (returnVal < 0) { //if the wire is outside the field, return 0
    return 0;
  } else {
    return returnVal;
  }
}
/* Not used
boolean isInField() {
  
  if (areaInsideField() == 0 ) {
    println("False");// return true;
  } else {
    println("True");//return false;
  }  
  return false;
}
*/

void drawWire() {

  /* //used to test basic inside/out functionality
   if (xWire < xField + fieldWidth && xWire> xField - fieldWidth && yWire < yField + fieldLength  && yWire >yField - fieldLength ) {
   println("INSIDE FIELD");
   } else {
   println("not in field");
   }
   */


  // Test if the cursor is over the wire 
  if (mouseX > xWire-wireWidth && mouseX < xWire+wireWidth && mouseY > yWire-wireLength && mouseY < yWire+wireLength) {
    overWire = true;
  } else {
    overWire = false;
  }

  // Draw the wire in it's new position, represented yWire a box in a box
  fill(255);
  rect(xWire -  wireWidth, yWire, 10, wireLength + 5);
  rect(xWire +  wireWidth, yWire, 10, wireLength + 5);
  rect(xWire, yWire - wireLength, wireWidth + 5, 10);
  rect(xWire, yWire + wireLength, wireWidth + 5, 10);

  /*//OLD wire implementation
   fill(0);
   rect(xWire, yWire, wireWidth -10, wireLength -10);
   */
}


void drawField() {
  fill(255);

  //rect(xField, yField, fieldWidth, fieldLength); //test field with rectangle shape

  //nested for loops to make dotted pattern
  for (float i = xField-fieldWidth; i < xField + fieldWidth; i = i+10) {
    for (float j = yField-fieldLength; j < yField + fieldLength; j = j+10) {

      //if field is into page, field turns red. If it is out of page, it turns green.
      if (isFieldIn) {
        fill(255, 0, 0);
      } else {
        fill(0, 255, 0);
      }

      ellipse(i, j, 3, 3);
    }
  }
}
void draw() { 

  if (areaInsideField() == 0) {
    timeStart = millis();
  }
  else{
   timeEnd = millis(); 
  }

  float timeElapsed;
  
  /*
  if (mousePressed){
    fluxFinal = flux(bField, areaInsideField());
    println(fluxInitial);
    println(fluxFinal);
    dFlux = fluxFinal - fluxInitial;
  }
  
  */
  

  if (timeEnd - timeStart <= 0){
    timeElapsed = 0;
  }
  else{
    timeElapsed = timeEnd - timeStart;
  }
  
  
  /*
  if ((timeEnd-timeStart) < 0) {
    dTime = 0;
  } else {
    dTime = timeEnd - timeStart;
  }
*/

  background(0);

  drawField();
  drawWire();
  

  
  textSize(100);
  fill(255);
  text("Area: " + areaInsideField() + "\nFlux: " + flux(bField, areaInsideField())  + "\nChange in Flux: "  + dFlux +  "\nChange in Time: " + timeElapsed + "\nInduced EMF: " + -1 * loops * (dFlux/timeElapsed) , 700, 500);

}
boolean moving = false;
    
void mousePressed() {
  if (overWire) { 
    locked = true;
  } else {
    locked = false;
  }
}


//updates when mouse pressed and moving
void mouseDragged() {
    fluxInitial = flux(bField, areaInsideField());
    xWire = mouseX; 
    yWire = mouseY;
    fluxFinal = flux(bField, areaInsideField());
    dFlux = fluxFinal - fluxInitial;
    //test coordinate change functionality
    //println(xWire,yWire);
  
}

void mouseReleased() {
  //dFlux = fluxFinal - fluxInitial;
  dFlux = 0;
  locked = false;
}


//after a mouse click, it updates variables
void mouseClicked() {
  hasClicked = !hasClicked;
}




class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}
