import controlP5.*; // version 2.2.6
ControlP5 cp5;

void cp5GUI(){
  cp5 = new ControlP5(this);
  img = loadImage("PULAB.png");
  img2 = loadImage("NTHU.png");
  //aircom = loadShape("compressor.svg");
  power = loadShape("car_battery.svg");
  air = loadShape("air.svg");
  pump = loadShape("get_sample.svg");
  cooling = loadShape("cooling_fan.svg");
  PFont t = createFont("Titillium-Bold.otf", 30);
  cp5.setColorForeground(0xffaa0000);
  cp5.setColorBackground(0xff660000);
  cp5.setFont(t);
  cp5.setColorActive(0xff6b9e3c);
  Label.setUpperCaseDefault (false);
  textAlign(CENTER, CENTER);
  
  cp5.addIcon("high",10)
   .setPosition(1130,548)
   .setSize(70,70)
   .setRoundedCorners(10)
   .setFont(createFont("fontawesome-webfont.ttf", 30))
   .setFontIcons(#00f205, #00f204)
   .setSwitch(true)
   .setColorBackground(color(255, 100))
   .hideBackground();
  
  cp5.addIcon("medium",10)
   .setPosition(1130,598)
   .setSize(70,70)
   .setRoundedCorners(10)
   .setFont(createFont("fontawesome-webfont.ttf", 30))
   .setFontIcons(#00f205, #00f204)
   .setSwitch(true)
   .setColorBackground(color(255, 100))
   .hideBackground();
   
  cp5.addIcon("low",10)
   .setPosition(1130,648)
   .setSize(70,70)
   .setRoundedCorners(10)
   .setFont(createFont("fontawesome-webfont.ttf", 30))
   .setFontIcons(#00f205, #00f204)
   .setSwitch(true)
   .setColorBackground(color(255, 100))
   .hideBackground();
  
  
  cp5.addIcon("power",10)
   .setPosition(120,410)
   .setSize(70,70)
   .setRoundedCorners(10)
   .setFont(createFont("fontawesome-webfont.ttf", 80))
   .setFontIcons(#00f205, #00f204)
   .setSwitch(true)
   .setColorBackground(color(255, 100))
   .hideBackground();
   
   cp5.addIcon("pump",10)
   .setPosition(440,410)
   .setSize(70,70)
   .setRoundedCorners(10)
   .setFont(createFont("fontawesome-webfont.ttf", 80))
   .setFontIcons(#00f205, #00f204)
   .setSwitch(true)
   .setColorBackground(color(255, 100))
   .hideBackground();
   
   cp5.addIcon("air",10)
   .setPosition(760,410)
   .setSize(70,70)
   .setRoundedCorners(10)
   .setFont(createFont("fontawesome-webfont.ttf", 80))
   .setFontIcons(#00f205, #00f204)
   .setSwitch(true)
   .setColorBackground(color(255, 100))
   .hideBackground();
   
   cp5.addIcon("cooling",10)
   .setPosition(1080,410)
   .setSize(70,70)
   .setRoundedCorners(10)
   .setFont(createFont("fontawesome-webfont.ttf", 80))
   .setFontIcons(#00f205, #00f204)
   .setSwitch(true)
   .setColorBackground(color(255,100))
   .hideBackground();
  
  
   cp5.addButton("Start Acquisition")
   .setPosition(5,570)
   .setSize(150,40);
   
   cp5.getController("Start Acquisition")
   .getCaptionLabel()
   .setSize(15);
   
   cp5.addButton("Emergency Stop")
   .setPosition(160,630)
   .setSize(150,40);
   
   cp5.getController("Emergency Stop")
   .getCaptionLabel()
   .setSize(15);
   
   cp5.addButton("Close Interface")
   .setPosition(160,570)
   .setSize(150,40);
   
   cp5.getController("Close Interface")
   .getCaptionLabel()
   .setSize(15);
   
   cp5.addButton("Automode Start")
   .setPosition(5,630)
   .setSize(150,40);
   
   cp5.getController("Automode Start")
   .getCaptionLabel()
   .setSize(15);
   
   cp5.addButton("Automode Stop")
   .setPosition(5,690)
   .setSize(150,40);
   
   cp5.getController("Automode Stop")
   .getCaptionLabel()
   .setSize(15);
  
   cp5.addButton("RIP Check")
   .setPosition(160,690)
   .setSize(150,40);
   
   cp5.getController("RIP Check")
   .getCaptionLabel()
   .setSize(15);
   
   TA2 = cp5.addTextarea("123")
           .setPosition(700,650)
           .setSize(133,100)
           .setFont(createFont("arial", 30))
           .setColor(color(255))
           .setColorBackground(color(100))
           .setColorForeground(color(150,150,150))
           ;
   TA3 = cp5.addTextarea("456")
           .setPosition(985,705)
           .setSize(220,40)
           .setFont(createFont("arial", 20))
           .setColor(color(255))
           .setColorBackground(color(100))
           .setColorForeground(color(150,150,150))
           ;     
  
   
   TA = cp5.addTextarea("txt")
           .setPosition(320,560)
           .setSize(640,80)
           .setFont(createFont("arial", 11))
           .setLineHeight(12)
           .setColor(color(255))
           .setColorBackground(color(100))
           .setColorForeground(color(100))
           ;               
}

void controlEvent(ControlEvent theEvent) {
 if(theEvent.isController()) { 
 print("control event from : "+theEvent.getController().getName());
 println(", value : "+theEvent.getController().getValue());

 if(theEvent.getController().getName()=="Start Acquisition") { // set for the “start acquisition” button
  if(state1 == 1 && state2 == 1 && state3 == 1 && state4 == 0 && state5 ==0 && state6 == 0 || state1 == 1 && state2 == 1 && state3 == 0 && state4 == 1 && state5 ==0 && state6 == 0 || state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 ==1 && state6 == 0 || state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 ==0 && state6 == 1){ 
  pystart = true;

 }
  else if(state3 == 0 || state4 == 0 || state5 ==0 || state6 == 0){
    addtext("Please select the resolution mode\n");
  }
  else{
    addtext("Error, Please Ensure That All Components Are Turned On, Or Restart The Program\n");
  }
 }
  if(theEvent.getController().getName()=="Emergency Stop") { // set for the “emergency stop” button
  port.write('a');
  fill(0xfff0ff00);
  textSize(160);
  text("Shutting Down...", 640, 430);
  addtext("A Fatal Error Has Occured, Shutting Down System To Prevent Damage...\n");
  addtext("\n");
  String [] textlist = split(text, "\n");
  String filename = y+"-"+m+"-"+d+"  "+h+ms+".txt";
  saveStrings(filename, textlist);
  exit();
 }
  if(theEvent.getController().getName()=="Close Interface") { // set for the “close interface” button
  if(state1 == 1 || state2 == 1 /*|| state3 == 1 || state4 == 1*/){
    addtext("Error Due To Active Components, Please Check If All Components Are Switched Off\n");
  }
  else{
   addtext("Saving Event Log, Shutting Down...\n");
   addtext("\n");
   String [] textlist = split(text, "\n");
   String filename = y+"-"+m+"-"+d+"  "+h+ms+".txt";
   saveStrings(filename, textlist);
   exit();
  }
 }
 if(theEvent.getController().getName()=="Automode Start") { // set for the “automode start” button
  if(state1 == 1 && state2 == 1 && state3 == 1 && state4 == 0 && state5 == 0 || state1 == 1 && state2 == 1 && state3 == 0 && state4 == 1 && state5 == 0 || state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 == 1){ 
  autostate = 1;
  autoloop = true;
  addtext("Automode Start\n");
 }
  else if(state3 == 0 || state4 == 0 || state5 == 0){
    addtext("Please select the resolution mode\n");
  }
  else{
    addtext("Error, Please Ensure That All Components Are Turned On, Or Restart The Program\n");
  }
 } 
 
 if(theEvent.getController().getName()=="Automode Stop") { // set for the “automode stop” button
  autostate = 0;
  pystate = 0;
  autoloop = false;
  addtext("Automode Stop\n");
  }
  if(theEvent.getController().getName()=="RIP Check") { // set for the “RIP check” button
  if(state1 == 1 && state2 == 1 && state3 == 0 && state4 == 0 && state5 == 0 ){
  pystart = true;
  //pyrun();
  }
 }
}
}
void GUIdraw(){
  PFont p = createFont("Titillium-Bold.otf", 30);
  PFont f = createFont("Titillium-Bold.otf", 23);
  PFont t = createFont("Titillium-Bold.otf", 15);
  textSize(20);
  textFont(p);
  noStroke();
  fill(190);
  rect(0, 0, 320, 900);
  fill(0xffaa0000);
  text("System Power", 160, 215);
  fill(200);
  rect(320, 0, 320, 900);
  fill(0xffaa0000);
  text("Get Sample", 480, 215);
  fill(190);
  rect(640, 0, 320, 900);
  fill(0xffaa0000);
  text("Cleaning Fan", 800, 215);
  fill(200);
  rect(960, 0, 320, 900);
  fill(0xffaa0000);
  text("Cooling Fan", 1120, 215);
  shape(power, 100, 250, 120, 120);
  shape(pump, 420, 250, 120, 120);
  shape(air, 740, 250, 140, 140);
  shape(cooling, 1060, 250, 160, 130);
  image(img, 0, 0, 140, 140);
  image(img2, 150, 20, 130, 130);
  /*fill(0xff970a94);
  text("Graphical User Interface Version 2.0", 650, 120);*/
  fill(0xffaa0000);
  text("Resolution Mode", 1100, 530);
  textFont(f);
  fill(0xffaa0000);
  text("High", 380, 130);
  text("Medium", 650, 130);
  text("Low", 920, 130);
  textFont(t);
  fill(0xffaa0000);
  text("High Resolution", 1050, 580);
  text("Medium Resolution", 1050, 630);
  text("Low Resolution", 1050, 680);
  //text("Scan Mode", 1050, 730);
  textFont(p);
  fill(0xff0040ff);
  text("National Tsing Hua University, Department of Chemistry", 700, 70);
  fill(0xff0040ff);
  text("Event Log", 390, 530);
  text("Humidity of Drift Gas:",500,670);
  text("Temperature of Drift Gas:",500,730);
  text("Lifetime:",910,720);
  textSize(26);
  fill(0xff0040ff);
  text("Status", 800, 530);
  //text("Status", 1160, 575);
}
