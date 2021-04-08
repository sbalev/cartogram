Grid grid;

void setup() {
  size(1200, 1200);
  //randomSeed(12345);

  grid = new Grid(100, 100, 10, 100);
  grid.distort();

  stroke(0, 64);
  grid.display();

  stroke(255, 0, 0);
  strokeWeight(3);
  noFill();
  
  beginShape();
  grid.mapLine(new PVector(50, 50), new PVector(450, 450), 5);
  endShape();
  beginShape();
  grid.mapLine(new PVector(50, 450), new PVector(450, 50), 5);
  endShape();
  
  ArrayList<PVector> poly = regularPolygon(3, 750, 250, 200);
  beginShape();
  grid.mapPolyline(poly, 5, true);
  endShape(CLOSE);
  
  poly = regularPolygon(4, 250, 750, 200);
  beginShape();
  grid.mapPolyline(poly, 5, true);
  endShape(CLOSE);

  poly = regularPolygon(60, 750, 750, 200);
  beginShape();
  grid.mapPolyline(poly, 5, true);
  endShape(CLOSE);

}

ArrayList<PVector> regularPolygon(int n, float xc, float yc, float r) {
  ArrayList<PVector> poly = new ArrayList();
  for (int i = 0; i < n; i++) {
    float a = TAU * i / n;
    poly.add(new PVector(xc + r * cos(a), yc + r * sin(a)));
  }
  return poly;
}
