ControlPoint cp1;
ControlPoint cp2;
float normalizedX1, normalizedY1, normalizedX2, normalizedY2;

PFont font;
ClipHelper clipBoard = new ClipHelper();
  
void setup() {
  size(500, 500);
  smooth();
  background(255);
    
  font = loadFont("Menlo-Regular-11.vlw"); 
  textFont(font, 11);
  
  cp1 = new ControlPoint();
  cp2 = new ControlPoint();
  cp1.setup(125, 50, 20);
  cp2.setup(375, 450, 20);
}

void draw() {
  background(255); 
  
  // draw lines
  noFill();
  stroke(255, 102, 0, 130);
  line(0, height, cp1.x, cp1.y);
  line(width, 0, cp2.x, cp2.y);
  
  // draw curve
  stroke(0, 0, 0);
  bezier(0, height, cp1.x, cp1.y, cp2.x, cp2.y, width, 0);
  
  // draw cp's
  cp1.draw();
  cp2.draw();
  
  normalizedX1 = truncate(cp1.x / width);
  normalizedY1 = truncate(1.0 - (cp1.y / height));
  normalizedX2 = truncate(cp2.x / width);
  normalizedY2 = truncate(1.0 - (cp2.y / height));

  fill(0, 100, 100);
  text("functionWithControlPoints:" + normalizedX1 +" :" + normalizedY1 +" :" + normalizedX2 +" :" + normalizedY2 , 50, height-20);
}


void mousePressed(){
  if(dist(mouseX, mouseY, cp1.x, cp1.y) < cp1.radius){
    cp1.drag = true;
    return;
  }
  if(dist(mouseX, mouseY, cp2.x, cp2.y) < cp2.radius){
    cp2.drag = true;
    return;
  }
}

void mouseDragged(){  
  if(cp1.drag == true){
    cp1.x = mouseX;
    cp1.y = mouseY;
  }
  if(cp2.drag == true){
    cp2.x = mouseX;
    cp2.y = mouseY;
  }
}

void mouseReleased(){
  cp1.drag = false;
  cp2.drag = false;
  clipBoard.copyString("[CAMediaTimingFunction functionWithControlPoints:" + normalizedX1 +" :" + normalizedY1 +" :" + normalizedX2 +" :" + normalizedY2 +"];");
}

float truncate(float x){
 if ( x > 0 )
   return float(floor(x * 100))/100;
 else
   return float(ceil(x * 100))/100;
}

void keyPressed(){
  cp1.setup(125, 50, 20);
  cp2.setup(375, 450, 20);
}
