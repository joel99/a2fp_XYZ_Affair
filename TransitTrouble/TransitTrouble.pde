/*************************************
 * Transit Trouble by XYZ Affair 
 *************************************/
//NOTE: SCREEN RATIO 3:2
import java.util.ArrayDeque;
import java.util.HashSet;

ArrayList<Train> _trains = new ArrayList<Train>();
ArrayList<Station> _stations = new ArrayList<Station>(); // List of active Stations
ArrayList<TrainLine> _trainlines = new ArrayList<TrainLine>(); // List of active Trainlines

ArrayDeque<Draggable> _selected = new ArrayDeque<Draggable>();
HashSet<Draggable> _hashed = new HashSet<Draggable>();
ArrayDeque<Station> _selectedStations = new ArrayDeque<Station>();
HashSet<Station> _hashedStations = new HashSet<Station>();
boolean _mousePressed = false; // Whether mouse has been pressed. 
boolean _mouseReleased = false;
boolean _lock; // Used if initial click didn't find anything.
TrainLine activeTrainLine = null;
int dragType = 0;
//0 - nothing, 1 - terminal, 2 - connector

// Game Map - GUI

Map map = new Map();

Train testTrain;


void setup() {
  smooth(4);
  strokeWeight(8);
  background(255, 255, 255); // White - Subject to Change
  size(900, 600); // Default Size - Subject to Change

  // ==================================================
  // Debugging
  for (int i = 0; i < 1; i++) {
    genStation();
    //genStation();
  }
  _trainlines.add(new TrainLine(_stations.get(0)));
  genStation();
  _trainlines.get(0).addTerminal(_stations.get(0), _stations.get(1));

  /*
  _trainlines.get(0).connect( _stations.get(0), _stations.get(1) );
   _trainlines.get(0).addTerminal( _stations.get(0), _stations.get(1) );
   _trainlines.get(0).update();
   */
  //Connector c = new Connector(_stations.get(0), _stations.get(1));


  /*
  for (Station s : _stations) {
   _trainlines.get(0).addStation(s);
   } 
   */
  // ==================================================
}

void draw() {
  background(255, 255, 255);

  map.debug(); //Debugging - Maps red dots to each grid coordinate
  //stroke(255);
  fill(255);
  ellipse(mouseX, mouseY, 60, 60); // Debugging

  for (TrainLine tl : _trainlines) {
    tl.update();
  }
  for (Train tr : _trains) {
    tr.update();
  }
  for (Station s : _stations) {
    s.update();
    //if (_selectedStations.contains(s)) s.
    textSize(16); // Debugging
    fill(0); // Debugging
    text(_stations.indexOf(s), s.getX(), s.getY()); // Debugging
  }
  //testTrain.update(); // Debugging
  updateDrag(); // Dragging Mechanism
}

void updateDrag() {
  if (mousePressed && _mousePressed) { // Mouse is being pressed.
    // CASE 1: Mouse was pressed before, and being held down now.  
    if (_lock)
      println("MOUSE STATE: LOCKED"); // Debugging
    else if (mouseListenStation())
      println("ADDED! " + _hashed.size()); // Debugging
    // END CASE 1
  }
}

//assumes I have an deque of stations and things to draggables to process
//WE BUILD USING STATIONS AND PROCESS USING DEQUES!!!
void executeSelected() {
  for (int i = 0; i < _selected.size() - 1; i++) {
    Draggable first = _selected.poll();
    Draggable second = _selected.peekFirst();
    Station firstStation = _selectedStations.poll();
    Station secondStation = _selectedStations.peekFirst();
    // If Terminal
    if (dragType == 1) {
      Terminal tmp = (Terminal)first;
      activeTrainLine.addTerminal(firstStation, secondStation);
      println("EXECUTE: JOIN!"); // Debugging
    }

    // If Connector
    else if (dragType == 2) {
      Station lastStation = _selectedStations.peekLast();
      Connector tmp = (Connector)first;
      activeTrainLine.addStation(firstStation, 
        lastStation, 
        secondStation, 
        tmp);
      println("EXECUTE: CRY!"); // Debugging
    }

    println("EXECUTED"); // Debugging
  }
}


