/*** Integer trigonometry ***/
// https://gist.github.com/sbalev/2b656bf35eb820245afad06d5ada5a82

int isin(int x) {
  x &= 3;
  return x == 3 ? -1 : x & 1;
}

int icos(int x) {
  x &= 3;
  return x == 2 ? -1 : 1 ^ x & 1;
  // or just
  // return isin(x + 1);
}


/*** Polygon area ***/
// https://en.wikipedia.org/wiki/Shoelace_formula

float polygonArea(PVector[] vertices) {
  float a = 0;
  int n = vertices.length;
  for (int i = 0; i < n; i++) {
    a += vertices[i].x * vertices[(i + 1) % n].y - vertices[(i + 1) % n].x * vertices[i].y;
  }
  return 0.5 * a;
}


/*** drawing functions with PVector arguments ***/

void lineSegment(PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}
