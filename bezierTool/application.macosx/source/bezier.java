import processing.core.*; 
import processing.xml.*; 

import java.awt.datatransfer.*; 
import java.awt.Toolkit; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class bezier extends PApplet {

ControlPoint cp1;
ControlPoint cp2;
float normalizedX1, normalizedY1, normalizedX2, normalizedY2;

PFont font;
ClipHelper clipBoard = new ClipHelper();
  
public void setup() {
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

public void draw() {
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
  normalizedY1 = truncate(1.0f - (cp1.y / height));
  normalizedX2 = truncate(cp2.x / width);
  normalizedY2 = truncate(1.0f - (cp2.y / height));

  fill(0, 100, 100);
  text("functionWithControlPoints:" + normalizedX1 +" :" + normalizedY1 +" :" + normalizedX2 +" :" + normalizedY2 , 50, height-20);
}


public void mousePressed(){
  if(dist(mouseX, mouseY, cp1.x, cp1.y) < cp1.radius){
    cp1.drag = true;
    return;
  }
  if(dist(mouseX, mouseY, cp2.x, cp2.y) < cp2.radius){
    cp2.drag = true;
    return;
  }
}

public void mouseDragged(){  
  if(cp1.drag == true){
    cp1.x = mouseX;
    cp1.y = mouseY;
  }
  if(cp2.drag == true){
    cp2.x = mouseX;
    cp2.y = mouseY;
  }
}

public void mouseReleased(){
  cp1.drag = false;
  cp2.drag = false;
  clipBoard.copyString("[CAMediaTimingFunction functionWithControlPoints:" + normalizedX1 +" :" + normalizedY1 +" :" + normalizedX2 +" :" + normalizedY2 +"];");
}

public float truncate(float x){
 if ( x > 0 )
   return PApplet.parseFloat(floor(x * 100))/100;
 else
   return PApplet.parseFloat(ceil(x * 100))/100;
}

public void keyPressed(){
  cp1.setup(125, 50, 20);
  cp2.setup(375, 450, 20);
}



class ClipHelper {
  Clipboard clipboard;
  
  ClipHelper() {
    getClipboard();  
  }
  
  public void getClipboard () {
    // this is our simple thread that grabs the clipboard
    Thread clipThread = new Thread() {
	public void run() {
	  clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
	}
    };
  
    // start the thread as a daemon thread and wait for it to die
    if (clipboard == null) {
	try {
	  clipThread.setDaemon(true);
	  clipThread.start();
	  clipThread.join();
	}  
	catch (Exception e) {}
    }
  }
  
  public void copyString (String data) {
    copyTransferableObject(new StringSelection(data));
  }
  
  public void copyTransferableObject (Transferable contents) {
    getClipboard();
    clipboard.setContents(contents, null);
  }
  
  public String pasteString () {
    String data = null;
    try {
	data = (String)pasteObject(DataFlavor.stringFlavor);
    }  
    catch (Exception e) {
	System.err.println("Error getting String from clipboard: " + e);
    }
    return data;
  }
  
  public Object pasteObject (DataFlavor flavor)  
  throws UnsupportedFlavorException, IOException
  {
    Object obj = null;
    getClipboard();
    
    Transferable content = clipboard.getContents(null);
    if (content != null)
    obj = content.getTransferData(flavor);
    
    return obj;
  }
}
class ControlPoint{
  float x, y, radius;
  boolean drag;
  
  public void setup(float _x, float _y, float _radius){
    radius  = _radius;
    x       = _x;
    y       = _y;
    drag    = false;
  }
  
  public void draw(){
    stroke(80,150);
    fill(240, 240, 240);
    ellipse(x, y, radius, radius);
  }
};
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#ffffff", "bezier" });
  }
}
