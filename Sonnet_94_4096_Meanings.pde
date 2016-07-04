/*
Before becoming a GitHub repository, this file was
stored locally as Diamond_vectors_15

Diamond using vectors 15

Shows the sonnet first, then reconfigures it
to the diamond. All horribly messy and could
do with encapsulation or something

---

Continuing the mission to eliminate all of the
translate() commands in the instruction section
of the program.

Create an array of functions in Java: http://www.devx.com/tips/Tip/13370

pause implementation works for operation 14, but the pause functionality
is disabled for all other operations.

added the word 'but' to some of the comparison types to emphasise the
idea of irony

The order of the sequence of paraphrase comparisons has been made identical to that of the 
grid, but unfortunately by eye. Could the order[] alternatively be used to do this?
----
-pause implementation still crappy
----

Arguments for the line methods:

new MLine(X_START, Y_START, X_TERMINATE, Y_TERMINATE, ARRAY_POSITION)
.shrink(SHRINK_RATE_IN_PIXELS_PER_FRAME,FINAL_LENGTH_OF_LINE);
.makeRotate(ROTATION_RATE_IN_RADIANS_PER_FRAME,TOTAL_NUMBER_OF_RADIANS_TO_BE_ROTATED);
.snap(); //snaps the line to the horizontal or vertical if it is within + or - 0.02 rads of horizontal or vertical

Arguments for methods of rectangle sequence object:

new Rects(NUMBER_OF_RECTANGLES_TO_BE_PLACED_TOGETHER, X_CENTRE, Y_CENTRE, INDIVIDUAL RECTANGLE WIDTH);
.expandRects(RATE_OF_EXPANSION_PIXELS_PER_FRAME,TARGET_WIDTH,RECTANGLE_HEIGHT);
.display(STROKE_VALUE);

Arguments for the MMatrix object:

new MMatrix(START_X_CENTRE, START_Y_CENTRE, SIDE_LENGTH);
.reduce(RATE);
.turn(RATE);
.shift(RATE, TARGET_Y);
.display();

----

*/

MLine[] l = new MLine[6]; //for the diamond

MMatrix m;
Trisector t;

MLine[] k = new MLine[6];                      //for the 2*2 matrix
MLine[] trisector = new MLine[3];              //for the blue lines that slice through the rectangles

Rects sequence;                                //this object is the rectangle sequence, must 
                                               //not be initalized here for arguments to be passed
                                               //successfully through the constructor
                                               
Rects[] shifters = new Rects[6];               //for treating each rectangle as an individual object

PVector[][] compPoints = new PVector[6][2];    //to log the tips of the MLines in the Diamond Comparison structure
int[] order = new int[6];                      //to log the left-to-right relative order of the tips on the screen
PVector[][] gridPoints = new PVector[6][4];    //to log the centre of each square in the combination grid

PBridge[][] layout = new PBridge[6][4];
PBridge[][] locations = new PBridge[4096][6];

int counter;

float span;
float matX,matY;
float spacing;        //for the gaps between the rectangles
float rw;             //rectangle width: this is set in initialize() to be 1/4 of the height of the rectangles
int operation;
PFont feedback;
int pbridgeCount;
int op;               //for pausing
int quadFont;         //the size of the text in the quadrant
int diaFont;          //for the diamond labels

int lineSpacing;
float average;        //for the average width of the sonnet
int opacity;
PVector[] nodes = new PVector[4];
PVector[] targets = new PVector[4];
float[] rates = new float[4];

//for the paraphrases
String[] things = {"owner","flower","person addressed","lily"};
String[] feelings = {"is like and should be like","is unlike but should be like","is unlike and shouldn't be like","is like but shouldn't be like"};
String[] paraphrases = new String[4096];
String[] tempStrings = new String[6];

String[] sonnet = new String[14];

boolean axes;
boolean paused;

void setup() {
  size(950,950);
  span = 200;        //change this value to scale the dynamic diagrams
  matX = 120;        //for placement of the quadrant
  matY = 120;
  quadFont = 10;
  diaFont = 14;
  opacity = 255;
  lineSpacing = 3;
  feedback = createFont("SansSerif",diaFont);
  initialize();
}

