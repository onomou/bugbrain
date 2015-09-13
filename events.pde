void mouseClicked() {
  mouse.set(mouseX, mouseY);
  if( changingNeuronThreshold ) {
    oNeuron.setThreshold(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
    changingNeuronThreshold = false;
  } else if( changingConnectionWeight ) {
    oConnection.setWeight(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
    changingConnectionWeight = false;
  } else if( addNeuron.isNear(mouse) ) {
    neurons.add(new Neuron(50, width/2, height/2));
  }
}

ArrayList<PVector> mouseTrace = new ArrayList<PVector>();
void mouseDragged() {
  if( objectClicked ) {
    mouseTrace.add(mouse.copy());
  }
  if( changingNeuronThreshold ) {
    oNeuron.setThreshold(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
  } else if( changingConnectionWeight ) {
    oConnection.setWeight(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
  }
}

/* Sticks input to start, mid, and end if close enough */
float magnet(float x, float start, float end) {
  float mid = (start + end) / 2;
  float d = 10;
  if( abs(x-start) < d ) {
    x = start;
  } else if( abs(x-mid) < d ) {
    x = mid;
  } else if( abs(x-end) < d ) {
    x = end;
  }
  return x;
}

void mouseReleased() {
// TODO: will this work?
//  mouseTrace.clear();
  if( changingNeuronThreshold ) {
    oNeuron.setThreshold(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
    changingNeuronThreshold = false;
  } else if( changingConnectionWeight ) {
    oConnection.setWeight(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
    changingConnectionWeight = false;
  }
}