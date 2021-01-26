class Sphere {
  float radius;
  int numRings;

  float edgePadding = radians(10);
  Ring [] rings;

  Sphere(float radius, int numRings) {
    this.radius = radius;
    this.numRings = numRings;


    rings = new Ring[numRings];
    for (int i = 0; i < numRings; i++) {
      float theta = map(i, 0, numRings-1, 0 + edgePadding, PI - edgePadding);
      rings[i] = new Ring(radius, theta);
    }
  }

  void show(float progress) {
    for (Ring ring : rings) {
      ring.show(progress);
    }
  }
}
