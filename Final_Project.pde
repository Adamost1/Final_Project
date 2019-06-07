boolean hasClicked = false;


//IMPORTANT NOTE: Since each frame is 1/60th of a second, it is not necessary to calculate timeElapsed, as dFlux can be calculated per frame

//=============== FIELD VARIABLES ===========================
//Magnetic field coordinates stay the same
float xField = 500; //x coor of center of field
//float xEnd = xField + 300; 
float yField = 800; //y coor of center of field
//float yEnd = yField +300;
float fieldWidth = 300; //half of width of field (to be implemented with RectMode(RADIUS) later on)
float fieldLength = 600; //half of length of field

boolean isFieldIn = true; //true if the field is into page, false if field is out of page



//B and A can be used to calculate dFlux


float bField = 10; //to be changeable

float loops = 1;
float dTime = 0;

//=================WIRE VARIABLES=============================
float xWire;
float yWire;
float wireLength = 100;
float wireWidth = 100;

//Probably not gonna implement rotate
//float theta = 90; //change if we want to implement rotate

boolean overWire = false;
boolean locked = false; //Is the wire being moved by the cursor?



//====================FORMULA VARIABLES=========================
float fluxInitial;
float fluxFinal;
float dFlux;

//initialize initialArea to calculate dArea and dFlux later on
float initialArea = 0;

boolean isInField = false; //is any part of the wire in the field?
PFont f;

//https://processing.org/examples/mousefunctions.html


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
  //test field size with a rectangle
  // rect(xField, yField, fieldWidth, fieldLength);

  //nested for loops to make dotted pattern
  for (float i = xField-fieldWidth; i < xField + fieldWidth; i = i+50) {
    for (float j = yField-fieldLength; j < yField + fieldLength; j = j+50) {
      //if field is into page, field turns red. If it is out of page, it turns green.
      if (isFieldIn) {
        fill(255, 0, 0);
      } else {
        fill(0, 255, 0);
      }
      ellipse(i, j, 6, 6);
    }
  }
}

void draw() { 
  background(0);
  drawField();
  drawWire();

  //calculate dFlux per frame (draw runs once every frame)
  dFlux = bField * (areaInsideField() - initialArea);
  println(initialArea + " " + areaInsideField());
  initialArea = areaInsideField();

  float EMF = -1 * loops * (dFlux * 60); //dFlux / timeElapsed = dFlux * 60

  textSize(100);
  fill(255);
  text("Area: " + areaInsideField() + "\nFlux: " + flux(bField, areaInsideField())  + "\nChange in Flux: "  + dFlux /*+  "\nChange in Time: " + timeElapsed */ + "\nInduced EMF: " + EMF, 350, 250);
}


void mousePressed() {
  if (overWire) { 
    locked = true;
  } else {
    locked = false;
  }
}


//updates when mouse pressed and moving
void mouseDragged() {
  xWire = mouseX; 
  yWire = mouseY;
  //test coordinate change functionality
  //println(xWire,yWire);
}

void mouseReleased() {
  dFlux = 0;
  locked = false;
}


//after a mouse click, it updates variables
void mouseClicked() {
  hasClicked = !hasClicked;
}
