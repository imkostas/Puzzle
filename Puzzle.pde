//import processing.svg.*;

PrintWriter svg_file;
float [] grid_x = new float[40];
float [] grid_y = new float[40];
boolean animation = true;
boolean colors = false;
int attempts = 0;
float [] angles = {
  0, 90, 180, 270
};
MyBlock [] blocks = new MyBlock[10];
MyOutline [] outlines = new MyOutline[10];
boolean delayFlag = false;
int startTime;
int eblock=0;
int eposition=0;
int gposition=0;
int eangle=0;
boolean emirror = false;
float nslides = 20;
boolean isDebug=false;
boolean saveImageFlag = false;
String lastFilename="";

String ffilename, pfilename;
boolean firstTime = true;
boolean saveImage = false;
boolean isEqual = true;
int fileKounter = 0;
long kp=0;

int sequence [] = new int [10];
int skount = 1096482537;  //874925136;//591742836;//312647985; //123456790;

PImage img;
PImage pimg;

int [] solutions = {951742836, 896714253, 591642837, 578462193, 1049357286, 469573182, 381625947, 375286419, 314258796};
int solutionKount= 0;

PrintWriter output;

void setup() {
  size(displayWidth, displayHeight);
  //size(1000,600);
  rectMode(CENTER);
  shapeMode(CENTER);
  //blocks
  for (int i=0; i<blocks.length; i++) {
    blocks[i] = new MyBlock(((i/2)+1));
    blocks[i].index = i;
    blocks[i].scale(10, 10);
  }
  //outlines
  for (int i=0; i<outlines.length; i++) {
    outlines[i] = new MyOutline(((i/2)+1));
    outlines[i].index = i;
    outlines[i].scale(10, 10);
  }

  //blocks
  int k = 0;
  for (int x=0; x<5; x++)
    for (int y=0; y<2; y++) {
      blocks[k].move(100+x*100, 100+y*100); 
      blocks[k].plot();
      k++;
    }
  //outlines
  k = 0;
  for (int x=0; x<5; x++)
    for (int y=0; y<2; y++) {
      outlines[k].move(100+x*100, 100+y*100); 
      outlines[k].plot();
      k++;
    }
  //GRID
  k=0;
  for (int x=0; x<5; x++)
    for (int y=0; y<8; y++) {
      grid_x[k] = width/2+x*20;
      grid_y[k] = height/2+y*20;
      k++;
    }

  output = createWriter("puzzles.txt");
}
int kslide = 0;
//*****************************************
//*****************************************
void draw() {
  background(255);

  //-------Background grid
  strokeWeight(1);
  stroke(150);
  fill(255);

 

  //** draw grid frame
  for (int g=0; g<40; g++) { 
    if (isDebug)fill(255);
    rect(grid_x[g], grid_y[g], 20, 20);
    if (isDebug)fill(0);
    if (isDebug)text(g, grid_x[g]-7, grid_y[g]+4);
  }

  //------Outlines

  for (int i=0; i<outlines.length; i++)
    if (blocks[i].visible)outlines[i].plot();

  //------Blocks
  //if (isDebug)for (int i=0; i<blocks.length; i++)
  //  if (isDebug)  if (blocks[i].visible)blocks[i].plot();

  //-----counter
  fill(0);
  if (attempts>0)text(nfc(attempts, 0), width/2, 3*height/4);



  String filename = "";
  plotSequence(sequence);
  for (int i=0; i<sequence.length; i++)
    filename+=sequence[i];
  //img  = get(709, 438, 104, 164);
  //img.save("images/"+filename+".jpg");

 //find the sequence of grid-to-block and use it as a filename
 filename="";
  for(int x=0; x<5; x++)
   for(int y=0; y<8; y++)
    for (int i=0; i<outlines.length; i++){
      int indx = outlines[i].isInside(x*20+719,y*20+448);
      if(indx!=-1)filename+=indx;
    }
    //if(!filename.equals("")){
    //  filename = (nf(fileKounter, 10))+ "_"+ filename;
    //fileKounter++;
    //}
    
  svg_file = createWriter("svg/"+filename+".txt");
  for(int x=0; x<5; x++)
   for(int y=0; y<8; y++)
    for (int i=0; i<outlines.length; i++){
      int indx = outlines[i].isInside(x*20+719,y*20+448);
      if(indx!=-1)svg_file.print(indx);
    }
   svg_file.println();
   
  for (int i=0; i<outlines.length; i++)
    if (blocks[i].visible)
      outlines[i].plot_svg();


  svg_file.flush(); // Writes the remaining data to the file
  svg_file.close(); // Finishes the file

  
}

