class MyBlock {
  int index;
  // T-shaped

  float [] tsx = {
    0, 0, 0, 2
  };
  float [] tsy = {
    -2, 0, 2, 0
  };  

  //L-shape
  float [] lsx = {
    0, 0, 0, 2
  };
  float [] lsy = {
    -2, 0, 2, 2
  };

  //z-shape
  float [] zsx = {
    -2, 0, 0, 2
  };
  float [] zsy = {
    -2, -2, 0, 0
  };

  //Stick
  float [] stickx = {
    0, 2, 4, 6
  };
  float [] sticky = {
    0, 0, 0, 0
  };

  //Box
  float [] boxx = {
    0, 2, 2, 0
  };
  float [] boxy = {
    0, 0, 2, 2
  };  

  float [] px = new float[0];
  float [] py = new float[0];
  boolean selected = false;
  color lineColor = color(0);
  color bodyColor = color(255);
  float xc, yc;
  boolean visible=true;

  MyBlock(int type) {
    switch(type) {
    case 1://T-shape
      for (int i=0; i<tsx.length; i++) {
        px = append(px, tsx[i]);
        py = append(py, tsy[i]);
      }
      bodyColor = color(#999999);
      break; 
    case 2: //L-Shape
      for (int i=0; i<lsx.length; i++) {
        px = append(px, lsx[i]);
        py = append(py, lsy[i]);
      }
      bodyColor = color(#CC6666);
      break;
    case 3:  //Z-shape
      for (int i=0; i<zsx.length; i++) {
        px = append(px, zsx[i]);
        py = append(py, zsy[i]);
      }
      bodyColor = color(#6699FF);
      break;
    case 4:
      for (int i=0; i<stickx.length; i++) {
        px = append(px, stickx[i]);
        py = append(py, sticky[i]);
      }
      bodyColor = color(#339966);
      break;
    case 5:
      for (int i=0; i<boxx.length; i++) {
        px = append(px, boxx[i]);
        py = append(py, boxy[i]);
      }
      bodyColor = color(#CC9900);
      break;
    }
    xc = yc = 0;
    //    xa = new float[px.length];
    //    ya = new float[py.length];
  }
  /**
   *
   */
  void debug() {
    for (int i=0; i<px.length; i++)
      println(px[i] + " " + py[i]);
  }
  /**
   *
   */
  void move(float xd, float yd) {   
    for (int i=0; i<px.length; i++) {
      px[i] += xd;
      py[i] += yd;
    }
    xc+=xd;  
    yc+=yd;
  }
  /**
   *
   */
  void moveTo(float xloc, float yloc) {
    for (int i=0; i<px.length; i++) {
      px[i] -= xc;
      px[i] += xloc;
      py[i] -= yc;
      py[i] += yloc;
    }
    xc-=xc;  
    yc-=yc; 
    xc+=xloc;
    yc+=yloc;
  }
  /**
   *
   */
  void scale(float xs, float ys) {
    for (int i=0; i<px.length; i++) {
      px[i] *= xs;
      py[i] *= ys;
    }
  }
  
    /**
   *
   */
void mirror(float xref, float yref) {
    for (int i=0; i<px.length; i++) {
        px[i] = (px[i]-xref)*-1 + xref;
        //py[i] = (py[i]-yref)*-1 + yref;
    }
  }

  /**
   *
   */
  void setRotate (float angle, float xref, float yref) {
    float cosa, sina;
    cosa = cos(angle);
    sina = sin(angle);
    //Rotates point around z-axis
    for (int i=0; i<px.length; i++) {
      float newx =  (px[i]-xref) * cosa - (py[i]-yref) * sina + xref;
      float newy =  (py[i]-yref) * cosa + (px[i]-xref) * sina + yref;
      px[i] = newx;
      py[i] = newy;
    }
  }

  /**
   *
   */
  void select(float xpick, float ypick) {
    selected = false;
    for (int i=0; i<px.length; i++)
      if (dist(xpick, ypick, px[i], py[i]) <20) {
        selected = true;
        break;
      }
  }

  void printout() {
    println("----------------------");
    for (int i=0; i<px.length-1; i++) {
      println(px[i]+" "+py[i]);
    }
  }

  /**
   *
   */
  void plot() {
    if (colors)
      fill(bodyColor);
    else
      fill(255);
    if (selected)
      stroke(255, 0, 0);
    else
      stroke(lineColor);
    strokeWeight(3);
    for (int i=0; i<px.length; i++){
      if(isDebug)fill(bodyColor);
      rect(px[i], py[i], 20, 20);
      if(isDebug)fill(0);
      if(isDebug)text(i,px[i]-7, py[i]+4);
    }
  }

  /**
   *
   */
  void markCentroid() {
    float cx=0, cy=0;
    for (int i=0; i<px.length-1; i++) {
      cx += px[i];
      cy += py[i];
    }
    cx /= px.length-1;
    cy /= py.length-1;
  }
}
