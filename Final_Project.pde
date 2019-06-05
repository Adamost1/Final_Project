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
float area = 10;

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

//emf=-N(dFlux/dTime)


float flux(float B, float area) {
  return B*area;
}



float emf( float dFlux, float dT) {
  
  return dFlux / dT;
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

boolean isInField() {
  if (areaInsideField() == 0 ) {
    println("False");// return true;
  } else {
    println("True");//return false;
  }  
  return false;
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

  if(timeEnd - timeStart <= 0){
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
  text("Area: " + areaInsideField() + "\nFlux: " + flux(bField, areaInsideField())  + "\nChange in Flux: "  + dFlux +  "\nChange in Time: " + timeElapsed + "\nInduced EMF: " + (-1 * loops * (dFlux / timeElapsed)), 700, 500);
  isInField();
}


void mousePressed() {
  fluxInitial = flux(bField, areaInsideField());
  if (overWire) { 
    locked = true;
  } else {
    locked = false;
  }
}


void mouseDragged() {
  if (locked) {
    xWire= mouseX; 
    yWire = mouseY;
    
    fluxFinal = flux(bField, areaInsideField());
    dFlux = fluxFinal - fluxInitial;
    //test coordinate change functionality
    //println(xWire,yWire);
  }
}

void mouseReleased() {
  //dFlux = fluxFinal - fluxInitial;
  locked = false;
}


//after a mouse click, it updates variables
void mouseClicked() {
  hasClicked = !hasClicked;
}
