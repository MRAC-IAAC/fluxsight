This is a modified version of the Intel Realsense SDK FF_HandsViewer C++ sample application.  
The primary modification is the integration of the OSCPack library, which creates an outgoing UDP connection to local port 7000. Each frame, the program will send an OSC message bundle consisting of the tracked hands central position (/x_pos and /y_pos), and a message for each gesture fired that frame (e.g. /spreadfingers /click etc).  
Additionally, the program will react to all gestures once any of the gestures are selected, instead of only the selected one.  

There appears to currently be a memory leak that increases when the tracker is started but no hands are visible to the camera, so the program may need to be restarted occasionally. 
