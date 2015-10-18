import controlP5.*;

ControlP5 cp5;
//ArrayList<Neuron> neurons;
NeuronCollection neurons;
ArrayList<Tracker> outputs;
ArrayList<Connection> connections;
Tracker inputTrack;
Periodic pfire = new Periodic(0.5);
int count = 0, vposition;
String mode = "move"; // possible values: move, connect
//float[] inHistory, outHistory;
//Button addNeuronButton, interactModeButton; // interact mode: active = adding new connection, not active = moving neuron

void setup() { 
  size(2000,1500);
  cp5 = new ControlP5(this);
  //frameRate(20);
  textSize(30);
  
  cp5.addButton("newNeuron")
      .setValue(0)
      .setPosition(20, 180)
      .setSize(80, 80)
      .setLabelVisible(true)
      .setLabel("Add Neuron")
      .getCaptionLabel().setSize(30).setColor(100).align(0,13)
      ;
  cp5.addToggle("interactMode")
      .setValue(0)
      .setPosition(20, 320)
      .setSize(80, 80)
      .setLabelVisible(true)
      .setLabel("Move Mode")
      .getCaptionLabel().setSize(30).setColor(100).alignX(0)
      ;
  
  println(cp5.getController("newNeuron").getCaptionLabel().getAlign());
  
  vposition = height + 20;
  //neurons = new ArrayList<Neuron>();
  neurons = new NeuronCollection();
  neurons.add(new Neuron(50, new PVector(width/3, height/2)));
  neurons.add(new Neuron(100,new PVector(width/2, height/2)));
  neurons.add(new Neuron(50, new PVector(width/2, height/4)));
  neurons.add(new Neuron(100,new PVector(width/4, 3*height/4)));
  neurons.add(new VariableOutput(100, new PVector(width/4, height/4)));
  outputs = new ArrayList<Tracker>();
  outputs.add(new Tracker(height-140));
  outputs.add(new Tracker(height-100));
  outputs.add(new Tracker(height-60));
  outputs.add(new Tracker(height-20));
  inputTrack = new Tracker(60);
  connections = new ArrayList<Connection>();
  //addNeuronButton = new Button(new PVector(20, 60));
  //interactModeButton = new Button(new PVector(20, 120), 2);
}

int nextHeight() {
  vposition -= 40;
  return vposition;
}

