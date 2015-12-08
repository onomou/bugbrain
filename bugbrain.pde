import controlP5.*;

ControlP5 cp5;
NeuronCollection neurons;
ArrayList<Connection> connections; // TODO: replace connections array - it is only used to find the nearest connection for move/change weight
String mode = "Move"; // possible values: move, connect
int globalTrackerLength, globalTrackerIndex = 0;

void setup() { 
  size(2000, 1500);
  cp5 = new ControlP5(this);
  // frameRate(20);
  textSize(30);

  cp5.addButton("newNeuron")
    .setValue(0)
    .setPosition(20, 180)
    .setSize(80, 80)
    .setLabelVisible(true)
    .setLabel("Add Neuron")
    .getCaptionLabel().setSize(30).setColor(100).align(0, 13)
    ;
  cp5.addToggle("interactMode")
    .setValue(0)
    .setPosition(20, 320)
    .setSize(80, 80)
    .setLabelVisible(true)
    .setLabel("Move Mode")
    .getCaptionLabel().setSize(30).setColor(100).alignX(0)
    ;

  vposition = height + 20;
  trackerBaseline = height - 20;
  globalTrackerLength = width;
  // neurons = new ArrayList<Neuron>();
  neurons = new NeuronCollection();
  neurons.add(new VariableOutput(100, new PVector(width/4, height/4)));
  neurons.add(new VariableOutput(100, new PVector(3*width/4, height/4)));
  neurons.add(new Neuron(50, new PVector(width/3, height/2), neurons.getNextTrackerPosition()));
  neurons.add(new Neuron(100, new PVector(width/2, height/2), neurons.getNextTrackerPosition()));
  neurons.add(new Neuron(50, new PVector(width/2, height/4), neurons.getNextTrackerPosition()));
  neurons.add(new Neuron(100, new PVector(width/4, 3*height/4), neurons.getNextTrackerPosition()));
  connections = new ArrayList<Connection>();

  //neurons.neurons.get(1).attachInput();//new Input("sineWave",2,1));
  //ArrayList<Input> ipts = new ArrayList<Input>();
  //ipts.add(ipt);
  //for(Input i : ipts) {
  //  i.run();
  //}
}

Input ipt = new Input("sineWave", 2, 1);

int trackerBaseline;
int vposition;
// TODO: Fix this right
int nextHeight() {
  vposition -= 40;
  return vposition;
}


boolean objectClicked = false, disableInput = false, changingNeuronThreshold = false, changingConnectionWeight = false;
Neuron oNeuron;
Connection oConnection;
PVector mouse = new PVector(), oMouse;
String clickedObject = new String(), hoveredObject = new String();
void draw() {
  background(255);
  mouse.set(mouseX, mouseY);
  if ( !changingNeuronThreshold && !changingConnectionWeight ) {
    neurons.rollOver(mouse);
  }

  /* Display bar for changing threshold or weight */
  int barHeight = 50, vPosition = 30;
  if ( changingNeuronThreshold ) {
    noFill();
    stroke(0);
    line(width/2, vPosition, width/2, barHeight); // TODO: change hard-coded numbers
    rect( 50, vPosition, width-100, barHeight ); // TODO: change hard-coded numbers
    fill(0, 100);
    rect(width/2, vPosition, map(oNeuron.threshold, -100, 100, -(width-50)/2, (width-50)/2), barHeight); // TODO: change hard-coded numbers
  } else if ( changingConnectionWeight ) {
    noFill();
    stroke(0);
    line(width/2, vPosition, width/2, barHeight); // TODO: change hard-coded numbers
    rect( 50, vPosition, width-100, barHeight ); // TODO: change hard-coded numbers
    fill(0, 100);
    rect(width/2, vPosition, map(oConnection.actualWeight, -100, 100, -(width-50)/2, (width-50)/2), barHeight); // TODO: change hard-coded numbers
    fill(0, 50);
    rect(width/2, vPosition, map(oConnection.currentWeight, -100, 100, -(width-50)/2, (width-50)/2), barHeight); // TODO: change hard-coded numbers
  }

  /* Render mouse trace when dragging */
  stroke(0, 100);
  noFill();
  beginShape();
  for ( PVector p : mouseTrace ) {
    curveVertex(p.x, p.y); // POSSIBLE BUG: may not work if p.size() < 4?
  }
  endShape();
  fill(0, 100);
  if ( mouseTrace.size() > 0 ) {
    circle(mouseTrace.get(mouseTrace.size()/2), 20);
  }
  stroke(0);

  /* Run main stuff */
  float v = sineWave(2, 0);
  neurons.feed(0, 100*v, 100);
  neurons.run();
  text(hoveredObject, 10, 35);
  hoveredObject = "";

  if ( globalTrackerIndex >= globalTrackerLength-1 ) {
    globalTrackerIndex = 0;
  } else {
    globalTrackerIndex++;
  }
}

/* ControlP5 button handlers */
void newNeuron(int theValue) {
  neurons.add(new PVector(width/2, height/2));
}
void interactMode(boolean theFlag) {
  cp5.getController("interactMode").setLabel(theFlag ? "Connect Mode" : "Move Mode");
  mode = mode.equals("Move") ? "Connect" : "Move";
}