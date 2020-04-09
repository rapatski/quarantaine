class KeyScroller {

  PVector acc = new PVector(.6, .6, 1);
  float damp = .93;

  PVector vel = new PVector();
  PVector pos = new PVector();

  PVector origPos = new PVector();

  HashMap<String, Boolean> keypresses = new HashMap<String, Boolean>();
  char keyreleased = 0;

  KeyScroller() {
  }

  KeyScroller(float _acc, float _damp) {
    acc = new PVector(_acc, _acc, _acc);
    damp = _damp;
  }

  KeyScroller(float _x, float _y, float _z) {
    pos = new PVector(_x, _y, _z);
    origPos.set(pos);
  }

  KeyScroller(float _x, float _y, float _z, float _acc, float _damp) {
    this(_x, _y, _z);
    acc = new PVector(_acc, _acc, _acc);
    damp = _damp;
  }

  KeyScroller(float _x, float _y, float _z, float _accX, float _accY, float _accZ) {
    this(_x, _y, _z);
    acc = new PVector(_accX, _accY, _accZ);
  }

  KeyScroller(PVector _pos, PVector _acc) {
    pos.set(_pos);
    origPos.set(pos);
    acc.set(_acc);
  }

  KeyScroller(PVector _pos, PVector _acc, float _damp) {
    this(_pos, _acc);
    damp = _damp;
  }


  float x() { 
    return pos.x;
  }
  float y() { 
    return pos.y;
  }
  float z() { 
    return pos.z;
  }

  void reset()
  {
    pos.set(origPos);
    vel.mult(0);
  }

  void handleKeyPresses(char key)
  {
    if (key == CODED) {
      keypresses.put(str(keyCode), true);
    }
    else {
      keypresses.put(str(key), true);
    }
  }

  void handleKeyReleased(char key)
  {
    if (key == CODED) {
      keypresses.remove(str(keyCode));
    } else {
      keypresses.remove(str(key));
    }


    keyreleased = key;
  }

  void handleKeyActions(HashMap<String, Boolean> _keypresses, char _keyreleased) 
  {
    // handle keypresses
    if (keyPressed)
    {
      if (_keypresses.containsKey("37") || _keypresses.containsKey("w")) // left 
      {
        vel.x += acc.x;
      }
      if (_keypresses.containsKey("39") || _keypresses.containsKey("e")) // right 
      {
        vel.x -= acc.x;
      }
      if (_keypresses.containsKey("38") || _keypresses.containsKey("n")) // up 
      {
        vel.y += acc.y;
      }
      if (_keypresses.containsKey("40") || _keypresses.containsKey("s")) // down 
      {
        vel.y -= acc.y;
      }
      if (_keypresses.containsKey("=") || _keypresses.containsKey("+")) {
        vel.z += acc.z;
      }
      if (_keypresses.containsKey("-") || _keypresses.containsKey("_")) {
        vel.z -= acc.z;
      }
    }
    
      vel.mult(damp);
    


    // handle keyreleases
    if (_keyreleased == ENTER) {
      reset();
    }

    if (_keyreleased == 'p' || _keyreleased == 'P') {
      println("Scroller position: ("+x() + ", "+y()+")");
    }

    // reset keyreleased
    keyreleased = 0;
  }

  void update() { 

    handleKeyActions(keypresses, keyreleased);

    pos.add(vel);
  }


  PVector getDirection() {
    PVector v = new PVector(vel.x, vel.y);
    return v.normalize(null);
  }
}
