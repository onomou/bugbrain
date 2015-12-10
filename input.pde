class Input {
  String type;
  float period, phase;
  int id;
  Input(String typeIn, float period, float phase) {
    this.type = typeIn;
    this.period = period;
    this.phase = phase;
    id = newid();
  }
  float run() {
    if ( type.equals("squareWave") ) {
      return floor(millis()/(1000*period))%2;
    } else if ( type.equals("sineWave") ) {
      return 100*0.5*sineWave(period, phase);//100*0.5*(sin(TAU*millis()/(1000*period)+phase)+1);// 0.5*(sin(mil/4000)+1);
    } else if ( type.equals("stepFunction") ) {
      return 0; // not implemented
    } else if ( type.equals("linear") ) {
      return 100*linear(period, phase);
    } else {
      return 0;
    }
  }
}

/* Input shapes. Note that these require a synchronized time int. */

float squareWave(int period) {
  return floor(time/(1000*period))%2;
}

float sineWave(float period, float phase) {
  return sin(TAU*time/(1000*period)+phase)+1;// 0.5*(sin(mil/4000)+1);
}

float linear(float period, float phase) {
  return 2*abs(((float(time)/1000)%period-period/2))/period;
}