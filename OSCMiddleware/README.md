This is a utility program to get around a seeming issue in Grasshopper's UDP implementation. When receving a constant stream of OSC input, and when downstream execution takes a significant amount of time (>200 ms though this has since been improved), some messages would get skipped entirely.
Instead of sending a single message to GH whenever a gesture fires, this utility now receives those messages first and keeps track of the ms timing of each gestures most recent firing. It then passes this whole record to GH each frame. 
GH, meanwhile, keeps a list of each most recent gesture firing its aware of. If it's current OSC data informs it of a more recent firing, only then will it execute this gesture internally and update its record. 
For this reason, this sketch must be started after the GH file is loaded, so GH can account for the difference in each programs internal timers. 

This functionality could probably have been added to the C++ program itself, but implementing it like this was quicker. 