void draw() {
 background(255);
 if (axes) {
 axes(width/2,height/2,rw/2);
 }

pushMatrix();
   translate(width/2,height/2);
   textAlign(CENTER,CENTER);
   textSize(diaFont);
   text("Operation: "+operation,0,-height/2+100);
popMatrix();

/* SECTION 1 */

// Operation 1

if (operation == 1) {
  if (frameCount < 180) {
  fill(0);
  displaySonnet();
  } else {
   operation = 2; 
  }
}

// Operation 2

if (operation == 2) {
  if (opacity >= 100) {
  fill(0,opacity);
  displaySonnet();
    
   opacity-=3;
  } else {
   operation = 3;
   op = 0;
  }
}

// Operation 3

if (operation == 3) {
  op++;
  if (op < 100) {
  fill(0,opacity);
  displaySonnet();
  stroke(0);
  connect();
  } else {
   operation = 4; 
  }
}

// Operation 3

if (operation == 4) {
  
  for (int i = 0 ; i < 4 ; i++) {
    PVector pathe = PVector.sub(targets[i],nodes[i]);
    float tempMag = pathe.mag();
    if (tempMag > 2) {
    tempMag-=rates[i];
    pathe.setMag(tempMag);
    nodes[i] = PVector.sub(targets[i],pathe);
    } else {
      for (int j = 0 ; j < 4 ; j++) {
      nodes[j] = targets[j];
      }
      operation = 5;
      op = 0;
    }  
  }
  
  connect();
  
}

// Operation 4

if (operation == 5) {
  op++;
  if (op < 200) {
    connect();
  } else {
   operation = 6;
   op = 0;
  }
}

/* SECTION 2 */

// Operation 6

if (operation == 6) {
  //the MLine array assumes the role
  //of displaying the diamond
 if (op < 60) {
 op++;
 } else {
  operation = 7;
 } 
}

// Operation 7

if(operation == 7) {
  if(l[3].dispBool) {
  
    l[3].displace(-2*rw,0,-1,0);
    l[2].displace(2*rw,0,1,0);
    l[4].displace(-rw,0,-0.5,0);
    l[5].displace(rw,0,0.5,0);

  } else {      
    operation = 8;
    reset();
  }
}

// Operation 8

if(operation == 8) {
  if(l[3].rotBool) {
    
    l[3].makeRotate(0.01,PI/4);
    l[5].makeRotate(0.01,PI/4);
    l[2].makeRotate(-0.01,-PI/4);
    l[4].makeRotate(-0.01,-PI/4);
    
   } else {
     operation = 9; 
     reset();
 }
}

// Operation 9

if(operation == 9) {
  if(l[3].dispBool){
    float temp = sqrt(2*(span*span))/2;
  
      l[3].displace(0,-temp,0,-1);
      l[2].displace(0,-temp,0,-1);
      l[4].displace(0,temp,0,1);
      l[5].displace(0,temp,0,1);

    } else {
      operation = 10;
      reset();
    }
}

// Operation 10

if(operation == 10) {
  
  if(l[1].dispBool) {
    l[1].displace(0,-span,0,-1);
  }

  if(l[1].rotBool) {
    l[1].makeRotate(0.01,PI/2);
  } else {
    l[1].snap(); //so that when l[1] is dragged up the screen 
  }              //it is perfectly straight

  if((l[1].rotBool == false)&&(l[1].dispBool == false)) {
    operation = 11;
    reset();
  }
}

// Operation 11

if(operation == 11) {

  if(l[0].dispBool) {
    l[0].displace(rw/2,0,0.5,0);
  }

  if(l[1].dispBool) {
    l[1].displace(span-rw/2,0,1,0);
    l[3].displace(span-rw/2,0,1,0);
    l[4].displace(span-rw/2,0,1,0);  
  }

  if(l[2].dispBool) {
    l[2].displace(-span+rw/2,0,-1,0);
    l[5].displace(-span+rw/2,0,-1,0);
  } else {
    operation = 12;
    reset();
  }
}

// Operation 12

if (operation == 12) {
  if(l[0].shrinkBool) {
    float temp = sqrt(2*(span*span));
    
    l[0].shrink(1,temp); //chops off the top
    l[0].displace(0,-temp/2,0,-0.5); // moves it up
    l[1].displace(0,temp/2,0,0.5);
    l[1].shrink(1,temp);
  } else {
    operation = 13;
  }
}

  if ((operation < 13) && (operation > 5)) {
      shiftDiamond(true,width/2,height/2);
      logTips();    //stores the locations of the Diamond MLine tips,
                    //with a drawing origin at width/2,height/2
                    
      show();       //invokes the display method of the Diamond MLines
      shiftDiamond(false,width/2,height/2); //recentres the Diamond structure about the drawing origin
  }

/* SECTION 3 */

// Operation 13

if (operation == 13) {
  if(sequence.expBool) {
    float rectHeight = sqrt(2*(span*span));
    sequence.expandRects(1,rw,rectHeight);
  } else {
    //log the centres of the squares that make up
    //the newly expanded combination grid
       float cx = sequence.centre.x;
       float cy = sequence.centre.y;
    for (int i = 0 ; i < gridPoints.length ; i++) {
      for (int j = 0 ; j < gridPoints[j].length ; j++) {
        float adjX = cx+(-3*rw)+(rw/2)+(i*rw);
        float adjY = cy+(-2*rw)+(rw/2)+(j*rw);
        gridPoints[i][j] = new PVector(adjX,adjY);
      }
    }
    
    operation = 14;
    sequence.expBool = false;
  }
}

//keep this sequence rect object as
//a drone until operation 12 begins

    if ((operation >= 13) && (operation < 18)) {
    sequence.display();     
    }
    
// Operation 14+

if (operation == 14) {
 if(!m.reduced) {
   m.reduce(1);
  } else {
    operation = 15;
  }
} 

//Operation 15

if (operation == 15) {
 if (!m.turned) {
   m.turn(0.01);
 } else {
   operation = 16;
 }
}

//Operation 16

if (operation == 16) {
 if (!m.shifted) {
   m.shift(1,height/2);
 } else {
  operation = 17;
 }
}

//Operation 17

if (operation == 17) {
 if (!t.complete) { //t stands for trisector
   t.slice();
   t.display();
   
   float gap = sequence.centre.x - m.loc.x-(3*rw);
   float overlap = t.magnitude - gap;
   if (!t.extended && ((overlap/abs(overlap)) == 1)) {
     for (int i  = 0 ; i < int(floor(overlap/rw)) ; i++) {
        fill(0,0,255);
        textSize(quadFont);
        lsbl(gridPoints[i][0].x,gridPoints[i][0].y);
        unsbl(gridPoints[i][1].x,gridPoints[i][1].y);
        lsnbl(gridPoints[i][3].x,gridPoints[i][3].y);
        unsnbl(gridPoints[i][2].x,gridPoints[i][2].y);
        noFill();
     }
   }
   
   stroke(0);
 } else {
  operation = 18; 
 }
}

  if (operation > 16 && operation < 21) {
   if (t.extended) {
     for (int i  = 0 ; i < gridPoints.length ; i++) {
       //in cases such as these, perhaps it would make sense
       //to think about making arrays of functions?
        fill(0,0,255);
        textSize(quadFont);
        lsbl(gridPoints[i][0].x,gridPoints[i][0].y);
        unsbl(gridPoints[i][1].x,gridPoints[i][1].y);
        lsnbl(gridPoints[i][3].x,gridPoints[i][3].y);
        unsnbl(gridPoints[i][2].x,gridPoints[i][2].y);
        noFill();
     }
   }
  }
  
//Operation 18

//modify the display method of the rect object
//and then make 6 individual rect objects

if (operation == 18) {
  if (counter < 100) { //simply using the counter to introduce a short pause
   stroke(0,0,255);
       displayShifters(true,width/2,height/2);
     counter++;
  } else {
   operation = 19;
   counter = 0; 
  }
}

    //Quadrant drone
    if ((operation < 19) && (operation > 2)) { //if this number is changed,
     m.display();                              //remember to change the range
    }                                          //during which m's text entries
                                               //display
//Operation 19

if (operation == 19) {
  float sep = spacing; //value for the target magnitude of the 
                       //space between the rectangles

     if (shifters[2].dispBool) {
       for (int i = 0 ; i < shifters.length ; i++) {
         shifters[i].displace((-5+(i*2))*sep/2,(-5+(i*2)));
       }
       
       //update the locations of the comparison values
       //by assigning movement rates that correspond to
       //the position of their IDs in the order[] array.
       
       for (int i = 0 ; i < order.length ; i++) {
            int index = order[i];
             compPoints[index][0].x+=(-5+(i*2));
             compPoints[index][1].x+=(-5+(i*2));
       }
       
     } else {
       //snapping
       for (int i = 0 ; i < shifters.length ; i++) {
        float ognShift = ((shifters.length*rw)+((shifters.length-1)*sep))/2;
        shifters[i].centre.x = -ognShift+(rw/2)+(i*(sep+rw));
       //and snap the tip and tail locations
       //so that the horizontal alignment of
       //the font is correct
       
        //this step, with the order[] array, is necessary
        //because unlike the shifters[] array, the ordering
        //of elements in the compPoints[] array does not
        //correspond to the order of their horizontal positioning
        //on the screen.
        int tempIndex = order[i];
        
        compPoints[tempIndex][0].x = shifters[i].centre.x+width/2; //<- +width/2 is unfortunately necessary
        compPoints[tempIndex][1].x = shifters[i].centre.x+width/2; //because shifters are aligned about the origin
       }                                                           //and are translated to the centre of the screen
                                                                   //when the .display() method is called
       operation = 20;
         
     }
            //update the log of the centre locations of grid squares
       
   for (int i = 0 ; i < gridPoints.length ; i++) {
    for (int j = 0 ; j < gridPoints[j].length ; j++) {
      gridPoints[i][j].x = shifters[i].centre.x+width/2;
      }                                                    
    }
    
     stroke(0);
     displayShifters(true,width/2,height/2);
}

/* SECTION 4 */

//Operation 20

if (operation == 20) {
   stroke(0);
       noFill();
     displayShifters(true,width/2,height/2);
     stroke(0);
     //showPBridge();
       strokeWeight(2);
       stroke(200,0,0,150);
     pushMatrix();
     translate(width/2,height/2);
     displayIndex(constrain(pbridgeCount,0,4095));
     popMatrix();
     writePossibility(pbridgeCount);
     if (frameCount%60 == 0) { //the rate at which the combinations are run through
     if (!paused) {
     pbridgeCount++;
     }
     }
       strokeWeight(1);
       stroke(0);
}

//Text

 //Quadrant labels
 if ((operation < 15) && (operation > 2)) {
 textSize(quadFont);
 fill(0);
 textAlign(CENTER,CENTER);
  text("like",m.matPoints[0].x,m.matPoints[0].y-(3*rw/4));
  text("unlike",m.matPoints[1].x,m.matPoints[0].y-(3*rw/4));
  
  float textX = m.matPoints[0].x-(3*rw/4);
  float textY = m.matPoints[0].y;
  text("should",textX,textY-10);
    text("be",textX,textY);
      text("like",textX,textY+10);
      
      textY = m.matPoints[3].y;
  text("should",textX,textY-15);
    text("not",textX,textY-5);
      text("be",textX,textY+5);
        text("like",textX,textY+15);
 }
 
 //Within each square of the quadrant
 if ((operation < 19) && (operation > 2)) {
 fill(0,0,255);
 textSize(quadFont);
 textAlign(CENTER,CENTER);
 
  //Top left
  lsbl(m.matPoints[0].x,m.matPoints[0].y);
  
  //Top right
  unsbl(m.matPoints[1].x,m.matPoints[1].y);
  
  //Bottom left
  lsnbl(m.matPoints[3].x,m.matPoints[3].y);
  
  //Bottom right
   unsnbl(m.matPoints[2].x,m.matPoints[2].y);
 }
 
 //The diamond
 
 fill(0);
 textSize(diaFont);
 if (operation < 6) {
   if (operation < 4) {
    textAlign(CENTER,CENTER);
   } else {
    textAlign(CENTER,BOTTOM);
   }
 text("owners",nodes[1].x,nodes[1].y);
 text("flower",nodes[2].x,nodes[2].y);
 text("Lilies",nodes[0].x,nodes[0].y);
 } else {
 textAlign(CENTER,BOTTOM);
 text("Owner",compPoints[5][1].x,compPoints[5][1].y);
 text("Flower",compPoints[1][0].x,compPoints[1][0].y);
 text("Lily",compPoints[2][0].x,compPoints[2][0].y);
 }
  
 if (operation > 6) {
 textAlign(CENTER,BOTTOM);
  text("Owner",compPoints[0][1].x,compPoints[0][1].y);
  text("Owner",compPoints[4][1].x,compPoints[4][1].y);
  text("Flower",compPoints[3][0].x,compPoints[3][0].y);
 textAlign(CENTER,TOP);
  text("Flower",compPoints[4][0].x,compPoints[4][0].y);
  text("Lily",compPoints[5][0].x,compPoints[5][0].y);
  text("Lily",compPoints[1][1].x,compPoints[1][1].y);

  text("Person",compPoints[0][0].x,compPoints[0][0].y);
    text("Addressed",compPoints[0][0].x,compPoints[0][0].y+14);
  text("Person",compPoints[2][1].x,compPoints[2][1].y);
    text("Addressed",compPoints[2][1].x,compPoints[2][1].y+14);
 }
 
 if (operation < 6) {
   if (operation < 4) {
     textAlign(CENTER,BOTTOM);
   } else {
     textAlign(CENTER,TOP);
   }
  textSize(diaFont);
  text("Person",nodes[3].x,nodes[3].y);
    text("Addressed",nodes[3].x,nodes[3].y+14);
 } else {
 textAlign(CENTER,TOP);
  textSize(diaFont);
  text("Person",compPoints[3][1].x,compPoints[3][1].y);
    text("Addressed",compPoints[3][1].x,compPoints[3][1].y+14);
 }
noFill();
//saveFrame("trace-###.png");

} //end of draw()

