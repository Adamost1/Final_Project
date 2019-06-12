boolean hasClicked = false;

//IMPORTANT NOTE: Since each frame is 1/60th of a second, it is not necessary to calculate timeElapsed, as dFlux can be calculated per frame

//=============== FIELD VARIABLES ===========================
//Magnetic field coordinates stay the same
float xField = 250; //x coor of center of field
//float xEnd = xField + 300; 
float yField = 400; //y coor of center of field
//float yEnd = yField +300;
float fieldWidth = 150; //half of width of field (to be implemented with RectMode(RADIUS) later on)
float fieldLength = 300; //half of length of field

boolean isFieldIn = true; //true if the field is into page, false if field is out of page



//B and A can be used to calculate dFlux


float bField = 0; //to be changeable

float loops = 1;
float dTime = 0;

//=================WIRE VARIABLES=============================
float xWire;
float yWire;
float wireLength = 0;
float wireWidth = 0;

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
  size(1000, 750);
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
  rect(xWire -  wireWidth, yWire, 5, wireLength + 2.5);
  rect(xWire +  wireWidth, yWire, 5, wireLength + 2.5);
  rect(xWire, yWire - wireLength, wireWidth + 2.5, 5);
  rect(xWire, yWire + wireLength, wireWidth + 2.5, 5);

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
  for (float i = xField-fieldWidth; i < xField + fieldWidth; i = i+25) {
    for (float j = yField-fieldLength; j < yField + fieldLength; j = j+25) {
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
float saved = 0;
String typing = "";
int counter = 0;
void keyPressed() {
  println(typing);
  // If the return key is pressed, save the String and clear it
  if (key == '\n' ) {
    saved = float(typing);
    if (!(saved >= 10 || saved < 10)) {
      println("lmao good one!");
    } else {
      if (counter == 0) {
        bField = saved;
      }
      if (counter == 1) {
        wireLength = saved / 2.0;
      }
      if (counter == 2) {
        wireWidth = saved / 2.0;
      }
      counter += 1;
    }
    // A String can be cleared by setting it equal to ""
    typing = "";
    saved = 0;
  } else if (key == BACKSPACE) {
    typing = "";
  } else {
    // Otherwise, concatenate the String
    // Each character typed by the user is added to the end of the String variable.
    typing = typing + key;
  }
}
void draw() { 
  background(0);
  text("Type in the magnetic field!", 400, 550);
  text("Input: " + typing, 400, 625);
  text("Saved text: " + saved, 400, 700);
  if (bField != 0) {
    background(0);
    text("Great, now type in the length of the wire!", 400, 550);
    text("length: " + typing, 400, 625);
    text("Saved text: " + saved, 400, 700);
    if (wireLength != 0) {
      background(0);
      text("Great, now type in the width of the wire!", 400, 550);
      text("width: " + typing, 400, 625);
      text("Saved text: " + saved, 400, 700);
      if (wireWidth != 0) {
        background(0);
        text("Great, now we can test everything out!", 400, 500);
      }
    }
  }
  drawButton();
  drawField();
  drawWire();

  //calculate dFlux per frame (draw runs once every frame)
  dFlux = bField * (areaInsideField() - initialArea);
  initialArea = areaInsideField();
  float EMF = 0;

  //flux for fieldIn should be negative
  //flux for fieldOut should be positive
  //therefore the EMF for either is the opposite

  if (isFieldIn) {
    EMF = loops * (dFlux * 60); //dFlux / timeElapsed = dFlux * 60
  } else {
    EMF = -1 * loops * (dFlux * 60);
  }
  textSize(16);
  fill(255);
  text("Area: " + areaInsideField() + "\nFlux: " + flux(bField, areaInsideField())  + "\nChange in Flux: "  + dFlux /*+  "\nChange in Time: " + timeElapsed */ + "\nInduced EMF: " + EMF, 400, 250);
}

float buttonX = 100;
float buttonY = 50;
float buttonWidth = 60;
float buttonLength = 30;

void drawButton() {
  fill(204, 102, 0);
  rect(buttonX, buttonY, buttonWidth, buttonLength);
  fill(255);
  text("Click here to toggle", buttonX, buttonY);
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
  if (mouseX <= buttonX + buttonWidth && mouseX >= buttonX - buttonWidth && mouseY <= buttonY + buttonLength && mouseY >= buttonY - buttonLength) {
    isFieldIn = !isFieldIn;
  }
}
