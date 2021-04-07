/**
* This class distorts a regular grid of n x n square cells so that each cell has a predefined area.
*/

class Grid {
  // To simplify, let's use a square grid and square cells
  int n; // number of lines / columns
  float cellSize;
  
  // arrays of size (n + 1) x (n + 1)
  PVector[][] vertices;
  PVector[][] gradients;
  
  // arrays of size n x n
  float[][] areas;
  float[][] targetAreas;
  
  // some work variables in order to avoid creating PVectors all the time
  PVector[] quad; // used to store the corners of a cell
  
  Grid(float x0, float y0, int n, float cellSize) {
    this.n = n;
    this.cellSize = cellSize;
    
    vertices = new PVector[n + 1][n + 1];
    gradients = new PVector[n + 1][n + 1];
    for (int i = 0; i <= n; i++) {
      for (int j = 0; j <= n; j++) {
        vertices[i][j] = new PVector(x0 + j * cellSize, y0 + i * cellSize);
        gradients[i][j] = new PVector();
      }
    }
    
    areas = new float[n][n];
    targetAreas = new float[n][n];
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        areas[i][j] = cellSize * cellSize;
        // Target areas are randomly generated for the moment but they will be an input later
        targetAreas[i][j] = random(0.5, 1.5) * areas[i][j];
      }
    }
    
    quad = new PVector[4];
  }
  
  // draws the cell bounaries
  void display() {
    for (int i = 0; i <= n; i++) {
      for (int j = 0; j < n; j++) {
        lineSegment(vertices[i][j], vertices[i][j + 1]);
        lineSegment(vertices[j][i], vertices[j + 1][i]);
      }
    }
  }
  
  /*** Some helpers ***/
  
  // checks if (i,j) is a valid vertex index
  boolean isValidVertex(int i, int j) {
    return 0 <= i && i <= n && 0 <= j && j <= n;
  }
  
  // Tries to fill the quad array with the corners of a cell
  // starting from the vertex (i, j) in direction d and turning clockwise.
  // Returns true iff it does not go out of the grid.
  boolean fillQuad(int i, int j, int d) {
    for (int k = 0; k < 4; k++) {
      if (!isValidVertex(i, j)) return false;
      quad[k] = vertices[i][j];
      i += isin(d);
      j += icos(d);
      d++;
    }
    return true;
  }
}
