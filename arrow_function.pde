   void arrow(float x, float y, float theta, float size) {
   
     pushMatrix();
       translate(x,y);
       rotate(theta+PI/2);
       
       line(0,0,3*size/5,size);
       line(0,0,-3*size/5,size);
     
     popMatrix();
   
 }
