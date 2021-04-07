Grid grid;

void setup() {
  size(1200, 1200);
  //randomSeed(12345);
  
  grid = new Grid(100, 100, 10, 100);
  grid.distort();
  
  grid.display();
  
  PVector from = new PVector();
  PVector to = new PVector();
  noStroke();
  fill(255, 0, 0);
  for (int x = 0; x < 1000; x++) {
    from.set(x, x);
    grid.mapToGrid(from, to);
    circle(to.x, to.y, 3);
  }
}
