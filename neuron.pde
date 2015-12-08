class Neuron extends PositionalThing {
  // float c = 0.01; // learning constant
  float threshold = 100, sum = 0, nextSum = 0;
  boolean willFire = false;
  // int id;
  // PVector position;
  ArrayList<Connection> nextNeurons;
  ArrayList<Input> attachedInputs;
  Tracker history;
  boolean fired = false;
  Neuron (int t, PVector p, int trackerPosition) {
    super(p);
    threshold = constrain (t, -100, 100); 
    // position = new PVector(x, y);
    nextNeurons = new ArrayList<Connection>();
    attachedInputs = new ArrayList<Input>();
    attachedInputs.add(ipt);
    // id = newid();
    size = 70;
    thisColor = color(0, 240, 0);
    outputs.append(this.id); // TODO: fix this to be contained internally
    history = new Tracker(trackerBaseline - 40 * outputs.size(), this.id);

    attachInput();
  }
  FloatDict getAttributes() {
    FloatDict attributes = new FloatDict();
    attributes.set("threshold", threshold);
    return attributes;
  }
  void display() {
    // TODO: color according to thisColor
    pushStyle();
    // stroke(0);
    // for (Connection n : nextNeurons) {
    // line(this.position, n.target.position);
    // }
    stroke(map(threshold, -100, 100, 0, 255));
    color fillColor = thisColor;//color(0);
    if (fired) {
      fillColor = color(255, 0, 0);
      fired = false;
    } else {
      if ( threshold == 0 ) {
        fillColor = thisColor;//color(0);
      } else {
        fillColor = color(map(sum, 0, threshold, 0, 255));
      }
    }

    if ( isHovered ) {
      strokeWeight(2);
      fillColor = color(100, 100);
    }
    if ( isClicked ) {
      strokeWeight(10);
    }
    fill(fillColor);
    circle(position, size);
    fill(0);
    text("s:"+sum, position.x+0.6*size, position.y-16);
    text("t:"+(threshold), position.x+0.6*size, position.y+16);

    textAlign(CENTER, CENTER);
    stroke(0);
    for (Connection n : nextNeurons) {
      n.display();
    }
    history.display();
    isHovered = false;

    fill(255-brightness(fillColor));
    text(id, position.x, position.y);
    popStyle();
  }
  void connect(Neuron n) {
    Connection c = new Connection(this, n, 100);// default connection weight 100
    nextNeurons.add(c);
  }
  void connect(Neuron n, PVector position) {
    Connection c = new Connection(this, n, 100);// default connection weight 100
    c.position = position.copy();
    nextNeurons.add(c);
  }
  void attachInput() {
    //println("Attaching input");
    Input ipt = new Input("sineWave", 2, 1);
    attachedInputs.add(ipt);
    println("Attached one input");
    ipt.run();
    attachedInputs.add(new Input("sineWave", 2, 1));
    for ( Input i : attachedInputs ) {
      i.run();
    }
    println("Done attaching inputs, size " + attachedInputs.size());
  }
  void attachInput(Input i) {
    attachedInputs.add(i);
  }
  void feed(float v, float w) {
    nextSum += v * w / 100;
  }
  void setThreshold(float t) {
    threshold = (int)constrain (t, -100, 100);
  }
  void run() {
    /*
        Sum input values
     Display sum of inputs
     Process activation function based on sum (clear sum)
     Display activation result
     Send result to attached connections for next round
     
     
     Compare inputs to activation function: activate()
     Display: display()
     Process activation: fire()
     Send as inputs for next round: feed()
     Move all inputs to be processed: advance()
     */
  }
  void advance() {
    sum = nextSum;
    nextSum = 0;
  }
  void activate() {
    if (sum >= threshold) { // the activation function, TODO: add other activation types, like sigmoid, etc.
      willFire = true;
    }
  }
  float fire() {
    //println(attachedInputs.size());
    //for( Input i : attachedInputs ) {
    //sum += i.run();
    //println("Firing");
    //println(i.run());
    //}
    if (willFire) {
      for (Connection n : nextNeurons) {
        n.feed(100); // set connection values to 100
        //n.fire();
      }
      sum = 0;
      fired = true;
      willFire = false;
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
    super(t, p, 40);
    outputs.remove(outputs.size()-1); // TODO: fix this to be contained internally
    inputs.append(this.id); // TODO: fix this to be contained internally
    history.yposition = 40 * inputs.size();
    thisColor = color(180, 0, 0);
  }
  // void display() {
  // super();
  // }
  float fire() {
    float s = sum;
    sum = 0;

    for (Connection n : nextNeurons) {
      // n.value = s;
      n.feed(s);
    }

    history.feed(s);
    return s;
  }
}