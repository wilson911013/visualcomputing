import frames.timing.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = false;
boolean aliasing = true;
boolean shading = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

void setup() {
  //use 2^n to change the dimensions
  size(720, 720, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it :)
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0,0,1) :
      yDirection ? new Vector(0,1,0) : new Vector(1,0,0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow( 2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

float f_ab(float x, float y, Vector pa, Vector pb) {
  return (pa.y() - pb.y()) * x + (pb.x() - pa.x()) * y + pa.x()*pb.y() - pb.x()*pa.y();
}

void PixelPaint(float pointx, float pointy, float trans) {
  stroke(0,255,0,trans);
  point(pointx, pointy);
}

void shadingPixel(float pointx, float pointy, float trans, float r, float g, float b) {
  stroke(r*255,g*255,b*255,trans);
  point(pointx, pointy);
}

void rastering() {
 
  Vector pv1 = frame.location(v1);
  Vector pv2 = frame.location(v2);
  Vector pv3 = frame.location(v3);
  for (float x = -(pow(2,n-1));x<(pow(2,n-1));x++){
    for (float y = -(pow(2,n-1));y<(pow(2,n-1)); y++){
      float pointx = x + 0.5; 
      float pointy = y + 0.5; 
      
      float alpha = f_ab(pointx, pointy, pv2, pv3) / f_ab(pv1.x(), pv1.y(), pv2, pv3);
      float theta = f_ab(pointx, pointy, pv3, pv1) / f_ab(pv2.x(), pv2.y(), pv3, pv1);
      float gamma = f_ab(pointx, pointy, pv1, pv2) / f_ab(pv3.x(), pv3.y(), pv1, pv2);
      
      if(alpha >= 0 &&  alpha <= 1 && theta >= 0 &&  theta <= 1 && gamma >= 0 &&  gamma <= 1)
        if(shading)
          shadingPixel(pointx, pointy, 200, alpha, theta, gamma);
        else
          PixelPaint(pointx, pointy,200);
    }
  }
}

void AntiAliasingRast() {
  
  Vector pv1 = frame.location(v1);
  Vector pv2 = frame.location(v2);
  Vector pv3 = frame.location(v3);
  for (float x = -(pow(2,n-1));x<(pow(2,n-1));x++){
    for (float y = -(pow(2,n-1));y<(pow(2,n-1)); y++){
      
      float cont = 0f;
      float pointx = x;
      float pointy = y; 
      float alpha = 0, theta = 0, gamma = 0;
      
      for(float i = 0.25; i < 1; i+=0.50) {
        for(float j = 0.25; j < 1; j+=0.50) {
            
            pointx = x + i;
            pointy = y + j; 
            
            alpha = f_ab(pointx, pointy, pv2, pv3) / f_ab(pv1.x(), pv1.y(), pv2, pv3);
            theta = f_ab(pointx, pointy, pv3, pv1) / f_ab(pv2.x(), pv2.y(), pv3, pv1);
            gamma = f_ab(pointx, pointy, pv1, pv2) / f_ab(pv3.x(), pv3.y(), pv1, pv2);
            
            if(alpha >= 0 &&  alpha <= 1 && theta >= 0 &&  theta <= 1 && gamma >= 0 &&  gamma <= 1)
              cont++;
        }
      }
      
      if(cont>0 && cont<5) {
        if(shading)
          shadingPixel(pointx, pointy, (cont/4.0)*200, alpha, theta, gamma);
        else
          PixelPaint(pointx, pointy, (cont/4.0)*200);
      }
    }
  }
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  // frame.location converts from world to frame
  // here we convert v1 to illustrate the idea
  
  if(!aliasing)
    rastering();
  else
    AntiAliasingRast();
  
  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    point(round(frame.location(v1).x()), round(frame.location(v1).y()));
    popStyle();
  }
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}



void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
  if (key == 's')
    shading = !shading;
  if (key == 'a')
    aliasing = !aliasing;
    
}