void mousePressed() {
  xfirst = mouseX;  // remember this point
  yfirst = mouseY;

  for (int i=0; i<blocks.length; i++) {
    blocks[i].select(mouseX, mouseY);
    outlines[i].select(mouseX, mouseY);
  }

  //for (int i=0; i<blocks.length; i++)
  //  if (blocks[i].selected==true)
  //    blocks[i].printout();
}




/**
 *
 */
float xfirst, yfirst;
void mouseDragged() {

  float snapx = round(mouseX/10.)*10.;
  float snapy = round(mouseY/10.)*10.;
  //ellipse(snapx, snapy, 4,4);

  for (int i=0; i<blocks.length; i++)
    if (blocks[i].selected) {
      blocks[i].moveTo(snapx, snapy);
      outlines[i].moveTo(snapx, snapy);
    }

  xfirst = mouseX;  //remember this point
  yfirst = mouseY;
}




float angle = 1;
int mv = 1;
int kk=0;
void keyPressed() {
  switch(key) {
    //////////////////////////////////////////////
  case 'r':   //******rotate block
    for (int i=0; i<blocks.length; i++)
      if (blocks[i].selected) {
        blocks[i].setRotate(radians(angle%4*90), blocks[i].xc, blocks[i].yc);
        outlines[i].setRotate(radians(angle%4*90), blocks[i].xc, blocks[i].yc);
      }
    angle++;
    break;
    //////////////////////////////////////////////
  case 'm':  //******mirror block
    for (int i=0; i<blocks.length; i++)
      if (blocks[i].selected) {
        blocks[i].mirror(blocks[i].xc, blocks[i].yc);
        outlines[i].mirror( blocks[i].xc, blocks[i].yc);
      }
    break;
    //////////////////////////////////////////////
  case ' ':  //random attempt
    attempts++;
    for (int i=0; i<blocks.length; i++) {
      tranformBlock(i, (int)random(40), angles[(int)random(4)], false);
      blocks[i].setRotate(radians(angle%4*90), blocks[i].xc, blocks[i].yc);
      outlines[i].setRotate(radians(angle%4*90), blocks[i].xc, blocks[i].yc);
      kk++;
    }
    break;
    //////////////////////////////////////////////
  case 'z':
    attempts = 0;
    int out=0;
    int overlaps = 0;
    int start = millis();
    while (true) {
      attempts++;
      out=0;
      overlaps = 0;
      //----get a configuration
      for (int i=0; i<blocks.length; i++) {
        tranformBlock(i, (int)random(40), angles[(int)random(4)], false);
        blocks[i].setRotate(radians(angle%4*90), blocks[i].xc, blocks[i].yc);
        outlines[i].setRotate(radians(angle%4*90), blocks[i].xc, blocks[i].yc); 
        blocks[i].mirror(blocks[i].xc, blocks[i].yc);
        outlines[i].mirror(blocks[i].xc, blocks[i].yc);
        kk++;
      }
      //----check for boundaries
      for (int i=0; i<blocks.length; i++)
        for (int j=0; j<blocks[i].px.length; j++) {
          if (blocks[i].px[j] < width/2-10 ||
            blocks[i].py[j] < height/2-10 ||
            blocks[i].px[j] > width/2+90  ||
            blocks[i].py[j] > height/2+150 )
            out++;
        }
      if (out>0) continue;
      //-----check for overlaps
      boolean [] isFull = new boolean [40];
      for (int g=0; g<40; g++)
        for (int i=0; i<blocks.length; i++)
          for (int ii=0; ii<blocks[i].px.length; ii++) 
            if (grid_x[g]==blocks[i].px[ii] && grid_y[g]==blocks[i].py[ii]) 
              isFull[g] = true;
      //----count the overlaps
      for (int i=0; i<40; i++)
        if (isFull[i]==false)overlaps++;

      if (overlaps<7)break;
    }//while
    println("overlaps = " + overlaps + " " + ((millis()-start)/1000)+"\" " + attempts );
    break;
    //////////////////////////////////////////////  

    //////////////////////////////////////////////
  case '6':   // enumerate without overlap
    enumerate_and_overlap();
    break;
    //////////////////////////////////////////////
  case '7':  
    enumerate_no_overlap();
    break;
    ////////////////////////////////////////////// 
  case '8':
    solutionKount%=9;
    skount = solutions[solutionKount++];  
    findSolution();
    break;
    ////////////////////////////////////////////// 
    //////////////////////////////////////////////
  case 'h':
    println(howManyRemaining());
    break;
    //////////////////////////////////////////////
  case 'o':
    //int selected=0;
    //for ( i=0; i<blocks.length; i++)
    //  if (blocks[i].selected==true)
    //    println(overlap2(i));
    break;

    //////////////////////////////////////////////
  case 't':
    String s="";
    int pattern[] = new int[10];
    for (int i=0; i<10; i++) {
      pattern[i] = int(((kp)/pow(10, i))%10);
      s += pattern[i];
    }
    println(" " + s);
    kp++;
    break;
    //////////////////////////////////////////////
  case 'c':  //set colors on / off
    colors=colors?false:true;
    break;
    //////////////////////////////////////////////
  case BACKSPACE:
    reset();
    break;

    //////////////////////////////////////////////
  case 'e': 
  skount=314258796;
    skount=0;
    //for (int i=0; i<10; i++) {
      infinteSearch();
    break;
  }
}


