import processing.serial.*; // version 9
import deadpixel.command.Command; // version 4.3.8
int state1 = 0;
int state2 = 0;
int state3 = 0;
int state4 = 0;
int state5 = 0;
int state6 = 0;
int state7 = 0;
boolean pystart = false;
int pystate = 0;
Textarea TA;
Textarea TA2;
Textarea TA3;
String text,text2;
Command cmd;
Command cmd1;
Command cmd2;
Command cmd3;
String clock;
String d;
String m;
int y;
String s;
String h;
String ms;
Serial port;
Serial port1;

static final String APP  = "python ";
static final String FILE = "jkl.py"; // low resolution mode
static final String FILE1 = "jkl1.py"; // medium resolution mode
static final String FILE2 = "jkl2.py"; // high resolution mode
static final String FILE3 = "jkl3.py"; // humidity diagnosis

PShape power, pump, air, cooling,high,medium,low,scan;

PImage img, img2;

void setup() {
  final String path = dataPath(FILE);
  final String path1 = dataPath(FILE1);
  final String path2 = dataPath(FILE2);
  final String path3 = dataPath(FILE3);
  cmd = new Command(APP + path);
  cmd1 = new Command(APP + path1);
  cmd2 = new Command(APP + path2);
  cmd3 = new Command(APP + path3);
  println(cmd.command,cmd1.command,cmd2.command);
  size(1280,800);
  noStroke();
  smooth();
  port = new Serial(this, "/dev/ttyACM0", 9600); // set the port for system control
  port1 = new Serial(this, "/dev/ttyACM2", 115200); // set the port for humidity and temperature of drift gas
  port1.clear();
  port.clear();
  cp5GUI();
  //Window2();
}

  
void draw(){
background(255);
frameRate(10);
thread("hum");
GUIdraw();
status();
pushbutton();
thread("pyrun");
}

void watch() {
  d = nf(day(),2);
  m = nf(month(),2);
  y = year();
  s = nf(second(),2);
  h = nf(hour(),2);
  ms = nf(minute(),2);
  clock = "[" + y+"/"+m+"/"+d+" "+h+":"+ms+":"+s +"]"+ "      ";
}

void addtext(String Addtext){
  watch();
  text = TA.getText();
  TA.setText(text + clock + Addtext);
}


void pushbutton() { // set the command for the button on pen-probe
  if(port.available()>0){
    String[] start = match(port.readString(), "9"); 
    if(start !=null){
    if(state1 == 1 && state2 == 1 && state3 == 1 && state4 == 0 && state5 ==0 && state6 == 0 || state1 == 1 && state2 == 1 && state3 == 0 && state4 == 1 && state5 ==0 && state6 == 0 || state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 ==1 && state6 == 0 || state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 ==0 && state6 == 1){ //&& state3 == 1 && state4 == 1){
  pystart = true;
  addtext("Start Analysis\n");
 }
  else{
    addtext("Error, Please Ensure That All Components Are Turned On And The Resolution Mode Has Been Selected, Or Restart The Program\n");
  }
    }
  }
}   

void power(boolean theValue) { // set for the HV power supply
  if(theValue == true) {
    state1 = 1;
    port.write('1'); // open the high voltage power supply
    addtext("Switching On Drift Tube & Ion Source\n");
    addtext("High Voltage Operation, Do Not Touch The Components\n");
  }
  else {
    state1 = 0;
    port.write('2'); // close the high voltage power supply
    addtext("Switching Off Drift Tube & Ion Source\n");    
 }
}
void pump(boolean theValue) { // set for the micropump
  if(theValue == true) {
    state2 = 1;
    port.write('3'); // open the micropump
    addtext("Turning On Sampling Pump\n");
    addtext("Please Move Sample Inlet Near The Sample Source\n");
  }
  else {
    state2 = 0;
    port.write('4'); // close the micropump
    addtext("Turning Off Sample Pump\n");
    addtext("Flush The Tubing To Remove Contaminants\n");    
 }
}
void air(boolean theValue) { // set for the cleaning fan
  if(theValue == true) {
    port.write('5'); // open the cleaning fan
    addtext("Turning On Cleaning Fan\n");
    addtext("Ventilating Ion Source Region\n");
  }
  else {
    //state3 = 0;
    port.write('6'); // close the cleaning fan
    addtext("Turning Off Cleaning Fan\n");
    //addtext("If Something Is Wrong, Check The Battery\n");
 }
}
void cooling(boolean theValue) { // set for the cooling fan
  if(theValue == true) {
    //state4 = 1;
    port.write('7'); // open the cooling fan
    addtext("Turning On Cooling Fan\n");
     addtext("Ventilating Drift Tube Region\n");
  }
  else {
    //state4 = 0;
    port.write('8'); // close the cooling fan
    addtext("Turning Off CoolinG Fan\n");
    //addtext("Flush The Tubing To Remove Contaminants\n");
 }
}
void high(boolean theValue) {
  if(theValue == true) {
    state3 = 1; // set high resolution mode
    addtext("High resolution mode\n");
  }
  else {
    state3 = 0;
    port1 = new Serial(this, "/dev/ttyACM0", 115200);
    addtext("Please select the resolution mode\n");
}
}
void medium(boolean theValue) {
  if(theValue == true) {
    state4 = 1; // set medium resolution mode
    addtext("Medium resolution mode\n");
  }
  else {
    state4 = 0;
    port1 = new Serial(this, "/dev/ttyACM0", 115200);
    addtext("Please select the resolution mode\n");
    //addtext("If Something Is Wrong, Check The Battery\n");
 }
}
void low(boolean theValue) {
  if(theValue == true) {
    state5 = 1; // set low resolution mode
    addtext("Low resolution mode\n");
  }
  else {
    state5 = 0;
    port1 = new Serial(this, "/dev/ttyACM0", 115200);
    addtext("Please select the resolution mode\n");
 }
}

