class NeuronCollection {
  ArrayList<Neuron> neurons;
  NeuronCollection() {
    neurons = new ArrayList<Neuron>();
  }
  void add(Neuron n) {
    neurons.add(n);
  }
  void add(PVector p) {
    if( isNear(p) ) {
      p.add(70 + 10, 0); // TODO: change hard-coded number to refer to neuron's default size
      this.add(p);       // recursive, keep going right until empty space
    } else {
      this.add(new Neuron(50, p));
    }
  }
  void remove(PVector p) { // TODO: this will be problematic - need to destroy neuron and associated connections
    for( int i = 0; i < neurons.size(); i++ ) {
      if( neurons.get(i).isNear(p) ) {
        //neurons.get(i).
        neurons.remove(i);
        break;
      }
    }
  }
  void run() {
    for (int i = 0; i < neurons.size (); i++) {
      //Neuron n = neurons.get(i); // TODO: is this more efficient?
      //n.fire();                  // why does it have to do display before fire?
      neurons.get(i).display();
      neurons.get(i).fire();
    }
  }
  void feed(int whichone, float value, float weight) {
    if( whichone < neurons.size() ) {
      neurons.get(whichone).feed(value, weight);
    }
  }
  boolean isNear(PVector p) { // TODO: may not work because two neurons' radii could collide?
    for( Neuron n : neurons ) {
      if( n.isNear(p) ) {
        return true;
      }
    }
    return false;
  }
  /*
  Neuron getNear(PVector p) { // BUG: does not return *nearest* neuron
    for( Neuron n : neurons ) {
      if( n.isNear(p) ) {
        return n;
      }
    }
    return null; // bad choice, should always call isNear() first
  }
  */
  Neuron getNearest(PVector pos) {
    return findNearest(pos, neurons);
  }
}

//ArrayList<Neuron> neurons;
NeuronCollection neurons;
ArrayList<Tracker> outputs;
ArrayList<Connection> connections;
Tracker inputTrack;
Periodic pfire = new Periodic(0.5);
int count = 0, vposition;
//float[] inHistory, outHistory;
Button addNeuronButton, interactModeButton; // interact mode: active = adding new connection, not active = moving neuron

void setup() {
  size(1000,1000);
  frameRate(20);
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
  addNeuronButton = new Button(new PVector(20, 60));
  interactModeButton = new Button(new PVector(20, 120), 2);
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
  addNeuronButton.active = addNeuronButton.isNear(mouse);
  interactModeButton.active = addNeuronButton.isNear(mouse);
  
  if (mouseChanged && !disableInput && !changingNeuronThreshold && !changingConnectionWeight ) {//mouse state changed
    if (mousePressed) {//pressed mouse
      //TODO: make this neater
      //TODO: add functions for right mouse button, including delete and move neuron
      oMouse = mouse.get();
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
      if( objectClicked && clickedObject.equals("Neuron") ) {
        //Neuron closestNeuron = findNearest(mouse, neurons);
        Neuron closestNeuron = neurons.getNearest(mouse);
        if( closestNeuron.isNear(mouse) ) {
          if( closestNeuron.id == oNeuron.id ) {                // mouse released on same neuron
            // call dialog to set threshold
            changingNeuronThreshold = true;
            //setThreshold(oNeuron);
          } else {                                              // connect to other neuron
            oNeuron.connect(closestNeuron, 50, mouseTrace.get(mouseTrace.size()/2));
          }
        }
      } else if( objectClicked && clickedObject.equals("Connection") ) {
        if( oConnection.isNear(mouse) ) {    // mouse not dragged too far = modify connection weight
          // call dialog to set weight
          changingConnectionWeight = true;
        } else {
          oConnection.position.set(mouse);
        }
      }
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
  if( changingNeuronThreshold ) {
    noFill();
    stroke(0);
    line(width/2,50,width/2,100); //TODO: change hard-coded numbers
    rect( 50,50,width-100,50 ); //TODO: change hard-coded numbers
    fill(0,100);
    rect( 50,50,map(oNeuron.threshold,-100,100,0,width-100),50 ); //TODO: change hard-coded numbers
  } else if( changingConnectionWeight ) {
    noFill();
    stroke(0);
    line(width/2,50,width/2,100); //TODO: change hard-coded numbers
    rect( 50,50,width-100,50 ); //TODO: change hard-coded numbers
    fill(0,100);
    rect( 50,50,map(oConnection.weight,-100,100,0,width-100),50 ); //TODO: change hard-coded numbers
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
  addNeuronButton.rollOver(mouse);
  addNeuronButton.display();
  interactModeButton.rollOver(mouse);
  interactModeButton.display();
  text(clickedObject, 10, 15);
}

class Button extends PositionalThing {
  boolean active = false;
  int modes, currentMode;
  Button(PVector p) {
    super(p);
    size = 50;
    modes = 1;
    currentMode = 0;
  }
  Button(PVector p, int modes) {
    super(p);
    size = 50;
    this.modes = modes;
    currentMode = 0;
  }
  void display() {
    if(active) {
      fill(100,100,0,200);
    } else {
      if( modes <= 1 ) {
        fill(100,100,0,100);
      } else {
        fill(100,100,map(currentMode,0,modes-1,0,255),100);
      }
    }
    rect(position, size, size);
  }
  boolean isNear(PVector p) {
    if ( p.x > position.x && p.x < position.x + size && p.y > position.y && p.y < position.y + size ) { //TODO: should reference p's size
      return true;
    } else {
      return false;
    }
  }
  void rollOver(PVector p) {
    if( this.isNear(p) ) {
      active = true;
    } else {
      active = false;
    }
  }
  void click() {
    currentMode++;
    currentMode %= modes;
  }
}
class ButtonCollection {
  ArrayList<Button> buttons;
  ButtonCollection() {
    buttons = new ArrayList<Button>();
  }
  void addButton(Button b) {
    buttons.add(b);
  }
  void addButton(PVector p) {
    buttons.add(new Button(p));
  }
  void display() {
    for(Button b : buttons) {
      b.display();
    }
  }
  void hoverOver(PVector p) {
    
  }
}