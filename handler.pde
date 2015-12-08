/*
boolean isNear(PVector pos, PositionalThing p) {
 float distanceSq = PVector.sub(pos, p.position).magSq();
 if ( distanceSq < p.size*p.size + 25 ) {
 return true;
 } else {
 return false;
 }
 }
 boolean isNear(PVector p, PVector q, float tolerance) {
 if( PVector.sub(p,q).magSq() < tolerance*tolerance ) {
 return true;
 } else {
 return false;
 }
 }
 */
/*
boolean isNear(PVector pos, Connection c) {
 float distance = PVector.sub(pos, c.position).mag();
 if( distance < 75 ) {
 return true;
 } else {
 return false;
 }
 }
 Neuron findNearest(PVector pos, ArrayList<Neuron> neurons) {
 float distance, leastDist = width;
 Neuron closest = neurons.get(0);
 for(Neuron n : neurons) {
 distance = PVector.sub(pos, n.position).mag();
 if(distance < leastDist) {
 closest = n;
 leastDist = distance;
 }
 }
 return closest;
 }
 */
/*
PositionalThing findNearest(PVector pos, ArrayList<PositionalThing> pthings) {
 float distance, leastDist = width;
 Neuron closest = pthings.get(0);
 for(PositionalThing p : pthings) {
 distance = PVector.sub(pos, p.position).mag();
 if(distance < leastDist) {
 closest = p;
 leastDist = distance;
 }
 }
 return closest;
 }
 */
/*
PositionalThing findNearest(PVector pos, ArrayList<PositionalThing> pthings, int t) {
 // TODO:
 if( pthings.size() == 0 ) {
 return null;
 }
 float distance, leastDist = width;
 PositionalThing closest = pthings.get(0);
 for (PositionalThing p : pthings) {
 distance = PVector.sub(pos, p.position).mag();
 if (distance < leastDist) {
 closest = p;
 leastDist = distance;
 }
 }
 return closest;
 }
 */