//int mode = 0; //modes available: 0 viewing, 1 connecting, 2 modify neuron threshold, 3 modify synapse weight 
boolean mouseChanged = false, pmousePressed = false, connecting = false, pressedNeuron = false, active = false;
boolean objectClicked = false, disableInput = false, changingNeuronThreshold = false, changingConnectionWeight = false;
Neuron oNeuron;
Connection oConnection;
PVector mouse = new PVector(), oMouse;
String clickedObject = new String();
void draw() {
  background(255);
  /*
  Mouse events:
  * Connect neuron to neuron: click on neuron, drag to another one
  * Modify neuron threshold: click and release one neuron
  * Move connection midpoint: click and drag connection midpoint
  * Modify connection weight: click and release center of connection
  Mouse state changed
    Mouse button down
      Could be clicking on neuron, connection, or nothing
    Mouse button up
      Could have dragged to another neuron/connection, same one, or nothing
  Mouse state unchanged
    Mouse button down
      
    Mouse button up
      Nothing
  Changing neuron threshold
    Set program state to "changing neuron threshold"
    Set neuron state to receive input
    Update slider to current threshold
    Wait for mouse click and release
    Read slider value
    Write to neuron
    Set neuron state to normal
  */
  mouse.set(mouseX, mouseY);
  mouseChanged = (pmousePressed != mousePressed ? true : false);
  
  /*
  Buttons section
  */
  // BUG: will cause problems if buttons overlap
  //addNeuronButton.active = addNeuronButton.isNear(mouse);
  //interactModeButton.active = addNeuronButton.isNear(mouse);
  
  if (mouseChanged && !disableInput && !changingNeuronThreshold && !changingConnectionWeight ) {//mouse state changed
    if (mousePressed) {//pressed mouse: get closest object, set clickedObject to Neuron or Connection
      //TODO: make this neater
      //TODO: add functions for right mouse button, including delete and move neuron
      oMouse = mouse.copy();
      float neuronDistance = 10000, connectionDistance = 10000; // surely *something* will be closer than this...
      boolean nearNeuron = false, nearConnection = false; // default to not near anything
      //Neuron nearestNeuron = findNearest(mouse, neurons); // get neuron closest to mouse
      Neuron nearestNeuron = neurons.getNearest(mouse);
      if( nearestNeuron != null ) { // check to make sure a neuron exists
        neuronDistance = distSq(mouse, nearestNeuron);
        nearNeuron = nearestNeuron.isNear(mouse);
      }
      Connection nearestConnection = findNearest(mouse, connections, 1); // get connection closest to mouse
      if( nearestConnection != null ) { // check to make sure a connection exists
        connectionDistance = distSq(mouse, nearestConnection);
        nearConnection = nearestConnection.isNear(mouse);
      }
      if( nearNeuron && neuronDistance <= connectionDistance ) {             // clicked on a neuron
        clickedObject = "Neuron";
        oNeuron = nearestNeuron;
        objectClicked = true;
      } else if ( nearConnection && connectionDistance < neuronDistance ) {  // clicked on a connection
        clickedObject = "Connection";
        oConnection = nearestConnection;
        objectClicked = true;
      }
    } else {//released mouse
      if( objectClicked ) {
          if( mode.equals("connect") && clickedObject.equals("Neuron") ) { // released neuron, connecting
            //Neuron closestNeuron = findNearest(mouse, neurons);
            Neuron closestNeuron = neurons.getNearest(mouse);
            if( closestNeuron.isNear(mouse) ) {
              if( closestNeuron.id == oNeuron.id ) {                // mouse released on same neuron
                // call dialog to set threshold
                changingNeuronThreshold = true;
                //setThreshold(oNeuron);
              } else {                                              // connect to other neuron
                oNeuron.connect(closestNeuron, mouseTrace.get(mouseTrace.size()/2));
              }
            }
          } else if( mode.equals("connect") && clickedObject.equals("Connection") ) {
            if( oConnection.isNear(mouse) ) {    // mouse not dragged too far = modify connection weight
              // call dialog to set weight
              changingConnectionWeight = true;
            } else {
              oConnection.position.set(mouse);
            }
          } else if( mode.equals("move") && clickedObject.equals("Neuron") ) { // released neuron, connecting
            //Neuron closestNeuron = findNearest(mouse, neurons);
            Neuron closestNeuron = neurons.getNearest(mouse);
            if( closestNeuron.isNear(mouse) ) {
              if( closestNeuron.id == oNeuron.id ) {                // mouse released on same neuron
                // call dialog to set threshold
                changingNeuronThreshold = true;
                //setThreshold(oNeuron);
              } else {                                              // connect to other neuron
                oNeuron.connect(closestNeuron, mouseTrace.get(mouseTrace.size()/2));
              }
            }
          } else if( mode.equals("move") && clickedObject.equals("Connection") ) {
            if( oConnection.isNear(mouse) ) {    // mouse not dragged too far = modify connection weight
              // call dialog to set weight
              changingConnectionWeight = true;
            } else {
              oConnection.position.set(mouse);
            }
          }
        }
      //}
      objectClicked = false;
      clickedObject = "";
      mouseTrace.clear();
    }
    pmousePressed = mousePressed;
  }
  if ( objectClicked || changingNeuronThreshold || changingConnectionWeight ) {
    if ( clickedObject.equals("Neuron") || changingNeuronThreshold ) {
      pushStyle();
      strokeWeight(15);
      stroke(0, 0, 255);
      oNeuron.display();
      popStyle();
      stroke(0);
      line(oNeuron.position.x, oNeuron.position.y, mouseX, mouseY);
    } else if( clickedObject.equals("Connection") || changingConnectionWeight ) {
      pushStyle();
      strokeWeight(10);
      stroke(255, 0, 0);
      oConnection.display();
      popStyle();
    }
  }
  
  /* Display bar for changing threshold or weight */
  int barHeight = 50, vPosition = 30;
  if( changingNeuronThreshold ) {
    noFill();
    stroke(0);
    line(width/2,vPosition,width/2,barHeight); //TODO: change hard-coded numbers
    rect( 50,vPosition,width-100,barHeight ); //TODO: change hard-coded numbers
    fill(0,100);
    rect(width/2, vPosition, map(oNeuron.threshold, -100, 100, -(width-50)/2, (width-50)/2), barHeight); //TODO: change hard-coded numbers
  } else if( changingConnectionWeight ) {
    noFill();
    stroke(0);
    line(width/2,vPosition,width/2,barHeight); //TODO: change hard-coded numbers
    rect( 50,vPosition,width-100,barHeight ); //TODO: change hard-coded numbers
    fill(0,100);
    rect(width/2, vPosition, map(oConnection.actualWeight, -100, 100, -(width-50)/2, (width-50)/2), barHeight); //TODO: change hard-coded numbers
    fill(0,50);
    rect(width/2, vPosition, map(oConnection.currentWeight, -100, 100, -(width-50)/2, (width-50)/2), barHeight); //TODO: change hard-coded numbers
    
    
  }

  /* Render mouse trace when dragging */
  stroke(0,100);
  noFill();
  beginShape();
  for( PVector p : mouseTrace ) {
    curveVertex(p.x, p.y); // POSSIBLE BUG: may not work if p.size() < 4?
  }
  endShape();
  fill(0,100);
  if( mouseTrace.size() > 0 ) {
    circle(mouseTrace.get(mouseTrace.size()/2),20);
  }

  stroke(0);
  float v = sineWave(2,0);
  //inputTrack.feed(v);//does not translate to accurate time on horizontal axis
  //neurons.get(4).feed(100*v,100);
  neurons.feed(4,100*v,100);
  //neurons.get(3).feed(100*v, 0.5);
  /*
  for (int i = 0; i < neurons.size (); i++) {
    Neuron n = neurons.get(i);
    //n.fire();//why?
    n.display();
    n.fire();
  }
  */
  neurons.run();
  //addNeuronButton.rollOver(mouse);
  //addNeuronButton.display();
  //interactModeButton.rollOver(mouse);
  //interactModeButton.display();
  text(clickedObject, 10, 15);
}


void newNeuron(int theValue) {
  addNeuron();
}

void interactMode(boolean theFlag) {
  cp5.getController("interactMode").setLabel(theFlag ? "Connect Mode" : "Move Mode");
  mode = mode.equals("move") ? "connect" : "move";
}