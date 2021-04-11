import java.util.Iterator;

final int CELL_SIZE = 16;

ArrayList<GeoFeature> departments;
Table populationTab;

int[] areas;
float[] populations;
float[] pixelAreas;
float[][] cellAreas;

void setup() {
  size(1536, 1536);
  departments = loadFeatures("departements-20140306-100m.geojson");

  // remove DOM
  Iterator<GeoFeature> it = departments.iterator();
  while (it.hasNext()) {
    if (it.next().id.startsWith("97")) it.remove();
  }

  project();

  // draw departments with different colors
  noSmooth();
  background(255);
  noStroke();
  int c = 0;
  for (GeoFeature dept : departments) {
    fill(c++);
    dept.display();
  }

  // compute area (in pixels) per color
  areas = new int[256];
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    areas[int(brightness(pixels[i]))]++;
  }

  // load population data
  populationTab = loadTable("population.tsv", "header");
  populations = new float[256];
  for (int i = 0; i < departments.size(); i++) {
    populations[i] = getPopulation(departments.get(i).id);
  }

  // compute the density
  int totalArea = 0;
  float totalPopulation = 0;
  for (int i = 0; i < departments.size(); i++) {
    totalArea += areas[i];
    totalPopulation += populations[i];
  }
  float density = totalPopulation / totalArea;

  // target areas for one pixel per color
  pixelAreas = new float[256];
  for (int i = 0; i < departments.size(); i++) {
    pixelAreas[i] = populations[i] / areas[i] / density;
  }
  pixelAreas[255] = 1;

  // target cell areas
  cellAreas = new float[height / CELL_SIZE][width / CELL_SIZE];
  int i = 0;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      cellAreas[y / CELL_SIZE][x / CELL_SIZE] += pixelAreas[int(brightness(pixels[i++]))];
    }
  }
  saveCellAreas();
}

void saveCellAreas() {
  String[] strings = new String[cellAreas.length];
  for (int i = 0; i < strings.length; i++) {
    strings[i] = join(nf(cellAreas[i]), ", ");
  }
  saveStrings("data/targetAreas.txt", strings);
}

float getPopulation(String id) {
  for (TableRow row : populationTab.rows()) {
    if (row.getString("code").equals(id)) return row.getFloat("population");
  }
  return 0;
}

void project() {
  PVector nw = new PVector(0, 49);
  PVector se = new PVector(0, 49);
  for (GeoFeature dept : departments) dept.boundingBox(nw, se);
  println("Bounding box", nw, se);
  LocationProjector proj = new LocationProjector(width, nw, se);
  println("projector", proj);
  for (GeoFeature dept : departments) dept.project(proj);
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
    // println(code, nom, coord.size());
    GeoPolygon[] multiPoly = new GeoPolygon[coord.size()];
    for (int j = 0; j < coord.size(); j++) {
      multiPoly[j] = new GeoPolygon(coord.getJSONArray(j));
    }
    geoFeatures.add(new GeoFeature(code, nom, multiPoly, color(2 * i)));
  }
  return geoFeatures;
}
