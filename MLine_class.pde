class MLine {

 PVector start = new PVector();
 PVector term = new PVector();
 PVector displayVector = new PVector();
 boolean dispBool,shrinkBool,rotBool;
 int counter,counterB;
 
 PFont identifier;
 int address;
 Boolean end;
 
  MLine(float xs, float ys, float xt, float yt, int arrayPos) {

    start.x = xs;
    start.y = ys;
    
    term.x = xt;
    term.y = yt;

    displayVector = PVector.sub(start,term);

    counter = 0;
    counterB = 0;
     
    dispBool = true;
    shrinkBool = true;
    rotBool = true;
  
    identifier = createFont("SansSerif",12);
    address = arrayPos;
    end = true;
    
    stroke(0);
 }
   
  void display(Boolean lab) {
    line(start.x, start.y, term.x, term.y);
    
    if (lab) {
      textAlign(LEFT,BOTTOM);
      fill(0,0,200,200);
      if (end) {
      text(" "+address,term.x,term.y);
      } else {
      text(" "+address,start.x,start.y);
      }
  }
    
  }
  
  void shrink(float rate, float finMag) {
 
    PVector diff = PVector.sub(term,start);
    
    if (rate/abs(rate) == 1) {
      if(diff.mag() > finMag) {
    
        diff.setMag(diff.mag()-rate);
        term = PVector.add(start,diff);
        shrinkBool = true;
      } else {
        shrinkBool = false; 
      }
    } else {
      if(diff.mag() < finMag) {
    
        diff.setMag(diff.mag()-rate);
        term = PVector.add(start,diff);
        shrinkBool = true;
      } else {
        shrinkBool = false; 
      }
      
    }
  }

  void makeRotate(float rate, float stop) {
    float temp = counter*rate;
    
    if(rate/abs(rate) == 1) {
    
          if(temp < stop) {
              PVector dir = PVector.sub(term,start);
              rot(dir,rate);
              term = PVector.add(dir,start);
              counter++;
          } else {
            rotBool = false;
            counter = 0;
          }
          
    } else {
     
           if(temp > stop) {
              PVector dir = PVector.sub(term,start);
              rot(dir,rate);
              term = PVector.add(dir,start);
              counter++;
           } else {
             rotBool = false;
             counter = 0;
           }
    
    }
  }
  
  void displace(float xDisp, float yDisp, float xRate, float yRate) {
    
    boolean setA = false;
    boolean setB = false;
    
    if((xRate != 0) && (counterB*abs(xRate) < abs(xDisp))) {
    start.x += xRate;
    term.x += xRate;
    } else {
     setA = true;
    }
    
    if((yRate != 0) && (counterB*abs(yRate) < abs(yDisp))) {
     start.y += yRate;
     term.y += yRate;
    } else {
     setB = true;
    }
    
    if((setA == true) && (setB == true)) {
      dispBool = false;
      counterB = 0;
    } else {
     counterB++; 
    }
    
  }

//Nb that these direction(), signTest(), and rot() 
//functions were written sometime after Diamond_vectors_3

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

void rot(PVector vt, float angle) {
    
  float tempStore = vt.mag();
  
    vt.normalize();
    
    //2D rotation matrix:
    
    vt.x = vt.x*cos(angle) - vt.y*sin(angle);
    vt.y = vt.y*cos(angle) + vt.x*sin(angle);
   
    vt.setMag(tempStore);
    
}

//this function straightens lines that aren't quite perfectly
//vertical or horizontal after rotation

void snap() {
  displayVector = PVector.sub(term,start);
  float theta = direction(displayVector);
  float snapAng = 0;

  if (!((theta == 0) || (theta == PI/2) || (theta == PI) || (theta == 3*PI/2) || (theta == TWO_PI))) {
   
     if ((theta-0) < 0.02) {
       term.y = start.y;
     } else if (abs(theta-PI/2) < 0.02) {
       term.x = start.x;
     } else if (abs(theta-PI) < 0.02) {
       term.y = start.y;
     } else if (abs(theta-3*PI/2) < 0.02) {
       term.x = start.x;
     } else {
       
       if ((abs(theta-TWO_PI) > 0) && (abs(theta-TWO_PI) < 0.02)) {
         term.y = start.y;
       }
       
     }
    
  }

}
  
}
