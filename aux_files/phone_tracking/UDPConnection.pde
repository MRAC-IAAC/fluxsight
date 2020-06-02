public void setupUDP() {
  // create a new datagram connection on port 6000
  // and wait for incomming message
  udp = new UDP( this, 6002 );
  println(udp.address());
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
}

/**
 * To perform any action on datagram reception, you need to implement this 
 * handler in your code. This method will be automatically called by the UDP 
 * object each time he receive a nonnull message.
 * By default, this method have just one argument (the received message as 
 * byte[] array), but in addition, two arguments (representing in order the 
 * sender IP address and his port) can be set like below.
 */
// void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler

  // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  String message = new String( data );
  String[] parts = message.split(",");
  float[] orientation = {Float.valueOf(parts[0]), Float.valueOf(parts[1]), Float.valueOf(parts[2])};
  float[] accel = {Float.valueOf(parts[3]), Float.valueOf(parts[4]), Float.valueOf(parts[5])};
  
  //if (abs(accel[0]) < 0.2) accel[0] = 0;
  //if (abs(accel[1]) < 0.2) accel[1] = 0;
  //if (abs(accel[2]) < 0.2) accel[2] = 0;
  
  currentAcceleration.set(accel[0],accel[1],accel[2]);

  accelerationGraph.addSample(currentAcceleration);
  
  println(currentAcceleration);
  
  PVector avgSample = accelerationGraph.getRecentWeightedAverage(5);
  
  avgSample.sub(accelerationDC);
  
  accelerationAverageGraph.addSample(avgSample);

  currentVelocity.add(avgSample);
  currentVelocity.mult(frictionFactor);
  
  currentPosition.add(currentVelocity);

  velocityGraph.addSample(currentVelocity);

  // print the result
  //println( "receive: \""+accel+"\" from "+ip+" on port "+port );
  //println(accel[0]);
  //println(accel[1]);
  //println(accel[2]);
  //println();
}
