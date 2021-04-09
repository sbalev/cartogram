void setup() {
  JSONObject jo = loadJSONObject("departements-20140306-100m.geojson");
  JSONArray ja = jo.getJSONArray("features");
  println(ja.size());
}