/*
---------------------------------------------------------------
                           FUNCTIONS
                  FUNCTIONS         FUNCTIONS        
         FUNCTIONS         FUNCTIONS         FUNCTIONS
FUNCTIONS         FUNCTIONS         FUNCTIONS         FUNCTIONS
---------------------------------------------------------------
*/

void show() {
    for(int i = 0 ; i < l.length ; i++) {
      l[i].display(false); //pass 'true' to see line IDs
      }
}

 void shiftDiamond(Boolean b, float xShift, float yShift) {
        PVector shiftVec = new PVector(xShift,yShift); 
   if (b) {
      for (int i = 0 ; i < l.length ; i++) {
        l[i].start.add(shiftVec);
        l[i].term.add(shiftVec);
      }
    } else {
      for (int i = 0 ; i < l.length ; i++) {
        l[i].start.sub(shiftVec);
        l[i].term.sub(shiftVec);
      }
    }
  }

void logTips() { //contains a sorting algorithm
  for (int i = 0 ; i < compPoints.length ; i++) {
    compPoints[i][0] = new PVector(l[i].start.x,l[i].start.y);
    compPoints[i][1] = new PVector(l[i].term.x,l[i].term.y);
   }
   
   //establish order with sorting algorithm
   float logger = compPoints[0][0].x;
   int id = 0;
   
   for (int i = 0 ; i < compPoints.length ; i++) {
     for (int j = 0 ; j < compPoints.length ; j++) {
           if (i == 0) {
             if (compPoints[j][0].x < logger) {
                  logger = compPoints[j][0].x;
                  id = j;
             }
           } else {
             int preIndex = order[i-1];
             if ((compPoints[j][0].x < logger) && (compPoints[j][0].x > compPoints[preIndex][0].x)) {
                 logger = compPoints[j][0].x;
                 id = j;
              }
           }
       }
       order[i] = id;   //this order[] array holds the indexes of
       logger = 2000;   //the MLines in the order of their x-position
     }
}

