void mouseClicked() {

  mouse.set(mouseX, mouseY);
  if( mouseButton == LEFT ) {
    if( changingNeuronThreshold ) {
      oNeuron.setThreshold(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
      changingNeuronThreshold = false;
    } else if( changingConnectionWeight ) {
      oConnection.setWeight(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
      changingConnectionWeight = false;
    }/* else if( addNeuronButton.isNear(mouse) ) {
      addNeuronButton.click();
      addNeuron();
    } else if( interactModeButton.isNear(mouse) ) {
      interactModeButton.click();
    }*/
  } else if( mouseButton == RIGHT ) {
    //if( changingNeuronThreshold ) { // right clicked on neuron TODO: should use a more generic name
      neurons.remove(mouse);
    //}
  }
}

ArrayList<PVector> mouseTrace = new ArrayList<PVector>();
void mouseDragged() {
  if( objectClicked ) {
    mouseTrace.add(mouse.copy());
  }
  if( mode.equals("connect") ) {
    if( changingNeuronThreshold ) {
      oNeuron.setThreshold(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
    } else if( changingConnectionWeight ) {
      oConnection.setWeight(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
    }
  } else if( mode.equals("move") ) {
    if( clickedObject.equals("Neuron") ) {
      oNeuron.move(mouse);
    }
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
  if( mode.equals("connect") ) {
    if( changingNeuronThreshold ) {
      oNeuron.setThreshold(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
      changingNeuronThreshold = false;
    } else if( changingConnectionWeight ) {
      oConnection.setWeight(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
      changingConnectionWeight = false;
    }
  }
}