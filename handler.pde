boolean isNear(PVector pos, Neuron n) {
  float distance = PVector.sub(pos, n.position).mag();
  if( distance < n.r + 5 ) {
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