void infinteSearch(){
  while(true){
      findSolution();
      draw();
    }
}

//**********************************************************
// Main function: looks for a solution; stops only if it finds one
//**********************************************************
void findSolution() {
  getNextSequence();
  knext = 0;
  eblock = sequence[knext];
  int kount=0;
  cursor(WAIT);
  while (true) {
    kount++;
    if (placeBlocks()<3  && kount>1  ) {
      saveImageFlag=true; 
      break;
    }
  }
  attempts = kount;
  println(plotSequence(sequence) + " attempts: " + kount);
  output.println(plotSequence(sequence) + " " + kount + " " + getCode());
  output.flush();
  cursor(ARROW);
}

int knext = 0;

//******************************************************
// Place blocks until you find a solution. If impossible then exit
//******************************************************
int placeBlocks() {
  //println(eblock); 
  int sv=0;
  while (true) {
    emirror=emirror?false:true;
    if (emirror)
      eangle+=90;
    if (eangle>=360) {
      eangle = 0;
      eposition++;
    }
    if (eposition>=40)eposition=0;
    tranformBlock(eblock, eposition, eangle, emirror); 
    if (!doesExceedLimits(eblock) && !overlap(eblock)) { //exit: solution found
      knext++;
      knext = knext%10;
      eblock = sequence[knext];
      break;
    }
    sv++;
    if (sv>100) { //exit: can't find solution
      reset();
      //println("reset");
      gposition++;
      eposition=gposition; 
      if (gposition>40) {
        //println("gposition = " + gposition + " " + eblock);
        knext++;
        knext = knext%10;
        eblock = sequence[knext];
        //println("now eblock is = " + eblock);
        getNextSequence();
        //plotSequence(sequence);
        gposition=0;
      }
      return howManyRemaining();
    }
  }
  return howManyRemaining();
}

