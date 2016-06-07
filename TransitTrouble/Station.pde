/*************************************
 * Station Class
 * Contains a queue for Persons to enter a Train
 *************************************/

import java.util.PriorityQueue;

public class Station {
  // =======================================
  // Instance Variables
  // =======================================
  private int _shape; // (0 to 6);
  private int _x;
  private int _y;
  private int _gridX;
  private int _gridY;
  private float _crowd; // Health - Higher = Bad
  private PriorityQueue<Person> _line;
  private TrainLine _trainLine;
  private boolean isEnd;
  private Draggable d1;
  private Draggable d2;
  
  // =======================================
  // Default Constructor
  // Creates a station on the lattice grid of Map.
  // =======================================
  public Station(int[] coords) {
    _shape = 0; // To adjust depending on time
    _x = coords[0];
    _y = coords[1];
    _gridX = coords[2];
    _gridY = coords[3];
    _line = new PriorityQueue<Person>();
    _trainLine = null;
    // println(_shape, _x, _y, _gridX, _gridY); // Debugging
  }
    
  // =======================================
  // Mutators and Accessors
  // ======================================= 
  /** getX 
   * returns x location of station **/
  int getX() {
    return _x;
  }
  /** getGridX 
   * returns x location of station on grid **/
  int getGridX() {
    return _gridX;
  }
  
  /** getY
   * returns y location of station **/
  int getY() {
    return _y; 
  }
  /** getGridY 
   * returns y location of station on grid **/
  int getGridY() {
    return _gridY;
  }
  
  /** setX
   * sets x location of station on map **/
  int setX(int newX) {
    int oldX = _x;
    _x = newX;
    return oldX; 
  }
  /** setY
   * sets y location of station on map **/
  int setY(int newY) {
    int oldY = _y;
    _y = newY;
    return oldY; 
  }
  
  /** setTrainLine
   * sets trainline(s) that this Station belongs to */
  void setTrainLine(TrainLine tl){
    _trainLine = tl;
  }
  /** getTrainLine
   * returns trainline(s) that this Station belongs to */
  TrainLine getTrainLine(){
    return _trainLine;
  }
 
  /** isEnd
   * returns whether this Station is at the front or end of the TrainLine */
  boolean isEnd(){
    return isEnd;
  }
  /** setEnd
   * precond: boolean b, telling whether this station is an end Station
   * postcond: isEnd is updated to reflect the Station's state */
  void setEnd(boolean b){
    isEnd = b;
  }
 
  /** getCrowd
   * returns crowdedness value of this Station */
  float getCrowd() {
    return _crowd; 
  }
  /** setCrowd
   * sets crowdedness value to specified float */
  void setCrowd(float newCrowd) {
    _crowd = newCrowd; 
  }
 
  /** recalc
   * precond: integer array contained mapX and mapY
   * postcond: sets _x and _y accordingly */
  void recalc(int[] coords){
    _x = coords[0];
    _y = coords[1];
  } 
   
  // =======================================
  // Drawing Station
  // =======================================
  void update() {
    // Update Crowdedness
    _crowd += 0.01;
    // print(getCrowd()); // Debugging
    
    drawStationHealth(_x,_y,_crowd);
    drawStation(_x, _y, _shape);
  }
}