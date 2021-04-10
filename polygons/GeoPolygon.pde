class GeoPolygon {
  PVector[][] rings;
  
  GeoPolygon(JSONArray jPoly) {
    rings = new PVector[jPoly.size()][];
    for (int i = 0; i < jPoly.size(); i++) {
      rings[i] = ring(jPoly.getJSONArray(i));
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
