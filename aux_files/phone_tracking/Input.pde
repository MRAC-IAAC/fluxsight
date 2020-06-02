/** 
 * on key pressed event:
 * send the current key value over the network
 */
void keyPressed() {
    
    //String message  = str( key );  // the message to send
    //String ip       = "localhost";  // the remote IP address
    //int port        = 6100;    // the destination port
    
    //// formats the message for Pd
    //message = message+";\n";
    //// send the message
    //udp.send( message, ip, port );
    
    currentPosition.set(0,0,0);
    currentVelocity.set(0,0,0);
    
}
