class MyOutline {
  int index;
  // T-shaped
  //--------Lines
  float [] o1x = {
    -1, 1, 1, 3, 3, 1, 1, -1
  };
  float [] o1y = {
    -3, -3, -1, -1, 1, 1, 3, 3
  };


  //L-shape
  //--------Lines
  float [] o2x = {
    -1, 1, 1, 3, 3, -1
  };
  float [] o2y = {
    -3, -3, 1, 1, 3, 3
  };


  //z-shape
  //--------Lines
  float [] o3x = {
    -3, -3, 1, 1, 3, 3, -1, -1, -3
  };
  float [] o3y = {
    -1, -3, -3, -1, -1, 1, 1, -1, -1
  };


  //Stick
  //--------Lines
  float [] o4x = {
    -1, 7, 7, -1
  };
  float [] o4y = {
    -1, -1, 1, 1
  };


  //Box
  //--------Lines
  float [] o5x = {
    -1, 3, 3, -1
  };
  float [] o5y = {
    -1, -1, 3, 3
  };
  //--------Blocks
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
  //  float [] xa;
  //  float [] ya;
  //  float xanim, yanim;

  MyOutline(int type) {
    switch(type) {
    case 1:
      for (int i=0; i<o1x.length; i++) {
        px = append(px, o1x[i]);
        py = append(py, o1y[i]);
      }
      px = append(px, o1x[0]);
      py = append(py, o1y[0]);
      bodyColor = color(#999999);
      break; 
    case 2:
      for (int i=0; i<o2x.length; i++) {
        px = append(px, o2x[i]);
        py = append(py, o2y[i]);
      }
      px = append(px, o2x[0]);
      py = append(py, o2y[0]);
      bodyColor = color(#CC6666);
      break;
    case 3:
      for (int i=0; i<o3x.length; i++) {
        px = append(px, o3x[i]);
        py = append(py, o3y[i]);
      }
      px = append(px, o3x[0]);
      py = append(py, o3y[0]);
      bodyColor = color(#6699FF);
      break;
    case 4:
      for (int i=0; i<o4x.length; i++) {
        px = append(px, o4x[i]);
        py = append(py, o4y[i]);
      }
      px = append(px, o4x[0]);
      py = append(py, o4y[0]);
      bodyColor = color(#339966);
      break;
    case 5:
      for (int i=0; i<o5x.length; i++) {
        px = append(px, o5x[i]);
        py = append(py, o5y[i]);
      }
      px = append(px, o5x[0]);
      py = append(py, o5y[0]);
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
  void plot_svg() { 
    
    svg_file.println(red(bodyColor) +" " + green(bodyColor) + " " + blue(bodyColor));
    svg_file.println(px.length-1);
    for (int i=0; i<px.length-1; i++) {
      svg_file.println((px[i]-709 )+ " " + (py[i]-438));
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
    strokeWeight(3);
    if (selected)
      stroke(255, 0, 0);
    else
      stroke(lineColor);
    beginShape();
    for (int i=0; i<px.length-1; i++) {
      vertex(px[i], py[i]);
      //text(index+" " +i,px[i],py[i]);
      //text(index+"",px[i],py[i]);
      //println(red(bodyColor)+ " " + (px[i]-709 )+ " " + (py[i]-438));
    }
    endShape(CLOSE);
    strokeWeight(1); 
    //ellipseMode(CENTER);
    // ellipse(xc,yc,3,3);

    //for(int i=0; i<px.length; i++){
    //  fill(0);
    //   text(index+" " +i,px[i],py[i]);
    // }
  }

  int isInside(int x, int y) {  
    java.awt.Polygon p = new java.awt.Polygon();
    for (int i=0; i<px.length-1; i++)
      p.addPoint((int)px[i], (int)py[i]);
    p.addPoint((int)px[0], (int)py[0]);    
    if (p.contains(x, y)) 
      return index;     
    return -1;
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
