class ControlPoint{
  float x, y, radius;
  boolean drag;
  
  void setup(float _x, float _y, float _radius){
    radius  = _radius;
    x       = _x;
    y       = _y;
    drag    = false;
  }
  
  void draw(){
    stroke(80,150);
    fill(240, 240, 240);
    ellipse(x, y, radius, radius);
  }
};