void initialize() {
  stroke(0);
  operation = 1;
  average = 0;
  sequence = new Rects(6,width/2,height/2,0); //must be initialized here, not before setup()
  
  sequence.counter = 0;
  sequence.tempW = 0;
  sequence.expBool = true;
  
  rw = sqrt(2*(span*span))/4;
  spacing = 60;
 
  axes = true;
  paused = false;
  
  fillSonnet();
  calcRates();
  
  //make up the cross in the centre
  l[0] = new MLine(0,span,0,-span,0); //vertical
  l[1] = new MLine(-span,0,span,0,1); //horizontal
  
  for(int i = 2 ; i < 6 ; i++) {
  
    float sx,sy,tx,ty;
    
    if((i-2)%2 == 0) {          //to initialize with the correct pivot points
      sx = span*cos((i-2)*PI/2);
      sy = span*sin((i-2)*PI/2);
      tx = span*cos((i-1)*PI/2);
      ty = span*sin((i-1)*PI/2);
    } else {
      tx = span*cos((i-2)*PI/2);
      ty = span*sin((i-2)*PI/2);
      sx = span*cos((i-1)*PI/2);
      sy = span*sin((i-1)*PI/2);
    }
  //the sloping sides of the diamond
  l[i] = new MLine(sx,sy,tx,ty,i);
  
  }
  //ensures that the address numbers of the lines
  //appear at the top of the lines
  
  l[3].end = false;
  l[2].end = false;
  l[1].end = false;
  
  //initialzie 2*2 matrix object
  
    m = new MMatrix(matX,matY,rw);
    
  //initialize the Trisector object, which requires
  //m's x location. Trisector assumes the matrix/column 
  //will ultimately have y == height/2
    
    t = new Trisector(rw,m.loc.x);
  
  //initialize the bits that stick out of the 2*2 matrix
  
  k[0] = new MLine(-rw,rw,-3*rw/2,rw,0);
  k[1] = new MLine(-rw,0,-3*rw/2,0,1);
  k[2] = new MLine(-rw,-rw,-3*rw/2,-rw,2);
  
  k[3] = new MLine(-rw,-rw,-rw,-3*rw/2,3);
  k[4] = new MLine(0,-rw,0,-3*rw/2,4);
  k[5] = new MLine(rw,-rw,rw,-3*rw/2,5);
  
  //initialize the Mlines that will eventually
  //slice through the assembled rectangles
  
  trisector[0] = new MLine(0,-rw,1,-rw,0);
  trisector[1] = new MLine(0,0,1,0,1);
  trisector[2] = new MLine(0,rw,1,rw,2);
  
  //initialize the 6 individual Rect objects
  //for operation 13+
  
  for (int i = 0 ; i < shifters.length ; i++) {
    //One rectangle,with its centre at -3 rectangle
    //widths + half a rectangle width
    
    shifters[i] = new Rects(1,(-rw*shifters.length/2)+(rw/2)+(i*rw),0,rw);
 
  }
  
  pbridgeCount = 0;
  initializePBridge();
  
  reset();
}

