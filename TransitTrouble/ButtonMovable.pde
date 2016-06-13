/*************************************
 * ButtonMovable Class 
 * Subclass for Train / (Tentative) Locomotive Buttons in game (that can be dragged and dropped)
 *************************************/

public class ButtonMovable extends Button {
  
  int _quantity; //number of trains stacked up (in stock)
  boolean active;
  
  public ButtonMovable( int x, int y, int quantity, int size, int detectRadius, color c ) {
    super(x, y, size, detectRadius, c);
    _quantity = quantity;
  }  
    
  public boolean isActive() {
    return active; 
  }
    
  public void drawCursor( int w, int h, color c ) {
    fill(c);
    rect( mouseX - w/2, mouseY - h/2, w, h );
  }
    
    
    
  public void update() {
    
    if (!mousePressed && active) active = false;
        
    if (super.isClicked()) {
      active = true;
      stroke(0); 
      strokeWeight(5);
      textSize(30);
    }
    else {
      noStroke();
      textSize(20);
    }
    fill(_c);
    
    ellipse( _x, _y, _size, _size ); //draw button
    
    text( _quantity, _x+_size/2.5, _y-_size/2.5 ); //display quantity on topright of button
    
    fill(255);
    rect(_x - _size/4, _y - _size/6, _size/2, _size/3); //display white train icon
    
  }
    
}