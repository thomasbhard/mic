class Ring {
  float radius;
  float theta;
  PVector curr;
  float randomPhiOffset = random(0, TWO_PI);
  int numPoints = 1000;
  int showPoints = 100;

  PVector [] points;

  Ring(float radius, float theta) {
    this.radius = radius;
    this.theta = theta;
    this.points = new PVector[numPoints];

    for (int i = 0; i < numPoints; i++) {
      float phi = map(i, 0, numPoints, 0, TWO_PI);
      float x = radius * cos(phi + randomPhiOffset) * sin(theta);
      float y = radius * sin(phi + randomPhiOffset) * sin(theta);
      float z = radius * cos(theta);
      points[i] = new PVector(x, y, z);
    }
  }


  void show(float progress) {
    int ind = floor(map(progress, 0, 1, 0, 5 * numPoints)); 

    // LINES
    PVector prev = points[ind%numPoints];
    for (int i = 1; i < showPoints; i++) {
      PVector p = points[(ind + i) % numPoints];
      stroke(68, 138, 255, map(i, 0, showPoints-1, 255, 55));
      strokeWeight(2);
      line(p.x, p.y, p.z, prev.x, prev.y, prev.z);
      prev = p;
    }
  }
}