//*******************************************************
boolean doesExceedLimits(int b) {

  for (int i=0; i<blocks[b].px.length; i++)
    if (blocks[b].px[i]<grid_x[0] || blocks[b].py[i]<grid_y[0] ||
      blocks[b].px[i]>grid_x[39] || blocks[b].py[i]>grid_y[39]) 
      return true;
  return false;
}


//*******************************************************
boolean overlap(int a) {
  for (int i=0; i<blocks[a].px.length; i++)
    for (int k=0; k<blocks.length; k++)
      for (int j=0; j<blocks[k].px.length; j++) {
        if (a==k)continue;
        if (blocks[k].px[j]==blocks[a].px[i] && blocks[k].py[j]==blocks[a].py[i] ) 
          return true;
      }
  return false;
}

//*******************************************************
int howManyRemaining() {
  int kount=0;
  for (int i=0; i<grid_x.length; i++)
    for (int k=0; k<blocks.length; k++)
      for (int j=0; j<blocks[k].px.length; j++)   
        if (blocks[k].px[j]==grid_x[i] && blocks[k].py[j]==grid_y[i] ) {
          //if (isDebug)println(k+ " " + j+ "    " +i+ "    " +kount + "      " + blocks[k].px[j] + " == " + grid_x[i] + "  " + blocks[k].py[j] + " == " + grid_y[i]);
          if (isDebug)text(i, grid_x[i], grid_y[i]);
          kount++;
        }
  return (40-kount);
}

//******************************************************
// Checks if a point is inside an outline
//******************************************************
int isInside(int x, int y) {
  int outlineIndex = -1;
  java.awt.Polygon p = new java.awt.Polygon();
  for (int i=0; i<outlines.length; i++) {
    for (int j=0; j<outlines[i].px.length; j++) {
      p.addPoint((int)outlines[i].px[j], (int)outlines[i].py[j]);
      //println(outlines[i].idx + " " + outlines[i].px[j]+ " "+outlines[i].py[j]);
      //text(j,(int)outlines[i].px[j], (int)outlines[i].py[j]);
    }
    p.addPoint((int)outlines[i].px[0], (int)outlines[i].py[0]);
    //text(0,(int)outlines[i].px[0], (int)outlines[i].py[0]);

    if (p.contains(x, y)) {
      outlineIndex=outlines[i].index;
      break;
    }
  }
  return outlineIndex;
}

//******************************************************
// enumerates allowing blocks to ovelapping
//******************************************************
int enumerate_and_overlap() {

  emirror=emirror?false:true;
  if (emirror)
    eangle+=90;
  if (eangle>=360) {
    eangle = 0;
    eposition++;
  }
  if (eposition>=40) {
    eposition=0;
  }
  tranformBlock(eblock, eposition, eangle, emirror); 
  if (!doesExceedLimits(eblock) && !overlap(eblock)) {
    eblock++;
    eblock = eblock%10;
  }

  return howManyRemaining();
}

//******************************************************
// enumerates without blocks ovelapping
//******************************************************
int enumerate_no_overlap() {
  //println(eblock);
  int sv=0;
  while (true) {
    emirror=emirror?false:true;
    if (emirror)
      eangle+=90;
    if (eangle>=360) {
      eangle = 0;
      eposition++;
    }
    if (eposition>=40) {
      eposition=0;
    }
    tranformBlock(eblock, eposition, eangle, emirror); 
    if (!doesExceedLimits(eblock) && !overlap(eblock)) {
      eblock++;
      eblock = eblock%10;
      break;  //blocks[eblock].visible = exceed(eblock);
    }
    sv++;
    if (sv>1000) {
      //if (isDebug)println(howManyRemaining());
      //if (isDebug)println(gposition);
      reset();
      gposition++;
      eposition=gposition;
      if (gposition>40)eblock=(int)random(10);
      return howManyRemaining();
    }
  }
  return howManyRemaining();
}


