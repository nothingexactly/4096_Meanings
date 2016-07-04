class MMatrix {
 Boolean turned;
 Boolean reduced;
 Boolean shifted;
 PVector loc;
 PVector[] matPoints;
 float side;
 float incremented; //logs the angle of the
                    //section of the 2*2 matrix
                    //that is rotated

MLine[] k;//for the 2*2 matrix
 
  //trisector needs to access this
 PVector divides;
  
 MMatrix(float xl, float yl, float s) {
   reduced = false;
   turned = false;
   shifted = false;
   
   incremented = 0;
   
   loc = new PVector(xl,yl); //centre of the matrix
   side = s;
   k = new MLine[6];
   
   matPoints = new PVector[4]; //not entirely sure what is going on here
   for (int i = 0 ; i < matPoints.length ; i++) {
    float xp = sqrt(2*(side/2)*(side/2))*cos((i*TWO_PI/4)+(5*PI/4));
    float yp = sqrt(2*(side/2)*(side/2))*sin((i*TWO_PI/4)+(5*PI/4));
    matPoints[i] = new PVector(loc.x+xp,loc.y+yp);
   }
   
   populateK();
 }
 
 //shrinks the extensions
 void reduce(float rRate) { //reduce rate
   if((k[3].term.y-k[3].start.y) < -0.4) {   // would be pref to use k[0].shrinkBool but can't have a vector with mag = 0;
       for (int i = 0 ; i < k.length ; i++) {  
        k[i].shrink(rRate,0); //vector can't have a mag of zero it seems, so, shrinkBool wont work here
       }
  } else {
   reduced = true; 
  }
 }
 
 //rotates half of the matrix so
 //that it becomes a column
 
 void turn(float tRate) { //turn rate
   //safety measure, in case
   //I accidentally invoke rotation
   //before reduce method has executed
   
   if (reduced) {   
     if (incremented < PI) {
      incremented+=tRate; 
   
                 PVector pivot = new PVector(loc.x,loc.y+side);
                 PVector rMe;
               for (int i = 1 ; i < 3 ; i++) {
                 rMe = PVector.sub(matPoints[i],pivot); //all along the problem was I had the order of subtraction incorrect
                 rot(rMe,tRate);
                 PVector restored = PVector.add(rMe, pivot);
                 matPoints[i] = new PVector(restored.x,restored.y);
               }
     } else {
      turned = true; 
     }
    }
 }
 
 //to manouevre the column so that it is
 //in line with the rectangles
 void shift(float sRate, float targY) { //where the centre of the column should be
   if (turned) { //safety measure again
     if ((loc.y+side) < targY) { // the +side is a bit of a fudge. The result of loc.y no longer being the object centre
       loc.y+=sRate; //assumes the matrix is always initialized
       
       for (int i = 0 ; i < matPoints.length ; i++) {
         matPoints[i].y+=sRate;
       }
       
     } else {        //with a y less than the centre y of the rectangles
       shifted = true; 
     }       
   }
 }
 
 void display() {
  //these statements might serve
  //as a kind of snapping
  stroke(0);
  noFill();
  rectMode(CENTER);
     
 pushMatrix();
     translate(loc.x,loc.y);
      rect(-side/2,-side/2,side,side); //these are displayed
      rect(-side/2,side/2,side,side);  //almost always

  if (!reduced) {

      rect(side/2,side/2,side,side);
      rect(side/2,-side/2,side,side);
      
       for (int i = 0 ; i < k.length ; i++) {
        k[i].display(false);
       }
     
  } else if (reduced && !turned) {
  
          pushMatrix();
            translate(0,side);
            rotate(incremented);
              rect(side/2,-side/2,side,side);
              rect(side/2,-3*side/2,side,side);
          popMatrix();
          
  } else { //i.e. reduced && turned, so now shift
      rect(-side/2,3*side/2,side,side);
      rect(-side/2,5*side/2,side,side);
      divides = new PVector(loc.y,loc.y+side,loc.y+(2*side)); //for trisector to access
                                          
 }
 popMatrix();
 
 }
 
 void populateK() {
  k[0] = new MLine(-side,side,-3*side/2,side,0);
  k[1] = new MLine(-side,0,-3*side/2,0,1);
  k[2] = new MLine(-side,-side,-3*side/2,-side,2);
  
  k[3] = new MLine(-side,-side,-side,-3*side/2,3);
  k[4] = new MLine(0,-side,0,-3*side/2,4);
  k[5] = new MLine(side,-side,side,-3*side/2,5); 
 }
 
 void rot(PVector vt, float angle) {
  float tempStore = vt.mag();
         //Nb. not necessary to 
         //normalize the vector
         //prior to rotation
    
    //2D rotation matrix:
    
    vt.x = vt.x*cos(angle) - vt.y*sin(angle);
    vt.y = vt.y*cos(angle) + vt.x*sin(angle);
}

float direction(PVector source) {
  
   float angle = atan(source.y/source.x);
   float rval = 0;
   
      if (!signTest(source.y) && signTest(source.x)) {
          rval = (2*PI)+angle;
      } else if (signTest(source.y) && signTest(source.x)) {
          rval = angle;
      } else {
          rval = PI+angle;
      }

   return rval;
  
}

boolean signTest(float num) {
       if (num/abs(num) == -1) {
        return false; 
       } else {
        return true; 
       }
}
 
} //<--- end of class
