class GeoPolygon {
  PVector[][] rings;
  
  GeoPolygon(JSONArray jPoly) {
    rings = new PVector[jPoly.size()][];
    for (int i = 0; i < jPoly.size(); i++) {
      rings[i] = ring(jPoly.getJSONArray(i));
    }
  }
  
  void boundingBox(PVector nw, PVector se) {
    for (PVector v : rings[0]) {
      nw.x = min(nw.x, v.x);
      nw.y = max(nw.y, v.y);
      se.x = max(se.x, v.x);
      se.y = min(se.y, v.y);
    }
  }
}

PVector[] ring(JSONArray jRing) {
  PVector[] r = new PVector[jRing.size() - 1];
  for (int i = 0; i < jRing.size() - 1; i++) {
    JSONArray point = jRing.getJSONArray(i);
    r[i] = new PVector(point.getFloat(0), point.getFloat(1));
  }
  return r;
}
