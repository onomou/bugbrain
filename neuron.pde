class PositionalThing {//TODO: should have inherent size
  PVector position;
  color c;
  float size = 50;
  PositionalThing(float x, float y) {
    position = new PVector(x, y);
    //color = new color(0,0,0);
  }
  void display() {
    
  }
  boolean isNear(PVector pos) {
    float distanceSq = PVector.sub(pos, position).magSq();
    if ( distanceSq < size*size + 25 ) { //TODO: should reference p's size
      return true;
    } else {
      return false;
    }
  }
}

class Neuron extends PositionalThing {
  //float c = 0.01; //learning constant
  float threshold = 100, sum = 0;
  int id;
  //PVector position;
  ArrayList<Connection> nextNeurons;
  Tracker history;
  boolean fired = false;
  Neuron (int t, float x, float y) {
    super(x, y);
    threshold = constrain (t, -100, 100); 
    //position = new PVector(x, y);
    nextNeurons = new ArrayList<Connection>();
    id = newid();
    history = new Tracker(nextHeight());
    size = 70;
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
    circle(position, size);
    fill(0);
    text("t:"+threshold, position.x+0.6*size, position.y+6);
    text("s:"+sum, position.x+0.6*size, position.y-6);

    stroke(0);
    for (Connection n : nextNeurons) {
      n.display();
    }
    history.display();
  }
  void connect(Neuron n, float s) {
    Connection c = new Connection(this, n, s, 100);//default connection weight 100
    nextNeurons.add(c);
  }
  void feed(float v, float w) {
    sum += v * w / 100;
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
/*
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
*/
class Connection extends PositionalThing {
  Neuron origin, target;
  float value, weight;
  //PVector position;
  int id;
  Connection(Neuron o, Neuron t, float v, float w) {
    super((o.position.x+t.position.x)/2, (o.position.y+t.position.y)/2);
    origin = o;
    target = t;
    value = v;//maybe should constrain to -100,100?
    weight = constrain(w, -100, 100);
    id = newid();
    //
    //position = new PVector((origin.position.x+target.position.x)/2, (origin.position.y+target.position.y)/2);
    //
    connections.add(this);
    size = 15;
  }
  void display() {
    // draw arrow from oneStart (origin) to oneEnd (mid, origin side), twoStart (mid, target side) to twoEnd (target) 
    float buffer = 10;
    
    PVector originToMid = PVector.sub(this.position, origin.position).normalize(); // unit vector pointing from mid to target
    PVector oneStart = PVector.add(origin.position, PVector.mult(originToMid,      (  origin.size/2 + buffer)));
    PVector oneEnd = PVector.add(this.position, PVector.mult(originToMid, -1 * (this.size/2 + buffer))); 
    
    PVector midToTarget = PVector.sub(target.position, this.position).normalize(); // unit vector pointing from mid to target
    PVector twoStart = PVector.add(this.position, PVector.mult(midToTarget,      (  this.size/2 + buffer)));
    PVector twoEnd = PVector.add(target.position, PVector.mult(midToTarget, -1 * (target.size/2 + buffer))); 
    
    lineArrow(oneStart, oneEnd);
    lineArrow(twoStart, twoEnd);
    text("v:"+value,position.x+5,position.y-6);
    text("w:"+weight,position.x+5,position.y+6);
    
    circle(position, size);
  }
  void feed() {
    target.feed(value, weight);
  }
  void setWeight(float t) {
    weight = constrain (t, -100, 100);
  }
}