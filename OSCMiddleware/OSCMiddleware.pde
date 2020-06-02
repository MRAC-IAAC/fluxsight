// Receives OSC updates from the HandView application. 
// Updates records of last gesture firings and passes whole array to GH. 
// This functionality could have been added directly to the C++ application, 
// but it was relatively opaque and this was quicker. 

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int xPos = -1;
int yPos = -1;

String[] poseNames = {"click", "fist", "full_pinch", "spreadfingers", "swipe_down", "swipe_left", "swipe_right", "swipe_up", "tap", "thumb_down", "thumb_up", "two_fingers_pinch_open", "v_sign", "wave"};
int[] lastFiring = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};

int milliStart = -1;

void setup() {
  size(400, 400);

  oscP5 = new OscP5(this, 7000);

  myRemoteLocation = new NetAddress("127.0.0.1", 7001);
  frameRate(30);
}


void draw() {

  background(0);  
  OscMessage message;
  OscBundle bundle = new OscBundle();

  message = new OscMessage("/x_pos");
  message.add(xPos);
  bundle.add(message);
  message.clear();

  message = new OscMessage("/y_pos");
  message.add(yPos);
  bundle.add(message);
  message.clear();

  if (milliStart== -1) {
    milliStart = millis();
  }

  message = new OscMessage("/millis");
  message.add(millis() - milliStart);
  bundle.add(message);
  message.clear();

  for (int i =0; i< poseNames.length; i++) {
    message = new OscMessage("/" + poseNames[i]);
    message.add(lastFiring[i]);
    bundle.add(message);
    message.clear();
  }

  oscP5.send(bundle, myRemoteLocation);
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage message) {
  String addr = message.addrPattern();
  int value = message.get(0).intValue();
  int poseId = getNameId(addr);

  if (poseId != -1) {
    lastFiring[poseId] = millis();
  }

  if (addr.equals("/x_pos")) {
    xPos = value;
  } else if (addr.equals("/y_pos")) {
    yPos = value;
  }
}

public int getNameId(String name) {
  for (int i = 0; i < poseNames.length; i++) {
    if (name.equals("/" + poseNames[i])) {
      return(i);
    }
  }
  return(-1);
}
