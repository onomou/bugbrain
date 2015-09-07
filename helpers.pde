void circle(PVector p, float r) {
  ellipse(p.x, p.y, r, r);
}
void line(PVector p, PVector q) {
  line(p.x,p.y,q.x,q.y);
}
void lineArrow(PVector p, PVector q) {
  stroke(0);
  PVector l = PVector.sub(q,p);
  //line(p,q);
  pushMatrix();
  translate(q.x,q.y);
  line(0,0,-l.x,-l.y);
  rotate(l.heading()+HALF_PI);
  rotate(PI/8);
  line(0,0,0,0.1*l.mag());
  rotate(-PI/4);
  line(0,0,0,0.1*l.mag());
  popMatrix();
}

int globalid = 0;
int newid() {
  return globalid++;
}

class Tracker {
  float[] history;
  int counter, yposition;
  Tracker(int y) {
    history = new float[width];
    yposition = y;
  }

  void feed(float v) {
    history[counter] = constrain(v, -100, 100)/100;
    counter = (counter+1)% history.length;
  }
  void display() {
    stroke(0);
    for (int i = 1; i < history.length; i++) {
      line(i, yposition-25* history [i], i-1, yposition-25* history [i-1] );
    }
  }
}

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

float squareWave(int period) {
  return floor(millis()/(1000*period))%2;
}

float sineWave(float period) {
  return 0.5*(sin(TAU*millis()/(1000*period))+1);//0.5*(sin(mil/4000)+1);
}
