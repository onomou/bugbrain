
class Tracker {
  float[] history;
  int counter, yposition;
  Tracker(int y) {
    history = new float[width];
    yposition = y;
  }

  void feed(float v) {
    history[counter] = constrain(v, -1, 1);
    counter = (counter+1)% history.length;
  }
  void display() {
    stroke(0);
    for (int i = 1; i < history.length; i++) {
      line(i, yposition-25* history [i], i-1, yposition-25* history [i-1] );
    }
  }
}

class Periodic {
  int interval, nextFire;
  Periodic(float i) {
    interval = int(1000*i);
  }
  int run() {
    fill(0);
    text(millis(), width/2, 3*height/4);
    text(nextFire, width/2, 3*height/4+40);
    if (millis() > nextFire) {
      nextFire = (millis() + interval);
      return 1;
    } else {
      return 0;
    }
  }
}

ArrayList<Neuron> neurons;
ArrayList<Tracker> outputs;
Tracker inputTrack;
Periodic pfire = new Periodic(0.5);
int count = 0;
float[] inHistory, outHistory;

void setup() {
  frameRate(30);
  neurons = new ArrayList<Neuron>();
  neurons.add(new Neuron(50, width/3, height/2));
  neurons.add(new Neuron(100, width/2, height/2));
  neurons.add(new Neuron(50, width/2, height/4));
  neurons.add(new Neuron(100, width/4, 3*height/4));
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

int omouseX, omouseY;
boolean pmousePressed = false, connecting = false;
Neuron oNeuron;
void draw() {
  background(255);
  if (pmousePressed != mousePressed) {
    if (mousePressed) {//just pressed the mouse
      omouseX = mouseX;
      omouseY = mouseY;
      PVector m = new PVector(mouseX, mouseY);
      Neuron n = findNearest(m, neurons);
      if (isNear(m, n)) {
        n.feed(100, 1);
        line(m, n.position);
        oNeuron = n;
        connecting = true;
      }
    } else {//released mouse
      if (connecting) {
        PVector m = new PVector(mouseX, mouseY);
        Neuron n = findNearest(m, neurons);
        if (isNear(m, n)) {
          oNeuron.connect(n, 50);
        }
        connecting = false;
      }
    }
    pmousePressed = mousePressed;
  }
  if (mousePressed) {
    //neurons.get(0).feed(map(mouseY, height, 0, 0, 131), 0.5);
    //neurons.get(2).feed(map(mouseX, width, 0, 0, 131), 0.5);



    ellipse(omouseX, omouseY, 30, 30);
  }

  if (connecting) {
    stroke(0);
    line(oNeuron.position.x, oNeuron.position.y, mouseX, mouseY);
  }


  float v = sineWave(2);
  inputTrack.feed(v);//does not translate to accurate time on horizontal axis
  neurons.get(3).feed(100*v, 0.5);
  //pfire.run();
  if (v > 0.5) {
    neurons.get(3).feed(100, 1);
  }
  for (int i = 0; i < neurons.size (); i++) {
    Neuron n = neurons.get(i);
    n.display();
    int fired = n.fire();

    Tracker o = outputs.get(i);
    o.feed(fired);
    o.display();
  }
  inputTrack.display();
}

float squareWave(int period) {
  return floor(millis()/(1000*period))%2;
}

float sineWave(float period) {
  return 0.5*(sin(TAU*millis()/(1000*period))+1);//0.5*(sin(mil/4000)+1);
}
