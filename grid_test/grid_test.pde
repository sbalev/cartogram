Grid grid;

void setup() {
  size(1000, 1000);
  grid = new Grid(50, 50, 9, 100);
  grid.display();
  
  grid.computeAreas();
  println(grid.areas[0][0]);
}
