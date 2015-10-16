/*
class Button extends PositionalThing {
  boolean active = false;
  int modes, currentMode;
  Button(PVector p) {
    super(p);
    size = 50;
    modes = 1;
    currentMode = 0;
  }
  Button(PVector p, int modes) {
    super(p);
    size = 50;
    this.modes = modes;
    currentMode = 0;
  }
  void display() {
    if(active) {
      fill(100,100,0,200);
    } else {
      if( modes <= 1 ) {
        fill(100,100,0,100);
      } else {
        fill(100,100,map(currentMode,0,modes-1,0,255),100);
      }
    }
    rect(position, size, size);
  }
  boolean isNear(PVector p) {
    if ( p.x > position.x && p.x < position.x + size && p.y > position.y && p.y < position.y + size ) { //TODO: should reference p's size
      return true;
    } else {
      return false;
    }
  }
  void rollOver(PVector p) {
    if( this.isNear(p) ) {
      active = true;
    } else {
      active = false;
    }
  }
  void click() {
    currentMode++;
    currentMode %= modes;
  }
}
class ButtonCollection {
  ArrayList<Button> buttons;
  ButtonCollection() {
    buttons = new ArrayList<Button>();
  }
  void addButton(Button b) {
    buttons.add(b);
  }
  void addButton(PVector p) {
    buttons.add(new Button(p));
  }
  void display() {
    for(Button b : buttons) {
      b.display();
    }
  }
  void hoverOver(PVector p) {
    
  }
}




*/