void mouseClicked() {
  PVector m = new PVector(mouseX, mouseY);
  Neuron n = findNearest(m, neurons);
  if (isNear(m, n)) {
    n.feed(100, 1);
  }
}
