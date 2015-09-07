class Neuron {
  float c = 0.01; //learning constant
  float threshold = 100, sum = 0;
  int r = 70;
  int id;
  PVector position;
  ArrayList<Connection> nextNeurons;
  Tracker history;
  boolean fired = false;
  Neuron (int t, float x, float y) {
    threshold = constrain (t, -100, 100); 
    position = new PVector(x, y);
    nextNeurons = new ArrayList<Connection>();
    id = newid();
    history = new Tracker(nextHeight());
  }
  void display() {
    //stroke(0);
    //for (Connection n : nextNeurons) {
    //  line(this.position, n.target.position);
    //}
    stroke(map(threshold, -100, 100, 0, 255));
    if (fired) {
      fill(255, 0, 0);
      fired = false;
    } else {
      fill(map(sum, 0, threshold, 0, 255));
    }
    circle(position, r);
    fill(0);
    text(threshold, position.x+0.6*r, position.y+6);
    text(sum, position.x+0.6*r, position.y-6);

    for (Connection n : nextNeurons) {
      n.display();
    }
    history.display();
  }
  void connect(Neuron n, float s) {
    Connection c = new Connection(this, n, s, 1);
    nextNeurons.add(c);
  }
  void feed(float v, float w) {
    sum += v * w;
  }
  void setThreshold(float t) {
    threshold = constrain (t, -100, 100);
  }

  float fire() {
    if (sum >= threshold) {
      sum = 0;
      for (Connection n : nextNeurons) {
        n.feed();
      }
      fired = true;
      history.feed(100);
      return 100;
    } else {
      sum = 0;
      history.feed(0);
      return 0;
    }
  }
}

class VariableOutput extends Neuron {
  VariableOutput (int t, float x, float y) {
    super(t,x,y);
    history.yposition = 60;
  }
  //void display() {
  //  super();
  //}
  float fire() {
    float s = sum;
    sum = 0;
    
    for (Connection n : nextNeurons) {
      n.value = s;
        n.feed();
      }
      
    history.feed(s);
    return s;
  }
}

class Trainer {
  float[] inputs; 
  int answer; 
  Trainer(float x, float y, int a) {
    inputs = new float[3]; 
    inputs[0] = x; 
    inputs[1] = y;
    inputs[2] = 1; 
    answer = a;
  }
}

float f(float x) { 
  return 2*x+1;
}

class Connection {
  Neuron origin, target;
  float value, weight;
  Connection(Neuron o, Neuron t, float v, float w) {
    origin = o;
    target = t;
    value = v;
    weight = constrain(w, -1, 1);
  }
  void display() {
    PVector arrow = PVector.sub(target.position,origin.position).normalize();
    
    lineArrow(origin.position+arrow, target.position);
    text(value,(origin.position.x+target.position.x)/2+5, (origin.position.y+target.position.y)/2-6);
    text(weight,(origin.position.x+target.position.x)/2+5, (origin.position.y+target.position.y)/2+6);
  }
  void feed() {
    target.feed(value, weight);
  }
}
