Grid grid;

void setup() {
  size(1000, 1000);
  randomSeed(12345);
  
  grid = new Grid(50, 50, 9, 100);
  
  println("Before", grid.meanSqError());
  grid.computeGradients();
  grid.moveOnGradients(10);
  grid.computeAreas();
  println("After", grid.meanSqError());
  
  grid.display();
  
}