void keyPressed() {
  if (key == 'a') {
   axes = !axes; 
  }
  
  if (key == 'p') {
   if (operation >=14) {
    paused = !paused;
   } 
  }
  
  if (key == 'r') {
   saveFrame("commentary-###.png"); 
  }
}

void fillSonnet() {
  
 //1 of 2: fill the sonnet array
 
 textSize(diaFont); //so that textWidth() works correctly
  
 sonnet[0] = "They that have power to hurt, and will do none,";
 sonnet[1] = "That do not do the thing, they most do show,";
 sonnet[2] = "Who moving others, are themselves as stone,";
 sonnet[3] = "Unmoved, cold, and to temptation slow:";
 sonnet[4] = "They rightly do inherit heaven’s graces,";
 sonnet[5] = "And husband nature’s riches from expense,";
 sonnet[6] = "They are the lords and            of their faces,";
 sonnet[7] = "Others, but stewards of their excellence:";
 sonnet[8] = "The summer’s            is to the summer sweet,";
 sonnet[9] = "Though to itself, it only live and die,";
 sonnet[10] = "But if that flower with base infection meet,";
 sonnet[11] = "The basest weed outbraves his dignity:";
 sonnet[12] = "For sweetest things turn sourest by their deeds,";
 sonnet[13] = "        that fester, smell far worse than weeds.";
 
 //2 of 2: work out the locations of the comparison-objects
 //as they feature in the sonnet
 
 //average width of a sonnet line
 
         for (int i = 0 ; i < sonnet.length ; i++) {
           average+=textWidth(sonnet[i]);
         }
 average = average/(sonnet.length+1);
 
 //positions of the comparison-objects when they
 //are displayed in the sonnet

 //the sonnet text is horizontally centred, but left justified
 //x location = (midpoint of the screen) - 
 //             (half of the average width of a sonnet line) +
 //             (the length of the line up to the centre of the desired word)
 
 //the sonnet text is vertically centred
 //y location = (midpoint of the screen) - 
 //             (half of the total height of the sonnet i.e. ((line spacing*13)+(font height * 14))/2 ) +
 //             (the height of sonnet up to the middle of the line in question)
 
 float hCentre = (width/2)-(average/2);
 float vCentre = (height/2)-(((lineSpacing*13)+(diaFont*14))/2);
 float xl;
 float yl;

       //Owner
       xl = hCentre+textWidth("They are the lords and own")-5; //the -5 is a fudge
       yl = vCentre+((6*lineSpacing)+(6*diaFont)+(diaFont/2));
         compPoints[5][1] = new PVector(xl,yl);
       
       //Flower
       xl = hCentre+textWidth("The summer's flo")+7; //the +7 is a fudge
       yl = vCentre+((8*lineSpacing)+(8*diaFont)+(diaFont/2));
         compPoints[1][0] = new PVector(xl,yl);
       
       //Lily
       xl = hCentre+textWidth("Lil")+2; //the +2 is a fudge
       yl = vCentre+((13*lineSpacing)+(13*diaFont)+(diaFont/2));
         compPoints[2][0] = new PVector(xl,yl);
         
       //Person Addressed
         compPoints[3][1] = new PVector(width/2,200);
         
//this is messy!
 nodes[0] = compPoints[2][0];
  targets[0] = new PVector((width/2)+(span*cos(0)),(height/2)+(span*sin(0)));

 nodes[1] = compPoints[5][1];
  targets[1] = new PVector((width/2)+(span*cos(3*PI/2)),(height/2)+(span*sin(3*PI/2)));

 nodes[2] = compPoints[1][0];
  targets[2] = new PVector((width/2)+(span*cos(PI)),(height/2)+(span*sin(PI)));

 nodes[3] = compPoints[3][1]; //correct
  targets[3] = new PVector((width/2)+(span*cos(PI/2)),(height/2)+(span*sin(PI/2)));
 
}

