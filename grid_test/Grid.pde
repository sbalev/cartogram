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
  PVector tmp;

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
    tmp = new PVector();
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

  /**
   * Tries to fill the quad array with the corners of a cell
   * starting from the vertex (i, j) in direction d and turning clockwise.
   * Returns true iff it does not go out of the grid.
   */
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

  // Computes the cell areas
  void computeAreas() {
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        fillQuad(i, j, 0);
        areas[i][j] = polygonArea(quad);
      }
    }
  }


  /**
   * Consider the 4 (or less) cells incident to the vertex v at position (i,j)
   * Let A_d(x,y) d=0..3 be the areas of these cells as functions of the coordinates of v
   * Let E(x,y) = sum_d (A_d(x,y) - targetA_d)^2
   * This method computes -gradF(v.x, v.y) and stores it in gradients[i][j]
   * Moving v in this direction will make the squared error E smaller.
   */
  void computeGradient(int i, int j) {
    gradients[i][j].set(0, 0);
    // loop on the four possible incident cells
    for (int d = 0; d < 4; d++) {
      if (fillQuad(i, j, d)) {
        // Now we have to find the upper left corner of the cell
        // Let's use some integer trigonomagic instead of a bunch of ifs
        int iCell = i + isin((7 * d + 1) / 2);
        int jCell = j - isin((d + 1) / 2);
        float dArea = areas[iCell][jCell] - targetAreas[iCell][jCell];
        tmp.set(quad[1].y - quad[3].y, quad[3].x - quad[1].x);
        gradients[i][j].sub(tmp.mult(dArea));
      }
    }
  }
  
  // Computes the gradients of the vertices
  void computeGradients() {
    for (int i = 0; i <= n; i++) {
      for (int j = 0; j <= n; j++) {
        computeGradient(i, j);
      }
    }
  }
  
  // Moves the vertices along their gradients at a given distance
  void moveOnGradients(float distance) {
    for (int i = 0; i <= n; i++) {
      for (int j = 0; j <= n; j++) {
        vertices[i][j].add(gradients[i][j].setMag(tmp, distance));
      }
    }
  }
  
  // Computes the mean squared area error
  float meanSqError() {
    float error = 0;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        error += sq(areas[i][j] - targetAreas[i][j]);
      }
    }
    return error / sq(n);
  }
}
