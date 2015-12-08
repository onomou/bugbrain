class Input {
  String type;
  float period, phase;
  Input(String typeIn, float period, float phase) {
    this.type = typeIn;
    this.period = period;
    this.phase = phase;
    //println("Made new " + type);
  }
  float run() {
    if( type.equals("squareWave") ) {
      return floor(millis()/(1000*period))%2;
    } else if( type.equals("sineWave") ) {
      return 100*0.5*(sin(TAU*millis()/(1000*period)+phase)+1);// 0.5*(sin(mil/4000)+1);
    } else if( type.equals("stepFunction") ) {
      return 0; // not implemented
    } else {
      return 0;
    }
  }
}

float squareWave(int period) {
  return floor(millis()/(1000*period))%2;
}

float sineWave(float period, float phase) {
  return 0.5*(sin(TAU*millis()/(1000*period)+phase)+1);// 0.5*(sin(mil/4000)+1);
}