void status(){ // set the status for each mode
  if (state1 == 1 && state2 == 1 && state3 == 1 && state4 == 0 && state5 == 0 && pystate == 1 && state6 == 0){ // high resolution running script
  fill(0xff6b9e3c);//green
  rect(375,150,15,15);
  fill(0xffaa0000);//red
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(640,150,15,15);
  rect(915,150,15,15);
}
  else if (state1 == 1 && state2 == 1 && state3 == 1 && state4 == 0 && state5 == 0 && pystate == 2 && state6 == 0){ // high resolution running script in automode
  fill(0xff6b9e3c);//green
  rect(375,150,15,15);
  fill(0,0,255);//blue
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(640,150,15,15);
  rect(915,150,15,15);
}
  else if (state1 == 1 && state2 == 1 && state3 == 1 && state4 == 0 && state5 == 0 && pystate == 0 && state6 == 0){ // high resolution system ready
  fill(0xff6b9e3c);//green
  rect(375,150,15,15);
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(640,150,15,15);
  rect(915,150,15,15);
} 
  else if (state1 == 1 && state2 == 1 && state3 == 0 && state4 == 1 && state5 == 0 && pystate == 1 && state6 == 0){ // medium resolution running script
  fill(0xff6b9e3c);//green
  rect(640,150,15,15);
  fill(0xffaa0000);//red
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(375,150,15,15);
  rect(915,150,15,15);
}
  else if (state1 == 1 && state2 == 1 && state3 == 0 && state4 == 1 && state5 == 0 && pystate == 2 && state6 == 0){ // medium resolution running script in automode
  fill(0xff6b9e3c);//green
  rect(640,150,15,15);
  fill(0,0,255);//blue
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(375,150,15,15);
  rect(915,150,15,15);
}
  else if (state1 == 1 && state2 == 1 && state3 == 0 && state4 == 1 && state5 == 0 && pystate == 0 && state6 == 0){ // medium resolution system ready
  fill(0xff6b9e3c);//green
  rect(640,150,15,15);
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(375,150,15,15);
  rect(915,150,15,15);
} 
  else if (state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 == 1 && pystate == 1 && state6 == 0){ // low resolution running script
  fill(0xff6b9e3c);//green
  rect(915,150,15,15);
  fill(0xffaa0000);//red
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(640,150,15,15);
  rect(375,150,15,15);
}
  else if (state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 == 1 && pystate == 2 && state6 == 0){ // low resolution running script in automode
  fill(0xff6b9e3c);//green
  rect(915,150,15,15);
  fill(0,0,255);//blue
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(640,150,15,15);
  rect(375,150,15,15);
}
  else if (state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 == 1 && pystate == 0 && state6 == 0){ // low resolution system ready
  fill(0xff6b9e3c);//green
  rect(915,150,15,15);
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(640,150,15,15);
  rect(375,150,15,15);
} 
  else if (state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 == 0 && pystate == 1 && state6 == 1){ // low resolution running script
 // fill(0xff6b9e3c);//green
  rect(915,150,15,15);
  fill(0xffaa0000);//red
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(915,150,15,15);
  rect(640,150,15,15);
  rect(375,150,15,15);
}
  else if (state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 == 0 && pystate == 3){ // set for RIP check
  fill(0xff6b9e3c);//green
  rect(915,150,15,15);
  fill(0,0,255);//blue
  rect(850,516,30,30);
  fill(255,255,0);//yellow
  rect(640,150,15,15);
  rect(375,150,15,15);
}

  else { // system not ready all yellow
  fill(255,255,0);
  rect(375,150,15,15);
  rect(850,516,30,30);
  rect(640,150,15,15);
  rect(915,150,15,15);
}
}

import g4p_controls.*;
GWindow ManualWindow;
GButton button2; 
boolean windowstate = false;
boolean imagestate = false ;
PImage pyimg;
int autostate = 0;
boolean autoloop = false;