void displaySonnet() {
 textAlign(LEFT,CENTER);
 textSize(diaFont);
   for (int i = 0 ; i < sonnet.length ; i++) {
      float topEdge = (height/2)-((lineSpacing/2)+(6*lineSpacing)+(13*diaFont/2));  
      text(sonnet[i],(width/2)-average/2,topEdge+(i*(diaFont+lineSpacing)));
   }
}

void connect() {
 for (int i = 0 ; i < nodes.length ; i++) {
  for (int j = i+1 ; j < nodes.length ; j++) {
    line(nodes[i].x,nodes[i].y,nodes[j].x,nodes[j].y);
  }
 }
}

void calcRates() {
 for (int i = 0 ; i < 4 ; i++) {
  PVector pathe = PVector.sub(targets[i],nodes[i]);
  rates[i] = pathe.mag()/180; //120 for 2 seconds
 }
}

void reset() {
 
 for (int i = 0 ; i < l.length ; i++) {
     l[i].shrinkBool = true;
     l[i].dispBool = true;
     l[i].rotBool = true;
     l[i].snap();
 }
 
}

void axes(float xLoc, float yLoc, float tick) {
 stroke(100,150);
 pushMatrix();
   translate(xLoc,yLoc);
 
 line(-width/2,0,width/2,0);
 int countX = 1;
 
 while((tick*countX) < width/2) {
   line(tick*countX,-4,tick*countX,4);
   line(-tick*countX,-4,-tick*countX,4);
   countX++;
 }
 
 line(0,-height/2,0,height/2);
 int countY = 1;
 
  while((tick*countY) < height/2) {
    line(-4,tick*countY,4,tick*countY);
    line(-4,-tick*countY,4,-tick*countY);
   countY++;
 }
 
  arrow(width/2,0,0,10);
  arrow(0,height/2,PI/2,10);
 popMatrix();
 stroke(0);
}

