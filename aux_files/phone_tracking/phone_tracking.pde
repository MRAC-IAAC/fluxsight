import hypermedia.net.*;
import peasy.PeasyCam;

import org.apache.commons.math3.filter.KalmanFilter;

/**
TODO
- Calibrate DC offset feature
- Kalman filter
- Position correction with camera
- Correct for Orientation
*/

UDP udp;  // define the UDP object

PVector currentPosition = new PVector();
PVector currentVelocity = new PVector();
PVector currentAcceleration = new PVector();


public TrackerGraph orientationGraph;
public TrackerGraph accelerationGraph;
public TrackerGraph accelerationAverageGraph;
public TrackerGraph velocityGraph;


public TrackerGraph calibrationGraph;

public float frictionFactor = 0.9;

public PGraphics view3d;

public PVector accelerationDC = new PVector(0.05,0.01,0.1);

PeasyCam cam;

void setup() {
  size(1200, 800, P2D);

  setupUDP();

  accelerationGraph = new TrackerGraph(100);
  accelerationGraph.color0 = 0xFFAA5555;
  accelerationGraph.color1 = 0xFF55AA00;
  accelerationGraph.color2 = 0xFF0055AA;
  accelerationAverageGraph = new TrackerGraph(100);
  velocityGraph = new TrackerGraph(100);

  view3d = createGraphics(800, 800, P3D);

  cam = new PeasyCam(this, 400);
}


void draw() {
  background(0);
  accelerationGraph.draw();
  accelerationAverageGraph.draw();
  velocityGraph.draw();

  draw3dPreview();

  image(accelerationGraph.pg, 0, 0);
  image(accelerationAverageGraph.pg,0,0);
  image(velocityGraph.pg, 0, 400);

  image(view3d, 400, 0);
  
  PVector avg = accelerationGraph.getAverage();
  //println(avg);
}

public void draw3dPreview() {
  view3d.beginDraw();
  view3d.fill(255);

  view3d.background(50);
  
  view3d.pushMatrix();
  //view3d.translate(view3d.width / 2, view3d.height / 2);
  
  view3d.stroke(255, 0, 0);
  view3d.line(0, 0, 0, 1000, 0, 0);
  view3d.stroke(0, 255, 0);
  view3d.line(0, 0, 0, 0, 1000, 0);
  view3d.stroke(0, 0, 255);
  view3d.line(0, 0, 0, 0, 0, 1000);
  
  view3d.stroke(255,255,255,100);
  for (int i = -500; i < 500; i += 10) {
      view3d.line(-500,i,500,i);
      view3d.line(i,-500,i,500);
  }

  view3d.stroke(255);
  view3d.translate(currentPosition.x, currentPosition.y, currentPosition.z);
  view3d.sphere(10);

  view3d.popMatrix();
  view3d.endDraw();
  
  cam.getState().apply(view3d);
}
