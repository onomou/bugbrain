/*
Mouse events:
 * Connect neuron to neuron: click on neuron, drag to another one
 * Modify neuron threshold: click and release one neuron
 * Move connection midpoint: click and drag connection midpoint
 * Modify connection weight: click and release center of connection
 Mouse state changed
 Mouse button down
 Could be clicking on neuron, connection, or nothing
 Mouse button up
 Could have dragged to another neuron/connection, same one, or nothing
 Mouse state unchanged
 Mouse button down
 
 Mouse button up
 Nothing
 Changing neuron threshold
 Set program state to "changing neuron threshold"
 Set neuron state to receive input
 Update slider to current threshold
 Wait for mouse click and release
 Read slider value
 Write to neuron
 Set neuron state to normal
 */

void mouseMoved() {
  //mouse.set(mouseX, mouseY);
}

void mouseClicked() {
  //mouse.set(mouseX, mouseY);
}

ArrayList<PVector> mouseTrace = new ArrayList<PVector>();
// Called once every time the mouse moves while a mouse button is pressed
void mouseDragged() {
  if ( objectClicked ) {
    mouseTrace.add(mouse.copy());
  }
  if ( mode.equals("Connect") ) {
    if ( changingNeuronThreshold ) {
      oNeuron.setThreshold(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); // TODO: change hard-coded numbers
    } else if ( changingConnectionWeight ) {
      oConnection.setWeight(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); // TODO: change hard-coded numbers
    } else if ( clickedObject.equals("Connection") ) {
      oConnection.move(mouse);
    }
  } else if ( mode.equals("Move") ) {
    if ( clickedObject.equals("Neuron") ) {
      oNeuron.move(mouse);
    } else if ( clickedObject.equals("Connection") ) {
      oConnection.move(mouse);
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
  if ( changingNeuronThreshold ) {
    oNeuron.setThreshold(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); // TODO: change hard-coded numbers
  } else if ( changingConnectionWeight ) {
    oConnection.setWeight(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); // TODO: change hard-coded numbers
  } else {

    // TODO: make this neater
    // TODO: add functions for right mouse button, including delete and move neuron
    oMouse = mouse.copy();
    float distanceToNeuron = 10000, distanceToConnection = 10000; // surely *something* will be closer than this...
    boolean isNearNeuron = false, isNearConnection = false; // default to not near anything

    Neuron nearestNeuron = neurons.getNearest(mouse); // get neuron closest to mouse
    if ( nearestNeuron != null ) { // check to make sure a neuron exists
      distanceToNeuron = nearestNeuron.distSq(mouse);
      isNearNeuron = nearestNeuron.isNear(mouse);
    }
    Connection nearestConnection = findNearest(mouse, connections, 1); // get connection closest to mouse
    if ( nearestConnection != null ) { // check to make sure a connection exists
      distanceToConnection = nearestConnection.distSq(mouse);
      isNearConnection = nearestConnection.isNear(mouse);
    }
    if ( isNearNeuron && distanceToNeuron <= distanceToConnection ) {            // clicked on a neuron
      clickedObject = "Neuron";
      oNeuron = nearestNeuron;
      oNeuron.isClicked = true;
      objectClicked = true;
    } else if ( isNearConnection && distanceToConnection < distanceToNeuron ) {  // clicked on a connection
      clickedObject = "Connection";
      oConnection = nearestConnection;
      oMouse.set(oConnection.position.copy());
      objectClicked = true;
    }
  }
}

void mouseReleased() {
  if ( changingNeuronThreshold ) {
    oNeuron.setThreshold(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); // TODO: change hard-coded numbers
    oNeuron.isClicked = false;
  } else if ( changingConnectionWeight ) {
    oConnection.setWeight(map(magnet(mouseX, 50, width-50), 50, width-50, -100, 100)); // TODO: change hard-coded numbers
    oConnection.isClicked = false;
  }

  changingConnectionWeight = false;
  changingNeuronThreshold = false;
  if ( objectClicked ) {
    oNeuron.isClicked = false;
    if ( mode.equals("Connect") && clickedObject.equals("Neuron") ) { // released neuron, connecting
      // Neuron closestNeuron = findNearest(mouse, neurons);
      Neuron closestNeuron = neurons.getNearest(mouse);
      if ( closestNeuron.isNear(mouse) ) {
        if ( closestNeuron.id == oNeuron.id ) {                // mouse released on same neuron
          // call dialog to set threshold
          changingNeuronThreshold = true;
          oNeuron.isClicked = true;
          // setThreshold(oNeuron);
        } else {                                              // connect to other neuron
          oNeuron.connect(closestNeuron, mouseTrace.get(mouseTrace.size()/2));
        }
      }
    } else if ( mode.equals("Connect") && clickedObject.equals("Connection") ) {
      if ( oConnection.isNear(oMouse) ) {    // mouse not dragged too far: modify connection weight
        // call dialog to set weight
        oConnection.move(oMouse);
        changingConnectionWeight = true;
      } else {
        oConnection.position.set(mouse);
      }
    } else if ( mode.equals("Move") && clickedObject.equals("Neuron") ) { // released neuron, connecting
    } else if ( mode.equals("Move") && clickedObject.equals("Connection") ) {
    }
  }

  objectClicked = false;
  clickedObject = "";
  mouseTrace.clear();
}