boolean mouseListenStart() {
  boolean flag = false;
outer:
  for (TrainLine tl : _trainlines) { // Looks through all the TrainLines
    // Procedure: Check Draggable
    //            Try hashing if near mouse
    //            If hash success, add it to list of selected
    //            Otherwise, keep checking

    // Pairs -- Connectors
    for (Pair p : tl.getStationEnds()) {
      Draggable A = p.getA();
      Draggable B = p.getB();
      if (A != null && A.isNear())
        if (_hashed.add(A)) {
          _selected.add(A);
          if (A instanceof Terminal){
            _selectedStations.add(((Terminal)A).getStation());
            dragType = 1;
          }
          else{
            Connector tmp = (Connector)A;
            _selectedStations.add(tmp.getStart());
            _selectedStations.add(tmp.getEnd());
            dragType = 2;
          }
          println("selected connect");
          flag = true;
          break outer;
        }
      if (B != null && B.isNear())
        if (_hashed.add(B)) {
          _selected.add(B);
          if (B instanceof Terminal){
            _selectedStations.add(((Terminal)B).getStation());
            dragType = 1;
          }
          else{
            Connector tmp = (Connector)B;
            _selectedStations.add(tmp.getStart());
            _selectedStations.add(tmp.getEnd());
            dragType = 2;
          }
          println("selected connect");
          flag = true;
          break outer;
        }
    }
  }
  //println("stuff is exec");
  if (flag && _selected.size() == 1) activeTrainLine = _selected.getFirst().getTrainLine();
  return flag; // Nothing Detected
}

//precond: mouseListenStart() has been run, there is a train line of concern.
boolean mouseListenStation() {
  for (Station s: _stations){
    //process based on if in trainLine or not, if in activeConcern or not.
    if (s.isNear()){
      //case 1: already of interest - only take action if at end of deque (last done thing)
      if (_selectedStations.contains(s)){
        if (_selectedStations.peekLast() == s){
          _selectedStations.pollLast(); //<>//
          _selected.pollLast();
          
        }
      }
      //case 2: new station???
      else{
        //case 2a: is it not on the trainline: add
        if (activeTrainLine.indexOf(s) == -1){
          _selectedStations.add(s);
          if (dragType == 1){
            _selected.peekLast().setState(-1);
          }
          _selected.add(new Connector(_selectedStations.peekLast(), s, activeTrainLine));
        }
        else {//remove
          
        }
      }
    }
  }
  return false;
}

// ==================================================
// Helper Methods
// ==================================================
void keyPressed() {
  println("LMAO");
  genStation();
  // _trainlines.get(0).addTerminal(_trainlines.get(0).getStation(0), _stations.get(_stations.size() - 1)); // Debugging
}

void mousePressed() {
  if (mouseListenStart()) { // Track what was just clicked.
    println("ADDED! " + _hashed.size()); // Debugging
    println("found on mouseclick");
  } else {
    println("locking");
    _lock = true; // If nothing was clicked, lock the Deque
  }
  _mousePressed = true;
  println("MOUSE STATE : PRESSED"); // Debugging
}

void mouseReleased() {
  // Mouse is not being pressed.
  executeSelected(); // Execute selected items.
  _lock = false; // Unlock the mouse.
  _hashed.clear(); // Clear the hashset.
  _selected.clear(); // Clear the deque of selected items.
  _hashedStations.clear();
  _selectedStations.clear();
  // END CASE 3
  _mousePressed = false;
  activeTrainLine = null;
  println("MOUSE STATE : UNPRESSED"); // Debugging
}

void genStation() {
  ///1s for padding...
  int pad = 2;
  int newStationX = pad + map.minX + int(random(map.maxX - map.minX - 2 * pad));
  int newStationY = pad + map.minY + int(random(map.maxY - map.minY - 2 * pad));
  int ctr = 0;
  while (map.slots[newStationX][newStationY]) {
    if (ctr == 1000) {
      grow();
    }
    newStationX = pad + map.minX + int(random(map.maxX - map.minX - 2 * pad));
    newStationY = pad + map.minY + int(random(map.maxY - map.minY - 2 * pad));
    ctr++;
  }
  _stations.add(new Station(map.transform(newStationX, newStationY)));
  // print(_stations.get(_stations.size() - 1)._x + " " + _stations.get(_stations.size() - 1)._y + "\n");
  // voids station and everything immediately next to it as spots for future stations...
  for (int i = newStationX - 2; i < newStationX + 3; i++) {
    for (int j = newStationY - 2; j < newStationY + 3; j++) {
      map.slots[i][j] = true;
    }
  }

  if ((map.maxX - map.minX) * (map.maxY - map.minY) / _stations.size()  < 20) {
    grow();
  }
}

void grow() {
  map.grow();    
  for (Station s : _stations) {
    s.recalc();
  }
  for (TrainLine tl : _trainlines) {
    tl.recalc();
  }
  for (Train tr : _trains) {
    tr.recalc();
  }
}