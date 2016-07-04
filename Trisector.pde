class Trisector {
  
 float rw;
 MLine[] lines;
 float startX; //start x
 float updatedX;
 Boolean extended;
 Boolean complete;
 float magnitude; //so that the main program can determine when to
                  //display the comparison types in the grid
  
 Trisector(float rectWidth, float sx) { //startX will be m.loc.x
   rw = rectWidth;
   extended = false;
   complete = false;
   startX = sx;
   updatedX = sx;
   
   lines = new MLine[3];
   
   for (int i = 0 ; i < lines.length ; i++) {
     lines[i] = new MLine(0,-rw+(i*rw),1,-rw+(i*rw),i); //y value off by 1 pixel for centre line it seems
   }
   
   magnitude = 0;
 }
 
 void slice() {
  if (lines[0].shrinkBool && !extended) {
    stroke(0,0,255);
  
      for (int i = 0 ; i < lines.length ; i++) {
        lines[i].shrink(-1,(6*rw)+(width/2-(3*rw)-startX));
      }                                          
  } else {
    for (int i = 0 ; i < lines.length ; i++) {
        lines[i].shrinkBool = true;
      }
      
      extended = true;
  }
   
   
      if (extended && lines[0].shrinkBool) {
        stroke(0,0,255);
          for (int i = 0 ; i < lines.length ; i++) {
            lines[i].start.x++;
            lines[i].term.x++;
            lines[i].shrink(1,(6*rw));
          }
          
          if (!lines[0].shrinkBool) {
            complete = true;
          }
      }
   magnitude = lines[0].term.x-lines[0].start.x;
   updatedX = lines[0].start.x;
 }
 
 void display() {
  stroke(0,0,255);
  pushMatrix();
  translate(startX,height/2);
  for (int i = 0 ; i < lines.length ; i++) {
    lines[i].display(false);
  }
  popMatrix();
 }
 
} //end of class
