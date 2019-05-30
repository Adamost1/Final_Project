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
float theta = 90; //change when implementing rotate
//B and A can be used to calculate dFlux
float area = 10;             
float magneticField = 10;
float flux = 10;
float loops = 1;
float time = 10;

//=================WIRE VARIABLES=============================
float xWire;
float yWire;
float wireLength = 200;
float wireWidth = 200;

boolean overWire = false;
boolean locked = false;


//https://processing.org/examples/mousefunctions.html


//runs once and sets up screen size and color
void setup() {
  size(2000, 1500);
  background(0, 0, 0);


  xWire= width/2.0; //center x coor
  yWire = height/2.0; //center y coor
  rectMode(RADIUS);
  ellipseMode(RADIUS);
}

//emf=-N(dFlux/dTime)
float emf(float N, float phi, float t) {
  float sol= ((-1)*N*phi)/t;
  return  sol;
}

float dFluxdT(float phi, float t) {
  float sol= phi/t;
  return sol;
}

float flux(float B, float area) {
  return B*area;
}

float areaInsideField(){
  float xOverlap = (xField + fieldWidth) - (xWire - wireWidth);
  float yOverlap = (yField + fieldLength) - (yWire - wireLength);
  return xOverlap * yOverlap;
}
void drawWire() {
  
  /* //used to test basic inside/out functionality
  if (xWire < xField + fieldWidth && xWire> xField - fieldWidth && yWire < yField + fieldLength  && yWire >yField - fieldLength ) {
    println("INSIDE FIELD");
  } else {
    println("not in field");
  }
  */
  
  println("Area in field: " + areaInsideField());

  // Test if the cursor is over the wire 
  if (mouseX > xWire-wireWidth && mouseX < xWire+wireWidth && mouseY > yWire-wireLength && mouseY < yWire+wireLength) {
    overWire = true;
  } else {
    overWire = false;
  }

  // Draw the wire in it's new position, represented yWire a box in a box
  fill(255);
  rect(xWire, yWire, wireWidth, wireLength);
  fill(0);
  rect(xWire, yWire, wireWidth -10, wireLength -10);


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
  background(0);
  drawField();
  drawWire();
}


void mousePressed() {
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
    //test coordinate change functionality
    //println(xWire,yWire);
  }
}

void mouseReleased() {
  locked = false;
}


//after a mouse click, it updates variables
void mouseClicked() {
  hasClicked = !hasClicked;
  println(emf(loops, flux, time));
}
