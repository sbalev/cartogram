class GeoFeature {
  String id;
  String name;
  GeoPolygon[] geometry;
  
  GeoFeature(String id, String name, GeoPolygon[] geometry, color col) {
    this.id = id;
    this.name = name;
    this.geometry = geometry;
  }
  
  void boundingBox(PVector nw, PVector se) {
    for (GeoPolygon poly : geometry) poly.boundingBox(nw, se);
  }
  
  void project(LocationProjector proj) {
    for (GeoPolygon poly : geometry) poly.project(proj);
  }
  
  void display() {
    for (GeoPolygon poly : geometry) poly.display();
  }
}
