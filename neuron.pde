class Neuron extends PositionalThing {
  // float c = 0.01; // learning constant
  float threshold = 100, sum = 0, nextSum = 0;
  String type;
  boolean willFire = false;
  float fireValue = 0;
  // int id;
  // PVector position;
  ArrayList<Connection> nextNeurons;
  ArrayList<Input> attachedInputs;
  Tracker history;
  boolean fired = false;
  Neuron (int t, PVector p, String typeIn) {
    super(p);
    threshold = constrain (t, -100, 100); 
    // position = new PVector(x, y);
    nextNeurons = new ArrayList<Connection>();
    attachedInputs = new ArrayList<Input>();
    //attachedInputs.add(ipt);
    // id = newid();
    history = new Tracker(trackerBaseline - 40 * outputs.size(), this.id);
    if (typeIn.equals("linear")) {
      type = "linear";
      inputs.append(this.id); // TODO: fix this to be contained internally
      history.yposition = 40 * inputs.size();
      thisColor = color(180, 0, 0);
    } else {
      type = "step";
      outputs.append(this.id); // TODO: fix this to be contained internally
      thisColor = color(0, 240, 0);
    }
    size = 70;

    //attachInput();
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
    text("s:"+(int)sum, position.x+0.6*size, position.y-16);
    text("t:"+(int)threshold, position.x+0.6*size, position.y+16);

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
    attachInput(new Input("sineWave", 2, 1));
    //attachedInputs.add(new Input("sineWave", 2, 1));
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
  void activate() {
    // TODO: add other activation types, like sigmoid, etc.
    if( type.equals("linear") ) {
      willFire = true;
      fireValue = sum;
    } else if( type.equals("step") ) {
      if (sum >= threshold) { // the activation function
        willFire = true;
        fireValue = 100;
      }
    }
  }
  void fire() {
    if (willFire) {
      for (Connection n : nextNeurons) {
        n.feed(fireValue); // send current value to connected neurons
      }
      fired = true;
      history.feed(fireValue);
    } else {
      for (Connection n : nextNeurons) {
        n.feed(0); // set connection values to 0
      }
      history.feed(0);
    }
    sum = 0;
    willFire = false;
  }
  void advance() {
    // add attached inputs
    for ( Input i : attachedInputs ) {
      nextSum += i.run();
    }
    sum = nextSum;
    nextSum = 0;
  }
}

class VariableOutput extends Neuron {
  VariableOutput (int t, PVector p) {
    super(t, p,"linear");
    //outputs.remove(outputs.size()-1); // TODO: fix this to be contained internally
    //inputs.append(this.id); // TODO: fix this to be contained internally
    //history.yposition = 40 * inputs.size();
    //thisColor = color(180, 0, 0);
  }
  // void display() {
  // super();
  // }
  //void fire() {
  //  for (Connection n : nextNeurons) {
  //    n.feed(sum);
  //  }

  //  history.feed(sum);
  //  sum = 0;
  //}
}