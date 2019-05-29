boolean hasClicked = false;
//Magnetic field coordinates (stays the same)
float xStart = 500;
float xEnd = xStart + 300;
float yStart = 500;
float yEnd = yStart +300;



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
  if(bx < xEnd && bx > xStart && by < yEnd && by >yStart ){
   println("INSIDE FIELD");
  }
   else{
     println("not in field");
   }
  
  // Test if the cursor is over the box 
  if (mouseX > bx-boxSize && mouseX < bx+boxSize && 
    mouseY > by-boxSize && mouseY < by+boxSize) {
    overBox = true;  
    if (!locked) { 
     stroke(20,75,200); //highlights object blue
      fill(255);
    }
  } else {
  //  stroke(20,75,200);
    fill(255);
    overBox = false;
  }

  // Draw the wire, represented by a box in a box
  rect(bx, by, boxSize, boxSize);
  fill(0);
  rect(bx, by, boxSize -10, boxSize -10);
  fill(0);
}

void mousePressed() {
  if (overBox) { 
    locked = true; 
    fill(255, 255, 255);
  } else {
    locked = false;
  }

}

void mouseDragged() {
  if (locked) {
    bx = mouseX; 
    by = mouseY;
    //test coordinate change functionality
    //println(bx,by);
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