void hum(){ // real-time monitoring the age of filter and display the humidity and temperature of drift gas
  byte[] inBuffer = new byte[7];
  if (state1 == 0 && state2 == 1 && state3 ==0 && state4 ==0 && state5 == 0){
  port1.write('3');
  inBuffer = port1.readBytes();
  port1.readBytes(inBuffer);
  String myString = new String(inBuffer);
  String [] list = split(myString,"\n");
  String [] f =split(list[0],"%");
  float a = float(f[0]);
  if( myString == null){
    println("still wait for acquiring");}
  if (a>=25){
    text2 = myString;
    TA2.setText(text2 + "°C");
  }
  else {
    fill(150,0,150);
    text2 = myString;
    TA2.setText(text2 + " °C");
  }
  float q = a*(-5.87) + 180;
  int z = round(q);
  if (q<0){
    TA3.setText("Replace The Filter");
  }
  else{
    TA3.setText(z + " Days Left");
  }
  }
  else if(state2 == 1 && state3 == 1 && state4 == 0 && state5 ==0 || state2 == 1 && state3 == 0 && state4 == 1 && state5 ==0 || state2 == 1 && state3 == 0 && state4 == 0 && state5 ==1  || state1 == 1 && state2 ==1){
    port1.stop();
}
}



public void button2_click1(GButton source, GEvent event) { //_CODE_:button2:338122:
  println("button2 - GButton >> GEvent." + event + " @ " + millis());
  ManualWindow.setVisible(false);
} //_CODE_:button2:338122:

synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:ManualWindow:238257:
appc.background(255);  
if(imagestate==true){appc.image(pyimg,0,0);} 
}

void pyrun(){
  if  (pystart == true && state1 ==1 && state2 ==1 && state3 == 0 && state4 == 0 && state5 == 0 ){ // RIP check
    pystate =3;
    pystart = false;
    fill(0xfff0ff00);
    textSize(160);
    text("RIP Check...", 640, 430);
    cmd3.run();
    pystate = 0;
    addtext(" The RIP Check Has Completed");
    String[] pyoutput = cmd2.getOutput();
    String imgname = pyoutput[0];
    println("Load image:",imgname);
    ManualWindow.setVisible(true);
    pyimg = loadImage(imgname);
    imagestate = true;
  }
  if (pystart == true && state3 == 1 && state4 == 0 && state5 == 0 && state6 == 0){ // high resolution python script
    pystate = 1;
    pystart = false;
    addtext("Data acquiring for high resolution mode. . . . . .\n");
    cmd2.run();
    println("Success:", cmd2.success);
    pystate = 0;
    addtext("Upload Complete, Please Check Your Dropbox For the Data File\n");
    String[] pyoutput = cmd2.getOutput();
    String imgname = pyoutput[0];
    println("Load image:",imgname);
    ManualWindow.setVisible(true);
    pyimg = loadImage(imgname);
    imagestate = true; 
  }
    else if (pystart == true && state3 == 0 && state4 == 1 && state5 == 0 && state6 == 0){ // medium resolution python script
    pystate = 1;
    pystart = false;
    addtext("Data acquiring for medium resolution mode. . . . . .\n");
    cmd1.run();
    println("Success:", cmd1.success);
    pystate = 0;
    addtext("Upload Complete, Please Check Your Dropbox For the Data File\n");
    String[] pyoutput = cmd1.getOutput();
    String imgname = pyoutput[0];
    println("Load image:",imgname);
    ManualWindow.setVisible(true);
    pyimg = loadImage(imgname);
    imagestate = true; 
  }
    else if (pystart == true && state3 == 0 && state4 == 0 && state5 == 1 && state6 == 0){ // low resolution python script
    pystate = 1;
    pystart = false;
    addtext("Data acquiring for low resolution mode. . . . . .\n");
    cmd.run();
    println("Success:", cmd.success);
    pystate = 0;
    addtext("Upload Complete, Please Check Your Dropbox For the Data File\n");
    String[] pyoutput = cmd.getOutput();
    String imgname = pyoutput[0];
    println("Load image:",imgname);
    ManualWindow.setVisible(true);
    pyimg = loadImage(imgname);
    imagestate = true; 
  }    
  if (state1 == 1 && state2 == 1 /*&& state3 == 1 && state4 == 1*/ && autostate == 1 && autoloop == true){ // automode
    autoloop = false;
    pystate = 2;
    addtext("Data acquiring. . . . . .\n");
    cmd.run();
    addtext("Upload Complete, Please Check Your Dropbox For the Data File\n");
    String[] pyoutput = cmd.getOutput();
    String imgname = pyoutput[0];
    println(imgname);
    ManualWindow.setVisible(true);
    pyimg = loadImage(imgname);
    imagestate = true; 
    autoloop = true;
    if (state1 == 0 || state2 == 0/*|| state3 == 0 || state4 == 0*/){
      autostate = 0;
      pystate = 0;
      autoloop = false;
    }
  }
}
