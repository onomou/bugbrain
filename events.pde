void mouseClicked() {
  mouse.set(mouseX, mouseY);
  // superceded by mousePressed() and mouseReleased()
  /*
  if( mouseButton == LEFT ) {
   if( changingNeuronThreshold ) {
   oNeuron.setThreshold(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
   changingNeuronThreshold = false;
   } else if( changingConnectionWeight ) {
   oConnection.setWeight(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
   changingConnectionWeight = false;
   } else if( addNeuronButton.isNear(mouse) ) {
   addNeuronButton.click();
   addNeuron();
   } else if( interactModeButton.isNear(mouse) ) {
   interactModeButton.click();
   }
   } else if( mouseButton == RIGHT ) {
   //if( changingNeuronThreshold ) { // right clicked on neuron TODO: should use a more generic name
   neurons.remove(mouse);
   //}
   }
   */
}

ArrayList<PVector> mouseTrace = new ArrayList<PVector>();
// Called once every time the mouse moves while a mouse button is pressed
void mouseDragged() {
  if ( objectClicked ) {
    mouseTrace.add(mouse.copy());
  }
  if ( mode.equals("Connect") ) {
    if ( changingNeuronThreshold ) {
      oNeuron.setThreshold(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); //TODO: change hard-coded numbers
    } else if ( changingConnectionWeight ) {
      oConnection.setWeight(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); //TODO: change hard-coded numbers
    }
  } else if ( mode.equals("Move") ) {
    if ( clickedObject.equals("Neuron") ) {
      oNeuron.move(mouse);
    }
  }
}

/* Sticks input to start, mid, and end if close enough */
float magnet(float x, float start, float end) {
  float mid = (start + end) / 2;
  float d = 10;
  if ( abs(x-start) < d ) {
    x = start;
  } else if ( abs(x-mid) < d ) {
    x = mid;
  } else if ( abs(x-end) < d ) {
    x = end;
  }
  return x;
}

void mousePressed() {
  // Transferred from draw()
  if ( changingNeuronThreshold ) {
    oNeuron.setThreshold(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); //TODO: change hard-coded numbers
  } else if ( changingConnectionWeight ) {
    oConnection.setWeight(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); //TODO: change hard-coded numbers
  } else {

    //TODO: make this neater
    //TODO: add functions for right mouse button, including delete and move neuron
    oMouse = mouse.copy();
    float distanceToNeuron = 10000, distanceToConnection = 10000; // surely *something* will be closer than this...
    boolean isNearNeuron = false, isNearConnection = false; // default to not near anything
  
    Neuron nearestNeuron = neurons.getNearest(mouse); // get neuron closest to mouse
    if ( nearestNeuron != null ) { // check to make sure a neuron exists
      distanceToNeuron = distSq(mouse, nearestNeuron);
      isNearNeuron = nearestNeuron.isNear(mouse);
    }
    Connection nearestConnection = findNearest(mouse, connections, 1); // get connection closest to mouse
    if ( nearestConnection != null ) { // check to make sure a connection exists
      distanceToConnection = distSq(mouse, nearestConnection);
      isNearConnection = nearestConnection.isNear(mouse);
    }
    if ( isNearNeuron && distanceToNeuron <= distanceToConnection ) {            // clicked on a neuron
      clickedObject = "Neuron";
      oNeuron = nearestNeuron;
      objectClicked = true;
    } else if ( isNearConnection && distanceToConnection < distanceToNeuron ) {  // clicked on a connection
      clickedObject = "Connection";
      oConnection = nearestConnection;
      objectClicked = true;
    }
  }
}

void mouseReleased() {
  // Transferred from draw()
  if ( changingNeuronThreshold ) {
    oNeuron.setThreshold(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); //TODO: change hard-coded numbers
  } else if ( changingConnectionWeight ) {
    oConnection.setWeight(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); //TODO: change hard-coded numbers
  }
  
  changingConnectionWeight = false;
  changingNeuronThreshold = false;
  if ( objectClicked ) {
    if ( mode.equals("Connect") && clickedObject.equals("Neuron") ) { // released neuron, connecting
      //Neuron closestNeuron = findNearest(mouse, neurons);
      Neuron closestNeuron = neurons.getNearest(mouse);
      if ( closestNeuron.isNear(mouse) ) {
        if ( closestNeuron.id == oNeuron.id ) {                // mouse released on same neuron
          // call dialog to set threshold
          changingNeuronThreshold = true;
          //setThreshold(oNeuron);
        } else {                                              // connect to other neuron
          oNeuron.connect(closestNeuron, mouseTrace.get(mouseTrace.size()/2));
        }
      }
    } else if ( mode.equals("Connect") && clickedObject.equals("Connection") ) {
      if ( oConnection.isNear(mouse) ) {    // mouse not dragged too far = modify connection weight
        // call dialog to set weight
        changingConnectionWeight = true;
      } else {
        oConnection.position.set(mouse);
      }
    } else if ( mode.equals("Move") && clickedObject.equals("Neuron") ) { // released neuron, connecting
      //Neuron closestNeuron = findNearest(mouse, neurons);
      Neuron closestNeuron = neurons.getNearest(mouse);
    } else if ( mode.equals("Move") && clickedObject.equals("Connection") ) {
      if ( oConnection.isNear(mouse) ) {    // mouse not dragged too far = modify connection weight
        // call dialog to set weight
        changingConnectionWeight = true;
      } else {
        oConnection.position.set(mouse);
      }
    }
  }

  /*
  if( mode.equals("Connect") ) {
   if( changingNeuronThreshold ) {
   oNeuron.setThreshold(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
   changingNeuronThreshold = false;
   } else if( changingConnectionWeight ) {
   oConnection.setWeight(map(magnet(mouseX,50,width-50),50,width-50,-100,100)); //TODO: change hard-coded numbers
   changingConnectionWeight = false;
   }
   }
   */
  objectClicked = false;
  clickedObject = "";
  mouseTrace.clear();
}