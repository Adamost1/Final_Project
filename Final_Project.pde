boolean hasClicked = false;

//IMPORTANT NOTE: Since each frame is 1/60th of a second, it is not necessary to calculate timeElapsed, as dFlux can be calculated per frame
//Also important: We will equate 100 pixels with 1 meter

//=============== FIELD VARIABLES ===========================
//Magnetic field coordinates stay the same
float xField; //x coor of center of field
//float xEnd = xField + 300; 
float yField; //y coor of center of field
//float yEnd = yField +300;
float fieldWidth; //half of width of field (to be implemented with RectMode(RADIUS) later on)
float fieldLength; //half of length of field

boolean isFieldIn = true; //true if the field is into page, false if field is out of page



//B and A can be used to calculate dFlux


float bField = 0; //to be changeable

float loops = 0;
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
  f = createFont("Georgia", 16);
  textFont(f);
  
  xField = 0.25 * width;
  yField = 0.6 * height;
  fieldWidth = 0.15 * width;
  fieldLength = 0.3 * height;
  
}

float flux(float B, float area) {
  if(isFieldIn){ //flux into the page should be negative
  return -1 * B * area;
  }
  else{ //flux out of the page should be positive
    return B * area;
  }
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

  float returnVal = (xOverlap * yOverlap) / 10000;      //scales the area, with the scale 100 pixels = 1 meter

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

  float wireThickness = ( (wireLength * 0.1) + (wireWidth * 0.1) ) / 2;    //Thickness of wire is determined by the average of the tenth of length and width

  // Draw the wire in it's new position, represented yWire a box in a box
  fill(255);
  rect(xWire -  wireWidth, yWire, wireThickness, wireLength * 1.05);
  rect(xWire +  wireWidth, yWire, wireThickness, wireLength * 1.05);
  rect(xWire, yWire - wireLength, wireWidth + wireLength * 0.05, wireThickness);
  rect(xWire, yWire + wireLength, wireWidth + wireLength * 0.05, wireThickness);

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
String caseText = "";
void keyPressed() {
  println(typing);

  // If the return key is pressed, save the String and clear it
  if (key == '\n' ) {
    saved = float(typing);
    if (!(saved >= 10 || saved < 10)) { //if the user input is not a number, the 10s are arbitrary
      println("lmao good one!");
      caseText = "\n                      Ms.Sharaf, do you not know what a number is?";
    } else if (saved < 0 ||(counter == 1  && saved < 0.02 * width) || (counter == 2 && saved < 0.02 * height)){ //checks if the input is too small
      println("too small");
      caseText = "\n                      Value too small, try again";
    } else if ((counter == 1 && saved >= 0.8 * width )|| (counter == 2 && saved >= 0.8* height) ) { //checks to see if input is too large
      println("too big");
      caseText = "\n                      Value too large, try again";
    } 
    else if(counter == 3 && saved <= 0){
     println("doesn't make sense bro"); 
    }
    else {
      if (counter == 0) {
        bField = saved;
      }
      if (counter == 1) {
        wireLength = saved / 2.0;
      }
      if (counter == 2) {
        wireWidth = saved / 2.0;
      }
      if (counter == 3){
        loops = saved;
      }
      counter += 1;
      caseText = "";
    }
    // A String can be cleared by setting it equal to ""
    typing = "";
    saved = 0;
  } else if (key == BACKSPACE) {
    println("backspace");
    typing = "";
  } else if (keyCode == SHIFT) { //press shift to reset values
    println("shift");
    // typing = "";
    //saved = 0;
    bField = 0;
    wireLength = 0;
    wireWidth = 0;
    counter = 0;
    loops = 0;
  } else {
    // Otherwise, concatenate the String
    // Each character typed by the user is added to the end of the String variable.
    typing = typing + key;
  }
}

void drawMisc(){
  //generates ring around output values
  fill(0, 35, 139);
  rect(width * 0.75, height * 0.18, 155, 100); 
  fill(66, 241, 244);
  rect(width * 0.75, height * 0.18, 145, 90);
  
  
}


void generateUserInput() {
  background(0);
  fill(145,189,30);
  text("Type in the desired MAGNITUDE of Magnetic Field Below!" + caseText, 0.4 * width , 0.75 * height);
  fill(215, 244, 66);
  text("Magnitude of Magnetic Field (T): " + typing, 0.4 * width, 0.85 * height);
  if (bField != 0) {
    background(0);
      fill(145,189,30);
    text("Great, now type in the Length of the Wire! (100px:1m)" + caseText, 0.4 * width , 0.75 * height);
    fill(215, 244, 66);
    text("Length (m): " + typing, 0.4 * width, 0.85 * height);
    if (wireLength != 0) {
      background(0);
        fill(145,189,30);
      text("Great, now type in the Width of the Wire! (100px:1m)" + caseText, 0.4 * width , 0.75 * height);
      fill(215, 244, 66);
      text("Width (m): " + typing, 0.4 * width, 0.85 * height);
      if (wireWidth != 0) {
        background(0);
          fill(145,189,30);
        text("Great, now type the number of loops of wire!" + caseText, 0.4 * width , 0.75 * height);
        fill(215, 244, 66);
        text("# of loops: " + typing, 0.4 * width, 0.85 * height);
        if (loops != 0){
          background(0);
          fill(145,189,30);
          text("Great, now we can test our code!", 0.4 * width , 0.75 * height);
        }
      }
    }
  }
}

int frameCounter = 0;
float a, b, c, d = 0;

void draw() { 
  generateUserInput(); //has to be first or else program wont work cuz it implements background()
  drawMisc();
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
    EMF = -1 * loops * (dFlux * 60); //dFlux / timeElapsed = dFlux * 60
  } else {
    EMF = loops * (dFlux * 60);
  }
  if (EMF != 0) {
    if (EMF > 0) {//if induced EMF is positive, the current is counterclockwise
      fill(255, 0, 0);
      triangle(xWire, yWire + 0.95 * wireLength, xWire, yWire + wireLength * 1.15, xWire + wireLength * 0.1 * sqrt(3), yWire + wireLength * 1.05); //bottom triangle
      triangle(xWire, yWire - 0.95 * wireLength, xWire, yWire - wireLength * 1.15, xWire - wireLength * 0.1 * sqrt(3), yWire - wireLength * 1.05); //upper triangle
      triangle(xWire - 0.95 * wireWidth, yWire, xWire - wireWidth * 1.15, yWire, xWire - wireWidth * 1.05, yWire + wireWidth * 0.1 * sqrt(3));
      triangle(xWire + 0.95 * wireWidth, yWire, xWire + wireWidth * 1.15, yWire, xWire + wireWidth * 1.05, yWire - wireWidth * 0.1 * sqrt(3));
    } else { //if induced EMF is negative, the current is clockwise
      fill(0, 0, 255);
      triangle(xWire, yWire + 0.95 * wireLength, xWire, yWire + wireLength * 1.15, xWire - wireLength * 0.1 * sqrt(3), yWire + wireLength * 1.05);
      triangle(xWire, yWire - 0.95 * wireLength, xWire, yWire - wireLength * 1.15, xWire + wireLength * 0.1 * sqrt(3), yWire - wireLength * 1.05);
      triangle(xWire - 0.95 * wireWidth, yWire, xWire - wireWidth * 1.15, yWire, xWire - wireWidth * 1.05, yWire - wireWidth * 0.1 * sqrt(3));
      triangle(xWire + 0.95 * wireWidth, yWire, xWire + wireWidth * 1.15, yWire, xWire + wireWidth * 1.05, yWire + wireWidth * 0.1 * sqrt(3));
    }
  }



  textSize(16);
  fill(255);


  if (frameCounter % 10 == 0) {
    a = 4 * wireWidth * wireLength;
    b = flux(bField, areaInsideField());
    c = dFlux;
    d = EMF;
  }
  
  String directionOfCurrent;
  if(EMF < 0){
    directionOfCurrent = "Counter Clockwise";
  }
  else if(EMF > 0){
   directionOfCurrent = "Clockwise";
  }
  else{
   directionOfCurrent = ""; 
  }
  
  fill(0);
  text("Area of Wire(m^2): " + round(a) + "\nLoops of Wire: " + round(loops) + "\nMagnetic Field(T): " + round(bField) + "\nFlux through Wire(W): " + b  + "\nChange in Flux (W/s): "  + c  + "\nInduced EMF (V): " + round(d) +"\nInduced Current: " + directionOfCurrent , 0.65 * width , 0.1 * height);
  fill(200, 255, 200);


  text("Press Shift to Reset",  0.4* width, 0.7 * height);
  frameCounter++;
}

float buttonX = 100;
float buttonY = 50;
float buttonWidth = 60;
float buttonLength = 30;

void drawButton() {
  fill(65, 106, 244);
  rect(buttonX, buttonY, buttonWidth, buttonLength);
  fill(0);
  text("TOGGLE\n  FIELD", buttonX - 0.5 * buttonWidth, buttonY);
  fill(190, 65, 244);
  if (isFieldIn){
    text("Magnetic Field: Into the Page", buttonX + 2 * buttonWidth, buttonY);
  }
  if (!isFieldIn){
    text("Magnetic Field: Out of the Page", buttonX + 2 * buttonWidth, buttonY);
  }
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
