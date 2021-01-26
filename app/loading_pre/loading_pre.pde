int totalFrames = 480;
int counter = 0;
boolean record = false;
float progress = 0;


float radius = 200;
Sphere s, s2, s3, s4;
PImage [] images;

int ind = 0;
float angle = 0;

void setup() {
  size(600, 600, P3D);
  background(255,0);


  images = new PImage[9];
  images[0] = loadImage("cel-50.png");
  images[1] = loadImage("cla-50.png");
  images[2] = loadImage("flu-50.png");
  images[3] = loadImage("gel-50.png");
  images[4] = loadImage("gac-50.png");
  images[5] = loadImage("org-50.png");
  images[6] = loadImage("pia-50.png");
  images[7] = loadImage("sax-50.png");
  images[8] = loadImage("tru-50.png");



  s = new Sphere(radius, 10);
  s2 = new Sphere(radius, 10);
  s3 = new Sphere(radius, 10);
  s4 = new Sphere(radius, 10);
}


void draw() {
  float percent = 0;
  if (record) {
    percent = float(counter) / totalFrames;
  } else {
    percent = float(counter % totalFrames) / totalFrames;
  }
  render(percent);
  if (record) {
    saveFrame("output/gif-"+nf(counter, 3)+".png");
    if (counter == totalFrames-1) {
      exit();
    }
  }

  counter++;
}

void render(float percent) {
  progress = percent;
  background(255, 0);
  stroke(0);
  strokeWeight(1);
  //line(0, 5, map(percent, 0, 1, 0, width), 5);
  translate(width/2, height/2, -200);

  ind = floor(map( progress, 0, 1, 0, 30)) % images.length;
  imageMode(CENTER);
  image(images[ind], 0, 0, 100, 100);

  angle = map(percent, 0, 1, 0, TWO_PI);

  s.show(progress);

  rotateX(2*PI/6);
  s2.show(progress);

  rotateX(2*PI/6);
  s3.show(progress);
  rotateY(PI/8);
  rotateX(2*PI/6);
  s4.show(progress);
}