void displayTrisector() {
  for (int i = 0 ; i < trisector.length ; i++) {
        trisector[i].display(false);
      }
}

void displayShifters(Boolean div, float xcent, float ycent) {
  pushMatrix();
  translate(xcent,ycent);
    for (int i = 0 ; i < shifters.length ; i++) {
       if (div) {
        shifters[i].split = true; 
       } else {
        shifters[i].split = false; 
       }
       shifters[i].display();
     }
  popMatrix();
}

void initializePBridge() {
  
 layout = new PBridge[6][4];
 locations = new PBridge[4096][6];
 
 float plateau = rw+10; //would be better if this +10 became more like a ratio
 float vSpacing = rw;
 float shallowness = rw/4;
 float separation = spacing-(2*shallowness)-(plateau-rw);
 
 float oSet = -((shallowness*12)+(plateau*6)+(separation*5))/2;

PVector av = new PVector(0,0);
PVector bv = new PVector(shallowness,-(vSpacing*2));
PVector cv = new PVector(shallowness+plateau,-(vSpacing*2));
PVector dv = new PVector(plateau+(2*shallowness),0);
 
 for (int i = 0 ; i < 6 ; i++) {
  for (int j = 0 ; j < 4 ; j++) {
   
    PVector aa,bb,cc,dd;
    
      aa = new PVector(oSet+i*dv.x+(i*separation),0);
      bb = new PVector(oSet+(i*dv.x)+bv.x+(i*separation),-(3*vSpacing/2)+(j*vSpacing));
      cc = new PVector(oSet+(i*dv.x)+cv.x+(i*separation),-(3*vSpacing/2)+(j*vSpacing));
      dd = new PVector(oSet+(i*dv.x)+dv.x+(i*separation),0);
    
      layout[i][j] = new PBridge(aa,bb,cc,dd);
  } 
 }
 
 //serious loopiness begins, use recursion?
 //initialize paths as well as paraphrases
 
 //the order of the sequence of comparisons
 //has been made identical to that of the 
 //grid, but unfortunately by eye.
 //Could the order[] alternatively be
 //used?
 
 for (int a = 0 ; a < 4 ; a++) {
    tempStrings[0] = things[1]+" "+feelings[a]+" the "+things[2];
  for (int b = 0 ; b < 4 ; b++) {
     tempStrings[1] = "the "+things[0]+" "+feelings[b]+" the "+things[1];
   for (int c = 0 ; c < 4 ; c++) {
      tempStrings[2] = "the "+things[1]+" "+feelings[c]+" the "+things[3];
    for (int d = 0 ; d < 4 ; d++) {
       tempStrings[3] = "the "+things[0]+" "+feelings[d]+" the "+things[2];
     for (int e = 0 ; e < 4 ; e++) {
         tempStrings[4] = "the "+things[0]+" "+feelings[e]+" the "+things[3];
      for (int f = 0 ; f < 4 ; f++) {
            tempStrings[5] = "the "+things[3]+" "+feelings[f]+" the "+things[2];
            paraphrases[pbridgeCount] = "The "+tempStrings[0]+" && "+tempStrings[1]+" && "+tempStrings[2]+" && "+tempStrings[3]+" && "+tempStrings[4]+" && "+tempStrings[5]+".";
         
         locations[pbridgeCount][0] = layout[0][a];
         locations[pbridgeCount][1] = layout[1][b];
         locations[pbridgeCount][2] = layout[2][c];
         locations[pbridgeCount][3] = layout[3][d];
         locations[pbridgeCount][4] = layout[4][e];
         locations[pbridgeCount][5] = layout[5][f];
         pbridgeCount++;
       }
      }
     }
    }
   }
  }
 
 //serious loopiness ends
 pbridgeCount = 0;

}

