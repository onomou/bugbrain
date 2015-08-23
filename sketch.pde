
/*
class Input {
  float value, weight;
  float[] history;
  int counter;
  Input(float v, float w) {
    value = v;
    weight = constrain(w, -1, 1);
    history = new float[1];
    counter = 0;
  }
  Input(float v, float w, int historyLength) {
    value = v;
    weight = constrain(w, -1, 1);
    history = new float[historyLength];
    counter = 0;
  }
  void feed(float v) {
    history[counter] = value * weight;
    value = v;
    counter = (counter+1)%history.length;
  }
  float value() {
    return value*weight;
  }
  void display() {
    stroke(0);
    for (int i = 1; i < counter+2; i++) {
      line(i, 75-25* history [i], i-1, 75-25* history [i-1] );
    }
  }
}
*/
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

//Neuron n1, n2;
ArrayList<Neuron> neurons;
ArrayList<Tracker> outputs;
Tracker inTrack;
Periodic pfire = new Periodic(0.5);
int count = 0;
float[] inHistory, outHistory;

void setup() {
  //n1 = new Neuron(100, width/2, height/2);
  //n2 = new Neuron(100, width/2, height/4);
  neurons = new ArrayList<Neuron>();
  neurons.add(new Neuron(50, width/3, height/2));
  neurons.add(new Neuron(100, width/2, height/2));
  neurons.add(new Neuron(50, width/4, height/4));
  neurons.add(new Neuron(100, width/4, 3*height/4));
  neurons.get(0).connect(neurons.get(1), 50);
  neurons.get(2).connect(neurons.get(1), 45);
  neurons.get(3).connect(neurons.get(1), 45);
  outputs = new ArrayList<Tracker>();
  outputs.add(new Tracker (height-140));
  outputs.add(new Tracker (height-100));
  outputs.add(new Tracker (height-60));
  outputs.add(new Tracker (height-20));
  //n1.connect(n2);
  //inHistory = new float[width];
  //outHistory = new float[width];
  inTrack = new Tracker(20);
  //outTrack = new Tracker(height-100);
}

//int b = 0;
void draw() {
  //b++;
  //b %= width;
  //int counter = b;//int(millis()/100) % width;
  if (mousePressed) {
    neurons.get(0).feed(map(mouseY, height, 0, 0, 131), 0.5);
    neurons.get(2).feed(map(mouseX, width, 0, 0, 131), 0.5);

    //n1.feed(new Input(map(mouseY, height, 0, 0, 111), 0.5));
  }
  float v = sineWave(2);
  inTrack.feed(v);//may be where spatial resolution degrades
  neurons.get(3).feed(100*v, 0.5);
  //inHistory[counter] = v;
  //n2.feed(new Input(v*100, 0.5));
  background(255);
  //pfire.run();
  if (v > 0.5) {
    //n1.feed(new Input(100, 0.5));
    neurons.get(3).feed(100, 1);
  }
  //n1.display();
  //n2.display();
  //n1.fire();
  //n2.fire();
  for (int i = 0; i < neurons.size (); i++) {
    Neuron n = neurons.get(i);
    Tracker o = outputs.get(i);
    n.display();
    int fired = n.fire();
    o.feed(fired);
    o.display();
  }
  inTrack.display();
  //outTrack.display();
}

float squareWave(int period) {
  return floor(period/1000)%2;
}

float sineWave(float period) {
  return 0.5*(sin(TAU*millis()/(1000*period))+1);//0.5*(sin(mil/4000)+1);
}