//*******************************************************
// transform a single block
// b = index of block, to = grid index, angle = rotation angle, isMirror = boolean if mirrored 
//******************************************************
void tranformBlock(int b, int to, float angle, boolean isMirror) {
  //  if(!animation) {
  blocks[b].moveTo(grid_x[to], grid_y[to]);
  outlines[b].moveTo(grid_x[to], grid_y[to]);
  blocks[b].setRotate(radians(angle), blocks[b].xc, blocks[b].yc);
  outlines[b].setRotate(radians(angle), blocks[b].xc, blocks[b].yc);
  if (isMirror) {
    blocks[b].mirror(grid_x[to], grid_y[to]);
    outlines[b].mirror(grid_x[to], grid_y[to]);
  }

  //  }
  //  else{
  //      blocks[b].xanim = abs(blocks[b].xc - grid_x[to])/nslides;
  //      blocks[b].yanim = abs(blocks[b].yc - grid_y[to])/nslides;
  //      println(blocks[b].xc + " " + grid_x[to]);
  //  }
  //  kslide = 0;
  //  animation = true;
}


//*******************************************************
// Resets all blocks back to their orinial positions
//*******************************************************
void reset() {
  attempts = 0;
  int k = 0;
  mv = 1;
  for (int i=0; i<blocks.length; i++) {
    blocks[i] = new MyBlock(((i/2)+1));
    blocks[i].scale(10, 10);
    outlines[i] = new MyOutline(((i/2)+1));
    outlines[i].index= i;
    outlines[i].scale(10, 10);
  }
  for (int x=0; x<5; x++)
    for (int y=0; y<2; y++) {
      blocks[k].setRotate(radians(0), blocks[k].xc, blocks[k].yc);
      blocks[k].moveTo(100+x*100, 100+y*100);
      outlines[k].setRotate(radians(0), blocks[k].xc, blocks[k].yc);
      outlines[k].moveTo(100+x*100, 100+y*100);
      k++;
    }

  //eblock=0;
  eposition=0;
  //gposition=0;
  eangle=0;
  emirror = false;
}

//********************************************
void getNextSequence() {  
  while (true) {
    sequence = get1Sequence(skount);
    skount++;
    if (sequence!=null)break;
  }
  //plotSequence(sequence);
}

//****************************************
int[] get1Sequence(int k) {
  int ndigits = 10;
  int modulo = 10;
  int [] sequence = new int[ndigits];

  for (int j=0; j<ndigits; j++) 
    sequence[j] = ((k/int(pow(modulo, ndigits-j-1)))%modulo);

  boolean ok=true;

  for (int ii=0; ii<sequence.length-1; ii++)
    for (int jj=ii+1; jj<sequence.length; jj++)
      if (sequence[ii]==sequence[jj])ok=false;

  if (!ok)return null;

  else return sequence;
}
//********************************
String plotSequence(int[] seq) {
  String s="";
  for (int i=0; i<seq.length; i++)
    s+=seq[i];
  return s;
}

//********************************
void printout(int[] s) {
  for (int i=0; i<s.length; i++)
    output.print(s[i]);
  output.print(" ");

  //for (int g=0; g<40; g++) { 
  //  color c = get((int)grid_x[g]+10, (int)grid_y[g]+10);
  //    println(red(c)+" " + green(c) + " " + blue(c));
  //    output.print(" " + c);
  //  }
  //output.println();

  for (int i=0; i<blocks.length; i++)
    output.print(blocks[i].index); 
  output.println();

  output.flush();
}
//***********************************
String getCode() {
  String code = "";
  for (int j=0; j<grid_x.length; j++)
    for (int i=0; i<outlines.length; i++) {
      int index = outlines[i].isInside((int)grid_x[j], (int)grid_y[j]);
      if (index >= 0)
        code+= index;
    }
  return(code);
}