// https://tools.ietf.org/html/rfc7946

HashMap<String, GeoPolygon[]> depts = new HashMap();

void setup() {
  JSONObject data = loadJSONObject("departements-20140306-100m.geojson");
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
    depts.put(code, multiPoly);
    for (int j = 0; j < coord.size(); j++) {
      multiPoly[j] = new GeoPolygon(coord.getJSONArray(j));
    }
    
    // remove DOM
    depts.remove("971");
    depts.remove("972");
    depts.remove("973");
    depts.remove("974");
    depts.remove("976");
  }
}
