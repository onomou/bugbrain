class PositionalThing {// TODO: should have inherent size
  PVector position;
  color thisColor;
  float size = 50;
  int id;
  boolean isHovered = false, isClicked = false;
  PositionalThing(PVector p) {
    position = p.copy();
    thisColor = color(0, 0, 0);
    id = newid();
  }
  FloatDict getAttributes() {
    return new FloatDict();
  }
  void display() {
  }
  boolean isNear(PVector pos) {
    float distanceSq = PVector.sub(pos, position).magSq();
    if ( distanceSq < size*size + 25 ) { // TODO: should reference p's size
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

  float distSq(PVector pos) {
    return PVector.sub(pos, this.position).magSq();
  }
}