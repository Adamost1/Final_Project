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



//runs once and sets up screen size and color
void setup() {
  size(1024, 600);
  background(0, 0, 0);

  //wire = createShape();
}

//emf=-N(dFlux/dTime)
float emf(float N, float phi, float t) {
  float sol= ((-1)*N*phi)/t;
  return  sol;
}

//draw() is run continuously
void draw() {
  if (hasClicked) {
    rect(600, 100, xSide, ySide, 7);
  }
}

//after a mouse click, it updates variables
void mouseClicked() {
  hasClicked = !hasClicked;
  println(emf(loops, flux, time));
}
