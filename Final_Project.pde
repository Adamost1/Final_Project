boolean hasClicked = false;

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

//=================BOX/WIRE VARIABLES=============================
float bx;
float by;
int boxSize = 200;
boolean overBox = false;
boolean locked = false;


//https://processing.org/examples/mousefunctions.html


//runs once and sets up screen size and color
void setup() {
  size(2000, 1500);
  background(0, 0, 0);


  bx = width/2.0; //center x coor
  by = height/2.0; //center y coor
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

void drawWire() {
  if (bx < xField + fieldWidth && bx > xField - fieldWidth && by < yField + fieldLength  && by >yField - fieldLength ) {
    println("INSIDE FIELD");
  } else {
    println("not in field");
  }

  // Test if the cursor is over the box 
  if (mouseX > bx-boxSize && mouseX < bx+boxSize && mouseY > by-boxSize && mouseY < by+boxSize) {
    overBox = true;
  } else {
    overBox = false;
  }

  // Draw the wire in it's new position, represented by a box in a box
  fill(255);
  rect(bx, by, boxSize, boxSize);
  fill(0);
  rect(bx, by, boxSize -10, boxSize -10);

  //useless code but dont remove 
  //fill(0);
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
  if (overBox) { 
    locked = true;
  } else {
    locked = false;
  }
}


void mouseDragged() {
  if (locked) {
    bx = mouseX; 
    by = mouseY;
    //test coordinate change functionality
    println(bx,by);
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
