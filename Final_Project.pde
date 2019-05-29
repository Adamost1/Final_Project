boolean hasClicked = false;  
float xSide= 400;
float ySide = 400;
PShape wire;
float theta = 90; //change when implementing rotate

//B and A can be used to calculate dFlux
float area = 10;             
float magneticField = 10;

//===========================
float flux = 10;
float loops = 1;
float time = 10;

//=================BOX VARIABLES=============================
float bx;
float by;
int boxSize = 75;
boolean overBox = false;
boolean locked = false;
float xOffset = 0.0; 
float yOffset = 0.0; 

//========================================


//runs once and sets up screen size and color
void setup() {
  size(1000, 1000);
  background(0, 0, 0);

  bx = width/2.0;
  by = height/2.0;
  rectMode(RADIUS);
  /*
rectMode(RADIUS);  // Set rectMode to RADIUS
   fill(255);  // Set fill to white
   rect(500, 500, 250, 250);  // Draw white rect using RADIUS mode
   
   rectMode(CENTER);  // Set rectMode to CENTER
   fill(0);  // Set fill to gray
   rect(500, 500, 400, 400);  // Draw gray rect using CENTER mode
   */
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


void draw() { 
  background(0);

  // Test if the cursor is over the box 
  if (mouseX > bx-boxSize && mouseX < bx+boxSize && 
    mouseY > by-boxSize && mouseY < by+boxSize) {
    overBox = true;  
    if (!locked) { 
      stroke(255); 
      fill(153);
    }
  } else {
    stroke(153);
    fill(153);
    overBox = false;
  }

  // Draw the box
  rect(bx, by, boxSize, boxSize);
}

void mousePressed() {
  if (overBox) { 
    locked = true; 
    fill(255, 255, 255);
  } else {
    locked = false;
  }
  xOffset = mouseX-bx; 
  yOffset = mouseY-by;
}

void mouseDragged() {
  if (locked) {
    bx = mouseX-xOffset; 
    by = mouseY-yOffset;
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
