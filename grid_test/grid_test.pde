Grid grid;

void setup() {
  size(1000, 1000);
  grid = new Grid(50, 50, 9, 100);
  grid.display();
  for (int d = 0; d < 4; d++) {
    println(grid.fillQuad(0, 0, d));
    println(grid.quad);
  }
}
