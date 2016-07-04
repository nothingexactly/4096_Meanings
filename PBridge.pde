class PBridge {
PVector[] bridgePoints;
  
 PBridge(PVector start, PVector left, PVector right, PVector end) {
   bridgePoints = new PVector[4];
   bridgePoints[0] = start;
   bridgePoints[1] = left;
   bridgePoints[2] = right;
   bridgePoints[3] = end;
 }
  
 void display() {
   noFill();
   
   beginShape();
    for (int i = 0 ; i < bridgePoints.length ; i++) {
    vertex(bridgePoints[i].x,bridgePoints[i].y);
    }
   endShape();
   
   
   /*
   beginShape();
      for (int i = 0 ; i < bridgePoints.length ; i++) {
         if ((i == 0) || (i == 3)) {
         curveVertex(bridgePoints[i].x,bridgePoints[i].y);
         }
         curveVertex(bridgePoints[i].x,bridgePoints[i].y);
      }
   endShape();
   */
 }
  
}
