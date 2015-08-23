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