import java.util.Iterator;

void setup() {
  size(1536, 1536);
  ArrayList<GeoFeature> departments = loadFeatures("departements-20140306-100m.geojson");
  // remove DOMS
  Iterator<GeoFeature> it = departments.iterator();
  while (it.hasNext()) {
    if (it.next().id.startsWith("97")) it.remove();
  }
  
  PVector nw = new PVector(0, 49);
  PVector se = new PVector(0, 49);
  for (GeoFeature dept : departments) dept.boundingBox(nw, se);
  println("Bounding box", nw, se);
  
  LocationProjector proj = new LocationProjector(width, nw, se);
  println("projector", proj);
  // println(proj.winX(nw.x), proj.winY(nw.y));
  // println(proj.winX(se.x), proj.winY(se.y));
  for (GeoFeature dept: departments) {
    dept.project(proj);
    dept.display();
  }
}

// Adapt according to "properties" in your data
// GeoJSON : https://tools.ietf.org/html/rfc7946

ArrayList<GeoFeature> loadFeatures(String fileName) {
  ArrayList<GeoFeature> geoFeatures = new ArrayList();
  JSONObject data = loadJSONObject(fileName);
  JSONArray features = data.getJSONArray("features");
  for (int i = 0; i < features.size(); i++) {
    JSONObject feature = features.getJSONObject(i);
    JSONObject properties = feature.getJSONObject("properties");
    String code = properties.getString("code_insee");
    String nom = properties.getString("nom");
    JSONObject geometry = feature.getJSONObject("geometry");
    JSONArray coord = geometry.getJSONArray("coordinates");
    if (geometry.getString("type").equals("Polygon")) coord = new JSONArray().append(coord);
    println(code, nom, coord.size());
    GeoPolygon[] multiPoly = new GeoPolygon[coord.size()];
    for (int j = 0; j < coord.size(); j++) {
      multiPoly[j] = new GeoPolygon(coord.getJSONArray(j));
    }
    geoFeatures.add(new GeoFeature(code, nom, multiPoly));
  }
  return geoFeatures;
}
