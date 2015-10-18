class PositionalThing {//TODO: should have inherent size
  PVector position;
  color c;
  float size = 50;
  int id;
  PositionalThing(PVector p) {
    position = p.copy();
    //color = new color(0,0,0);
    id = newid();
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
  void feed(float x, float y) { // TODO: this?
    
  }
  void move(PVector pos) {
    position = pos.copy();
  }
}

class Neuron extends PositionalThing {
  //float c = 0.01; //learning constant
  float threshold = 100, sum = 0;
  //int id;
  //PVector position;
  ArrayList<Connection> nextNeurons;
  Tracker history;
  boolean fired = false;
  Neuron (int t, PVector p) {
    super(p);
    threshold = constrain (t, -100, 100); 
    //position = new PVector(x, y);
    nextNeurons = new ArrayList<Connection>();
    //id = newid();
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
      if( threshold == 0 ) {
        fill(0);
      } else {
        fill(map(sum, 0, threshold, 0, 255));
      }
    }
    circle(position, size);
    fill(0);
    text("t:"+threshold, position.x+0.6*size, position.y+16);
    text("s:"+sum, position.x+0.6*size, position.y-16);

    stroke(0);
    for (Connection n : nextNeurons) {
      n.display();
    }
    history.display();
  }
  void connect(Neuron n) {
    Connection c = new Connection(this, n, 100);//default connection weight 100
    nextNeurons.add(c);
  }
  void connect(Neuron n, PVector position) {
    Connection c = new Connection(this, n, 100);//default connection weight 100
    c.position = position.copy();
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
      for (Connection n : nextNeurons) {
        n.feed(100); // set connection values to 100
      }
      sum = 0;
      fired = true;
      for( Connection c : connections ) {
        c.fire();
      }
      history.feed(100);
      return 100;
    } else {
      for (Connection n : nextNeurons) {
        n.feed(0); // set connection values to 0
      }
      sum = 0;
      history.feed(0);
      return 0;
    }
  }
}

class VariableOutput extends Neuron {
  VariableOutput (int t, PVector p) {
    super(t,p);
    history.yposition = 130;
  }
  //void display() {
  //  super();
  //}
  float fire() {
    float s = sum;
    sum = 0;
    
    for (Connection n : nextNeurons) {
      //n.value = s;
      n.feed(s);
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
  PositionalThing origin, target;
  float value, currentWeight, actualWeight, previousValue;
  float decay;
  //PVector position;
  //int id;
  Connection(Neuron o, Neuron t, float w) {
    super(new PVector((o.position.x+t.position.x)/2, (o.position.y+t.position.y)/2));
    origin = o;
    target = t;
    value = 0;//maybe should constrain to -100,100?
    actualWeight = constrain(w, -100, 100);
    currentWeight = actualWeight;
    previousValue = 0;
    //id = newid();
    //
    //position = new PVector((origin.position.x+target.position.x)/2, (origin.position.y+target.position.y)/2);
    //
    connections.add(this);
    size = 15;
    decay = 1; // should always be nonnegative
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
    
    if( value == previousValue ) {
       if( currentWeight == 0 ) {
         // do nothing, currentWeight == 0 already
       } else {
         currentWeight = currentWeight / abs(currentWeight) * (abs(currentWeight) - decay);
       }
    } else {
      currentWeight = actualWeight;
    }
    
    text("v:"+value,position.x+5,position.y-16);
    text("w:"+currentWeight,position.x+5,position.y+16);
    
    circle(position, size);
  }
  void feed(float value) {
    this.previousValue = this.value;
    this.value = value;
    target.feed(this.value, this.currentWeight);
  }
  void fire() {
    
  }
  void setWeight(float t) {
    actualWeight = constrain (t, -100, 100);
    currentWeight = actualWeight;
  }
}

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
  void feed(int whichOne, float value, float weight) {
    if( whichOne < neurons.size() ) {
      neurons.get(whichOne).feed(value, weight);
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