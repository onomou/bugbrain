
ArrayList<Neuron> neurons;
ArrayList<Tracker> outputs;
Tracker inputTrack;
Periodic pfire = new Periodic(0.5);
int count = 0, vposition;
//float[] inHistory, outHistory;

void setup() {
  frameRate(30);
  vposition = height + 20;
  neurons = new ArrayList<Neuron>();
  neurons.add(new Neuron(50, width/3, height/2));
  neurons.add(new Neuron(100, width/2, height/2));
  neurons.add(new Neuron(50, width/2, height/4));
  neurons.add(new Neuron(100, width/4, 3*height/4));
  neurons.add(new VariableOutput(100, width/4, height/4));
  //neurons.get(0).connect(neurons.get(1), 50);
  //neurons.get(2).connect(neurons.get(1), 45);
  //neurons.get(3).connect(neurons.get(1), 45);
  outputs = new ArrayList<Tracker>();
  outputs.add(new Tracker(height-140));
  outputs.add(new Tracker(height-100));
  outputs.add(new Tracker(height-60));
  outputs.add(new Tracker(height-20));
  inputTrack = new Tracker(60);
}

int nextHeight() {
  vposition -= 40;
  return vposition;
}

int omouseX, omouseY;
int mode = 0; //modes available: 0 viewing, 1 connecting, 2 modify neuron threshold, 3 modify synapse weight 
boolean pmousePressed = false, connecting = false, pressedNeuron = false;
Neuron oNeuron;
void draw() {
  background(255);
  if (pmousePressed != mousePressed) {//mouse state changed
    if (mousePressed) {//pressed the mouse
      if (mode == 2) {
        //text(map(mouseY, omouseY, height, oNeuron.threshold, 120), omouseX, omouseY);
      } else {
        omouseX = mouseX;
        omouseY = mouseY;
        PVector m = new PVector(mouseX, mouseY);
        Neuron n = findNearest(m, neurons); //find neuron nearest mouse press
        if (isNear(m, n)) {//neuron is near enough to mouse
          //? n.feed(100, 1);
          //line(m, n.position);
          oNeuron = n;
          pressedNeuron = true;
        }
      }
    } else {//released mouse
      if ( mode == 2 ) {
        oNeuron.setThreshold(map(mouseY, height/2, height, 0, 110));
        mode = 0;
      } else if ( pressedNeuron ) {//previously pressed on neuron
        PVector m = new PVector(mouseX, mouseY);
        Neuron n = findNearest(m, neurons);

        if (isNear(m, n)) {
          if (oNeuron.id != n.id) {//different neuron than original pressed
            oNeuron.connect(n, 50);
            mode = 0;
          } else {//same neuron, just a click
            mode = 2;
            //oNeuron.setThreshold(map(mouseY, omouseY, height, oNeuron.threshold, 120));
          }
        }
        pressedNeuron = false;
      }
    }
    pmousePressed = mousePressed;
  }
  if (mousePressed) {
    //neurons.get(0).feed(map(mouseY, height, 0, 0, 131), 0.5);
    //neurons.get(2).feed(map(mouseX, width, 0, 0, 131), 0.5);


    if ( pressedNeuron ) {
      fill(0, 0, 255);
      circle( oNeuron.position, oNeuron.r * 1.3 );
      stroke(0);
      line(oNeuron.position.x, oNeuron.position.y, mouseX, mouseY);
    }
    if( mode == 2 ) {
      oNeuron.setThreshold(map(mouseY, height/2, height, 0, 110));
    }
  }
  if (mode == 2) {
    fill(0, 255, 0);
    circle( oNeuron.position, oNeuron.r * 1.3 );
  }


  float v = sineWave(2);
  //inputTrack.feed(v);//does not translate to accurate time on horizontal axis
  neurons.get(4).feed(100*v,1);
  //neurons.get(3).feed(100*v, 0.5);
  for (int i = 0; i < neurons.size (); i++) {
    Neuron n = neurons.get(i);
    n.display();
    n.fire();

    //Tracker o = outputs.get(i);
    //o.feed(fired);
    //o.display();
  }
  //inputTrack.display();
}
