void circle(PVector p, float r) {
  ellipse(p.x, p.y, r, r);
}
void line(PVector p, PVector q) {
  line(p.x,p.y,q.x,q.y);
}
void lineArrow(PVector p, PVector q) {
  PVector l = PVector.sub(q,p);
  line(p,q);
  pushMatrix();
  translate((p.x+q.x)/2,(p.y+q.y)/2);
  line(0,0,l.x,l.y);
  rotate(l.heading());
  line(0,0,0,0.2*l.mag());
  line(0,0,0.2*l.mag(),0);
  popMatrix();
}