
class Connection extends PositionalThing {
  PositionalThing origin, target;
  float value, currentWeight, actualWeight, previousValue;
  float decay;
  // PVector position;
  // int id;
  Connection(Neuron o, Neuron t, float w) {
    super(new PVector((o.position.x+t.position.x)/2, (o.position.y+t.position.y)/2));
    origin = o;
    target = t;
    value = 0;// maybe should constrain to -100,100?
    actualWeight = constrain(w, -100, 100);
    currentWeight = actualWeight;
    previousValue = 0;
    // id = newid();
    // 
    // position = new PVector((origin.position.x+target.position.x)/2, (origin.position.y+target.position.y)/2);
    // 
    connections.add(this);
    size = 15;
    decay = 1; // should always be nonnegative
  }
  FloatDict getAttributes() {
    FloatDict attributes = new FloatDict();
    attributes.set("weight", actualWeight);
    attributes.set("decay", 1);
    return attributes;
  }
  void display() {
    // draw arrow from oneStart (origin) to oneEnd (mid, origin side), twoStart (mid, target side) to twoEnd (target) 
    float buffer = 10;

    PVector originToMid = PVector.sub(this.position, origin.position).normalize(); // unit vector pointing from mid to target
    PVector oneStart = PVector.add(origin.position, PVector.mult(originToMid, (  origin.size/2 + buffer)));
    PVector oneEnd = PVector.add(this.position, PVector.mult(originToMid, -1 * (this.size/2 + buffer))); 

    PVector midToTarget = PVector.sub(target.position, this.position).normalize(); // unit vector pointing from mid to target
    PVector twoStart = PVector.add(this.position, PVector.mult(midToTarget, (  this.size/2 + buffer)));
    PVector twoEnd = PVector.add(target.position, PVector.mult(midToTarget, -1 * (target.size/2 + buffer))); 

    lineArrow(oneStart, oneEnd);
    lineArrow(twoStart, twoEnd);

    if ( value == previousValue ) {
      if ( currentWeight == 0 ) {
        // do nothing, currentWeight == 0 already
      } else {
        currentWeight = currentWeight / abs(currentWeight) * (abs(currentWeight) - decay);
      }
    } else {
      currentWeight = actualWeight;
    }

    text("v:"+value, position.x+5, position.y-16);
    text("w:"+currentWeight, position.x+5, position.y+16);

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

Connection findNearest(PVector pos, ArrayList<Connection> pthings, int t) {
  // TODO:
  if ( pthings.size() == 0 ) {
    return null;
  }
  float distance, leastDist = width;
  Connection closest = pthings.get(0);
  for (Connection p : pthings) {
    distance = PVector.sub(pos, p.position).mag();
    if (distance < leastDist) {
      closest = p;
      leastDist = distance;
    }
  }
  return closest;
}