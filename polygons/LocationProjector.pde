/**
* Uses Mercator projection to convert (longitude, latitude) to window coordinates
* Adapted from another side project of mine
* I use this technique in order to be able to put OSM tiles under the polygons
* References:
* https://en.wikipedia.org/wiki/Web_Mercator_projection
* https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames
*/

class LocationProjector {
  int tileX0, tileY0;
  int zoom;
  
  LocationProjector(int winSize, PVector nw, PVector se) {
    int tileCount = winSize / 256;
    zoom = 19;
    int x, y;
    do {
      zoom--;
      tileX0 = int(tileX(nw.x));
      tileY0 = int(tileY(nw.y));
      x = int(tileX(se.x));
      y = int(tileY(se.y));
    } while (x - tileX0 >= tileCount || y - tileY0 >= tileCount);
  }
  
  int winX(float longitude) {
    return int((tileX(longitude) - tileX0) * 256);
  }
  
  int winY(float latitude) {
    return int((tileY(latitude) - tileY0) * 256);
  }
  
  float tileX(float longitude) {
    return (longitude + 180) / 360 * (1 << zoom);
  }
  
  float tileY(float latitude) {
    float r = radians(latitude);
    return (1 - log(tan(r) + 1 / cos(r)) / PI) * (1 << (zoom - 1));
  }
  
  String toString() {
    return zoom + "/" + tileX0 + "/" + tileY0;
  }
}
