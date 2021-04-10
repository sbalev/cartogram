class GeoFeature {
  String id;
  String name;
  GeoPolygon[] geometry;
  
  GeoFeature(String id, String name, GeoPolygon[] geometry) {
    this.id = id;
    this.name = name;
    this.geometry = geometry;
  }
  
  void boundingBox(PVector nw, PVector se) {
    for (GeoPolygon poly : geometry) poly.boundingBox(nw, se);
  }
  
  void convertGeometry(LocationConverter conv) {
    for (GeoPolygon poly : geometry) poly.convert(conv);
  }
  
  void display() {
    for (GeoPolygon poly : geometry) poly.display();
  }
}
