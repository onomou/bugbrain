void circle(PVector p, float r) {
  ellipse(p.x, p.y, r, r);
}
void circle(float x, float y, float r) {
  ellipse(x, y, r, r);
}
void rect(PVector p, float w, float h) {
  rect(p.x, p.y, w, h);
}
void line(PVector p, PVector q) {
  line(p.x, p.y, q.x, q.y);
}
void lineArrow(PVector p, PVector q) {
  // stroke(0);
  // circle((p.x+q.x)/2,(p.y+q.y)/2,10);
  PVector l = PVector.sub(q, p);
  // line(p,q);
  pushMatrix();
  translate(q.x, q.y);
  line(0, 0, -l.x, -l.y);
  rotate(l.heading()+HALF_PI);
  rotate(PI/8);
  line(0, 0, 0, 12);// 0.1*l.mag());
  rotate(-PI/4);
  line(0, 0, 0, 12);// 0.1*l.mag());
  popMatrix();
}

boolean isEqual(PVector p, PVector q) {
  if ( p.x == q.x && p.y == q.y ) {
    return true;
  } else {
    return false;
  }
}

int globalid = 0;
int newid() {
  globalid++;
  return globalid;
}

IntList outputs = new IntList();
IntList inputs = new IntList();

class Tracker {
  float[] history;
  int yposition, id;
  Tracker(int y, int id) {
    history = new float[globalTrackerLength];
    yposition = y;
    this.id = id;
  }

  void feed(float v) {
    history[globalTrackerIndex] = constrain(v, -100, 100)/100;
  }
  void display() {
    text(id, 10, yposition + (textAscent()+textDescent())/2);
    for (int i = 1; i < history.length; i++) {
      line(i, yposition-25* history [i], i-1, yposition-25* history [i-1] );
    }
  }
}

/*
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
 
 
 
 void setThreshold( Neuron n ) {
 disableInput = true;
 pushStyle();
 strokeWeight(10);
 stroke(0,100);
 n.display();
 popStyle();
 rect(100,100,500,500);
 text("Please type your value and press enter",300,150);
 }
 
 */