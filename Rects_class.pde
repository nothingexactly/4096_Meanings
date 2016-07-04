class Rects {
  
  boolean expBool;
  boolean dispBool;   //for the displace function
  float w;
  float h;
  float tempW;
  float rate;
  int counter;
  int counterB;       //for displace function
  PFont identifier;
  int total;
  boolean split;
  
  PVector centre;
  
  Rects(int nm, float xCent, float yCent, float wid) {
    expBool = true;
    counter = 0;
    tempW = 0;
    identifier = createFont("SansSerif",12);
    total = nm;
    
    rate = 1;
    
    if (total != 1) {
      w = 0;
      h = 0;
    } else {
      w = wid;
      h = 4*w; 
    }
    
    //if true, divide each rectangle 
    //into four stacked squares
    
    split = false;
    
   // if (total == 1) {
      centre = new PVector(xCent,yCent);
   //}

    counterB = 0;
    dispBool = true;
}
  
  //this function on for the 'sequence' object instance
  void expandRects(float rat, float wid, float hei) {
    
    rate = rat;
    w = wid;
    h = hei;
    
    if (counter*rate < w) {
     counter++;
     tempW = counter*rate;
     expBool = true;
    } else {
     tempW = w;
     expBool = false;
    }
    
  }

//displace() is only invoked when a Rects object
//displays only a single rectangle

void displace(float xDisp, float xRate) {
    
    boolean setA = false;
  
    if((xRate != 0) && (counterB*abs(xRate) < abs(xDisp))) {
    centre.x += xRate;
    } else {
     setA = true;
    }
    
    if(setA) {
      dispBool = false;
      counterB = 0;
    } else {
     counterB++; 
    }
    
}
  
  void display() {
    
    rectMode(CENTER);
     if (total != 1) { //i.e. if this is the 'sequence' instance
       pushMatrix();
       translate(centre.x,centre.y);
      for (int i = 0 ; i < total ; i++) {  //reset in the control file to 0,0. Why?
        float totW = total*w;
        float start = -((-w/2)+totW/2);
        textAlign(LEFT,CENTER);
            fill(0,0,200,200);
       // text(" "+lineRefs(i),start+(i*w),-11-h/2);
            noFill();
        stroke(0);    
        rect(start+(i*w),0,tempW,h);
        
        if (split) {
          stroke(0,0,255);
          line((i*w)+start-w/2,w,(i*w)+start+w/2,w);
          line((i*w)+start-w/2,0,(i*w)+start+w/2,0);
          line((i*w)+start-w/2,-w,(i*w)+start+w/2,-w);
        }
      }
      popMatrix();
     } else {
       
        stroke(0);    
        rect(centre.x,centre.y,w,h);
       
       if (split) {
          stroke(0,0,255);
          line(centre.x-w/2,w,centre.x+w/2,w);
          line(centre.x-w/2,0,centre.x+w/2,0);
          line(centre.x-w/2,-w,centre.x+w/2,-w);
        }
       
     }

  }

//the easy by ugly alternative to sorting 
//the line identifiers by the size of start.x

int lineRefs(int num) {
  int ref = 0;
   
  switch(num) {
    case 0: 
      ref = 3;
      break;
    case 1: 
      ref = 4;
      break;
    case 2: 
      ref = 1;
      break;
    case 3: 
      ref = 0;
      break;
    case 4: 
      ref = 5;
      break;
    case 5: 
      ref = 2;
      break;
  }
   
  
  return ref; 
 }
  
}
