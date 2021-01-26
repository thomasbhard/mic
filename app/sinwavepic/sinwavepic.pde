void setup() {

  size(600, 600);




  //saveFrame("sin.png");
}
void draw() {
    background(130, 177, 255);


  for (int i = 0; i < 200; i++) {
    beginShape();
    float i_scale = map(i, 0, 200, -1, 1);
    float i_2 = i_scale*i_scale;
    stroke(255, map(i_2, 0, 1, 5, 255));
    float amp = map(i_2, 0, 1, 100, 200);
    noFill();
    for (float a = 0; a<TWO_PI; a+=0.0001) {
      float x = map(a, 0, TWO_PI, 100, 500);
      float y = amp * sin(a) + width/2;
      vertex(x, y);
    }


    endShape();
  }
  noLoop();
}
