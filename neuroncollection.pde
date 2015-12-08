class NeuronCollection {
  ArrayList<Neuron> neurons;
  Neuron rememberedNeuron;
  PVector rememberedPosition;
  NeuronCollection() {
    neurons = new ArrayList<Neuron>();
    rememberedPosition = new PVector();
  }
  void add(Neuron n) {
    neurons.add(n);
  }
  void add(PVector p) {
    if( isNear(p) ) {
      p.add(70 + 10, 0); // TODO: change hard-coded number to refer to neuron's default size
      this.add(p);       // recursive, keep going right until empty space
    } else {
      this.add(new Neuron(50, p, getNextTrackerPosition()));
    }
  }
  int getNextTrackerPosition() {
    return trackerBaseline - 40 * neurons.size();
  }
  void remove(PVector p) { // TODO: this will be problematic - need to destroy neuron and associated connections
    for( int i = 0; i < neurons.size(); i++ ) {
      if( neurons.get(i).isNear(p) ) {
        // neurons.get(i).
        neurons.remove(i);
        break;
      }
    }
  }
  void run() {
    // activate, display, fire, advance
    for (int i = 0; i < neurons.size (); i++) {
      // Neuron n = neurons.get(i); // TODO: is this more efficient?
      neurons.get(i).activate();
    }
    for( Neuron n : neurons ) n.activate();
    for( Neuron n : neurons ) n.display();
    for( Neuron n : neurons ) n.fire();
    for( Neuron n : neurons ) n.advance();
  }
  void feed(int whichOne, float value, float weight) {
    if( whichOne < neurons.size() ) {
      neurons.get(whichOne).feed(value, weight);
    }
  }
  
  //void attachInput(int whichOne, String type, float period, float phase) {
  //  if( whichOne < neurons.size() ) {
  //    neurons.get(whichOne).attachInput(new Input(type, period, phase));
  //  }
  //}
  
  
  boolean isNear(PVector p) { // TODO: may be unpredictable because two neurons' radii could collide?
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
  
  
  Neuron findNearest(PVector pos) {
    if( neurons.size() == 0 ) {
      rememberedNeuron = null;
      rememberedPosition = null;
      return null;
    }
    float distance, leastDist = width;
    Neuron closest = neurons.get(0);
    for (Neuron p : neurons) {
      distance = PVector.sub(pos, p.position).mag();
      if (distance < leastDist) {
        closest = p;
        leastDist = distance;
      }
    }
    rememberedNeuron = closest;
    rememberedPosition = pos.copy();
    return closest;
  }
  
  Neuron get(int index) {
    if( index < neurons.size() ) {
      return neurons.get(index);
    } else {
      return null;
    }
  }
  Neuron getNearest(PVector pos) {
    if( isEqual(pos, rememberedPosition) && rememberedNeuron != null ) {
      return rememberedNeuron;
    } else {
      return findNearest(pos);
    }
  }
  void rollOver(PVector pos) {
    Neuron nearestNeuron = getNearest(pos);
    if( nearestNeuron.isNear(pos) ) {
      nearestNeuron.isHovered = true;
      hoveredObject = "Neuron";
    }
  }
}