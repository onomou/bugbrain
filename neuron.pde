class Neuron {
  float c = 0.01; //learning constant
  float threshold = 100, sum = 0;
  PVector position;
  ArrayList<Connection> nextNeurons;
  boolean fired = false;
  Neuron (int t, float x, float y) {
    threshold = constrain (t, -100, 100); 
    position = new PVector(x, y);
    nextNeurons = new ArrayList<Connection>();
  }
  void display() {
    stroke(0);
    for (Connection n : nextNeurons) {
      line(this.position, n.target.position);
    }
    stroke(map(threshold, -100, 100, 0, 255));
    if (fired) {
      fill(255, 0, 0);
      fired = false;
    } else {
      fill(map(sum, 0, threshold, 0, 255));
    }
    circle(position, 60);
    fill(0);
    text(sum, position.x+10, position.y);

    for (Connection n : nextNeurons) {
      lineArrow(this.position, n.target.position);
    }
  }
  //void connect(Neuron n) {
  //  Connection c = new Connection(this, n, 100, 1);
  //  nextNeurons.add(c);
  //}
  void connect(Neuron n, float s) {
    Connection c = new Connection(this, n, s, 1);
    nextNeurons.add(c);
  }
  //void feed(Input input) {
  //  sum += input.value * input.weight;
  //}
  void feed(float v, float w) {
    sum += v * w;
  }

  int fire() {
    if (sum >= threshold) {
      sum = 0;
      for (Connection n : nextNeurons) {
        n.feed();
      }
      fired = true;
      return 100;
    } else {
      sum = 0;
      return 0;
    }
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
  void feed() {
    target.feed(value, weight);
  }
}