void showPBridge() {
  
 for (int i = 0 ; i < 6 ; i++) {
   for (int j = 0 ; j < 4 ; j++) {
     layout[i][j].display();
   }
 }
 
}

void displayIndex(int idx) {
  
  if (idx < 4096) {
     for (int i = 0 ; i < 6 ; i++) {
       locations[idx][i].display();
     
         if (i > 0) {
             float xsl = locations[idx][i-1].bridgePoints[3].x;
             float ysl = locations[idx][i-1].bridgePoints[3].y;
             
             float xel = locations[idx][i].bridgePoints[0].x;
             float yel = locations[idx][i].bridgePoints[0].y;
             line(xsl,ysl,xel,yel);
         }
   
     }
  }
  
}

void writePossibility(int input) {
  textSize(diaFont+3);
  fill(0);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  text("Movement "+input+" of the 4096 possibilities:",width/2,height/4);
  //passing four float arguments to the text() seems to create text
  //wrapping
  text(paraphrases[input], width/2,height-(height/7),width,height/4);
}

//Text functions

//Perhaps use text
//wrapping by passing
//four float arguments
//to the text() of a single
//long string.

//like and should be like
void lsbl(float centX, float centY) {
  //Top left
  textSize(quadFont);
  textAlign(CENTER,CENTER);
  text("Like",centX,centY-15);
    text("and",centX,centY-5);
      text("should be",centX,centY+5);
        text("like",centX,centY+15);
}

//unlike and should be like
void unsbl(float centX, float centY) {
  //Top right
  textSize(quadFont);
  textAlign(CENTER,CENTER);
  text("Unlike",centX,centY-15);
    text("but",centX,centY-5);
      text("should be",centX,centY+5);
        text("like",centX,centY+15);
}

//like and shouldn't be like
void lsnbl(float centX, float centY) {
  //Bottom left
  textSize(quadFont);
  textAlign(CENTER,CENTER);
  text("Like",centX,centY-15);
   text("but",centX,centY-5);
     text("shouldn't be",centX,centY+5);
       text("like",centX,centY+15);
}

//unlike and shouldn't be like
void unsnbl(float centX, float centY) {
  //Bottom right
  textSize(quadFont);
  textAlign(CENTER,CENTER);
  text("Unlike",centX,centY-15);
   text("and",centX,centY-5);
     text("shouldn't be",centX,centY+5);
       text("like",centX,centY+15);
}