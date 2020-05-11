import processing.sound.*; //<>//
Camera camera;

SoundFile error;
SoundFile cheering;

int m_pos_x;
int m_pos_z;
int chess_pos_num;
PShape hand;
PShape[] chess_shape = new PShape[9];
PVector[] chess_pos = new PVector[9];
int[] chess_status = new int[9];
int[] chess_color = new int[9];
int click_num = 0;
int win_status = 0;
boolean finish = false;
ParticleSystem ps;

void draw_floor(){
  stroke(217,95,14);
  fill(44,162,95);
  rotateX(PI/2);
  translate(0,1,0);
  rect(-150,-150, 300, 300);
  strokeWeight(4);
  //stroke(217,95,14);
  line(-50, -150, -50, 150);
  line(50, -150, 50, 150);
  line(-150, -50, 150, -50);
  line(-150, 50, 150, 50);
  rotateX(-PI/2);
  translate(0,-1,0);
  fill(0);
}

void setup(){
  size(1000, 750, P3D);
  surface.setTitle("Tic-Tac-Toe");
  camera = new Camera();
  for (int i = 0; i< 9;i++){
    chess_shape[i] = loadShape("chess.obj");
    chess_shape[i].scale(2);
    chess_h[i] = -200.0;
    chess_status[i] = 0;
    chess_color[i] = -1;
  }
  chess_pos[0] = new PVector(100,-100);
  chess_pos[1] = new PVector(100,0);
  chess_pos[2] = new PVector(100,100);
  chess_pos[3] = new PVector(0,-100);
  chess_pos[4] = new PVector(0,0);
  chess_pos[5] = new PVector(0,100);
  chess_pos[6] = new PVector(-100,-100);
  chess_pos[7] = new PVector(-100,0);
  chess_pos[8] = new PVector(-100,100);
  
  hand = loadShape("hand.obj");
  error = new SoundFile(this, "error.mp3");
  error.amp(0.5);
  cheering = new SoundFile(this, "cheering.mp3");
  cheering.amp(0.5);
  
  ps = new ParticleSystem(new PVector(0,0,0));
  
  noStroke();   
  noFill();

}

void draw_hand(){
  translate(-m_pos_z*3+150,-200,m_pos_x*3-150);
  rotateX(PI/2);
  rotateZ(-PI/4);
  shape(hand);
  rotateZ(PI/4);
  rotateX(-PI/2);
  translate(m_pos_z*3-150,200,-m_pos_x*3+150);
}

void draw_chess(int num){
  translate(chess_pos[num].x,chess_h[num],chess_pos[num].y);
  rotateX(PI/2);
  if (chess_color[num] == 0){
    chess_shape[num].setFill(color(255));
  }else if (chess_color[num] == 1){
    chess_shape[num].setFill(color(0,0,255));
  }
  shape(chess_shape[num]);
  rotateX(-PI/2);
  translate(-chess_pos[num].x,-chess_h[num],-chess_pos[num].y);
}

void show_text(int status){
  textSize(64);
  rotateY(-PI/2);
  if (status == 3){
    fill(254, 178, 76);
    text("Draw Game!", -150, -100, 0);
  }else if (status == 1){
    fill(255);
    text("White Win!", -150, -100, 0);
  }else if (status == 2){
    fill(0, 102, 153);
    text("Blue Win!", -150, -100, 0);
  }
  rotateY(PI/2);
}

boolean time_counter = false;
float[] chess_h = new float[9];

void drop_chess(){
  if(time_counter){
    if (chess_status[chess_pos_num] == 0){
      chess_h[chess_pos_num] = chess_h[chess_pos_num] + 5.0;
      draw_chess(chess_pos_num);
    }else{
      click_num = click_num - 1;
      time_counter = false;
      error.play();
    }
  }
  if(chess_h[chess_pos_num]>-20 & chess_h[chess_pos_num]<-5){
    for(int i = 0; i< 20; i++){
      ps.addParticle();
    }
  }
  if(chess_h[chess_pos_num]>-5){
    time_counter = false;
    chess_status[chess_pos_num] = chess_color[chess_pos_num]+1;
    check_finish();
  }
}

void check_finish(){
  int row_1 = chess_status[0]*chess_status[1]*chess_status[2];
  int row_2 = chess_status[3]*chess_status[4]*chess_status[5];
  int row_3 = chess_status[6]*chess_status[7]*chess_status[8];
  int col_1 = chess_status[0]*chess_status[3]*chess_status[6];
  int col_2 = chess_status[1]*chess_status[4]*chess_status[7];
  int col_3 = chess_status[2]*chess_status[5]*chess_status[8];
  int dig_1 = chess_status[0]*chess_status[4]*chess_status[8];
  int dig_2 = chess_status[2]*chess_status[4]*chess_status[6];
  if (row_1 == 1 | row_2 ==1 | row_3 ==1 | col_1 ==1 | col_2 ==1 | col_3 ==1 | dig_1 ==1 | dig_2 ==1){
    win_status = 1;
    if (!finish){
      cheering.play();
    }
    finish = true;
  }
  if (row_1 == 8 | row_2 ==8 | row_3 ==8 | col_1 ==8 | col_2 ==8 | col_3 ==8 | dig_1 ==8 | dig_2 ==8){
    win_status = 2;
    if (!finish){
      cheering.play();
    }
    finish = true;
  }
  if (chess_status[0] != 0 & chess_status[1] != 0 & chess_status[2] != 0 & chess_status[3] != 0 & chess_status[4] != 0 & chess_status[5] != 0 & chess_status[6] != 0 & chess_status[7] != 0 & chess_status[8] != 0 & win_status == 0){
    win_status = 3;
    if (!finish){
      cheering.play();
    }
    finish = true;
  }
  
}


void update_partical_origin(int num){
  ps.origin = new PVector(chess_pos[num].x,0,chess_pos[num].y);
}

void draw(){
  float startFrame = millis();
  background(0);
  lights();
  camera.Update(1.0/frameRate);
  draw_floor();
  m_pos_x = int(mouseX*100/width);
  m_pos_z = int(mouseY*100/height);
  float endPhysics = millis();
  float dt = 1.0/frameRate;
  draw_hand();
  drop_chess();
  for (int i = 0; i< 9;i++){
    if (chess_status[i] != 0){
      draw_chess(i);
    }
  }
  if (finish){
    show_text(win_status);
  }
  ps.run();
  float endFrame = millis();
  String runtimeReport = "Frame: "+str(endFrame-startFrame)+"ms,"+
        " Physics: "+ str(endPhysics-endFrame)+"ms,"+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle("Tic-Tac-Toe"+ "  -  " +runtimeReport);
}

void keyPressed()
{
  camera.HandleKeyPressed();
  if (key =='r'){
    click_num = 0;
    win_status = 0;
    finish = false;
    setup();
  }
  if (key =='t'){
    print(camera.position);
  }
}

void keyReleased()
{
  camera.HandleKeyReleased();
}

void mouseClicked(MouseEvent evt) {
  click_num = click_num+1;
  time_counter = true;
  int tras_x = -m_pos_z*3+150;
  int tras_z = m_pos_x*3-150;
  if (tras_x>= 50 & tras_z<-50){
    chess_pos_num = 0;
  }else if (tras_x>= 50 & tras_z>=-50 & tras_z<50){
    chess_pos_num = 1;
  }else if (tras_x>= 50 & tras_z>=50){
    chess_pos_num = 2;
  }else if (tras_x>=-50 & tras_x<50 & tras_z<-50){
    chess_pos_num = 3;
  }else if (tras_x>=-50 & tras_x<50 & tras_z>=-50 & tras_z<50){
    chess_pos_num = 4;
  }else if (tras_x>=-50 & tras_x<50 & tras_z>=50){
    chess_pos_num = 5;
  }else if (tras_x< -50 & tras_z<-50){
    chess_pos_num = 6;
  }else if (tras_x< -50 & tras_z>=-50 & tras_z<50){
    chess_pos_num = 7;
  }else if (tras_x< -50 & tras_z>=50){
    chess_pos_num = 8;
  }
  if (chess_color[chess_pos_num] == -1){
    chess_color[chess_pos_num] = (click_num+1) % 2;
  }
  update_partical_origin(chess_pos_num);
  ps.colortype = chess_color[chess_pos_num];
}


class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  int colortype;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin,colortype));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  int p_color = color(255,247,188);

  Particle(PVector l, int colortype) {
    acceleration = new PVector(0,  0 , 0);
    velocity = new PVector(random(-5, 5), random(-2, 0), random(-5, 5));
    position = l.copy();
    lifespan = 10.0;
    if (colortype == 0){
      p_color = color(255);
    } else if (colortype == 1){
      p_color = color(0, 102, 153);
    }
  }

  void run() {
    update();
    display();
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  void display() {
    stroke(this.p_color);
    fill(this.p_color);
    translate(position.x, position.y, position.z);
    sphere(2);
    translate(-position.x, -position.y, -position.z);
    //ellipse(position.x, position.y, 8, 8);
  }

  boolean isDead() {
    if (lifespan<0) {
      return true;
    } else {
      return false;
    }
  }
}


class Camera
{
  Camera()
  {
    position      = new PVector(-400,-300,-10); // initial position
    theta         = -1.6; // rotation around Y axis. Starts with forward direction as ( 0, 0, -1 )
    phi           = -0.5; // rotation around X axis. Starts with up direction as ( 0, 1, 0 )
    moveSpeed     = 200;
    turnSpeed     = 1.57; // radians/sec
    
    // dont need to change these
    negativeMovement = new PVector( 0, 0, 0 );
    positiveMovement = new PVector( 0, 0, 0 );
    negativeTurn     = new PVector( 0, 0 ); // .x for theta, .y for phi
    positiveTurn     = new PVector( 0, 0 );
    fovy             = PI / 4;
    aspectRatio      = width / (float) height;
    nearPlane        = 0.1;
    farPlane         = 10000;
  }
  
  void Update( float dt )
  {
    theta += turnSpeed * (negativeTurn.x + positiveTurn.x) * dt;
    
    // cap the rotation about the X axis to be less than 90 degrees to avoid gimble lock
    float maxAngleInRadians = 85 * PI / 180;
    phi = min( maxAngleInRadians, max( -maxAngleInRadians, phi + turnSpeed * ( negativeTurn.y + positiveTurn.y ) * dt ) );
    
    // re-orienting the angles to match the wikipedia formulas: https://en.wikipedia.org/wiki/Spherical_coordinate_system
    // except that their theta and phi are named opposite
    float t = theta + PI / 2;
    float p = phi + PI / 2;
    PVector forwardDir = new PVector( sin( p ) * cos( t ),   cos( p ),   -sin( p ) * sin ( t ) );
    PVector upDir      = new PVector( sin( phi ) * cos( t ), cos( phi ), -sin( t ) * sin( phi ) );
    PVector rightDir   = new PVector( cos( theta ), 0, -sin( theta ) );
    PVector velocity   = new PVector( negativeMovement.x + positiveMovement.x, negativeMovement.y + positiveMovement.y, negativeMovement.z + positiveMovement.z );
    position.add( PVector.mult( forwardDir, moveSpeed * velocity.z * dt ) );
    position.add( PVector.mult( upDir,      moveSpeed * velocity.y * dt ) );
    position.add( PVector.mult( rightDir,   moveSpeed * velocity.x * dt ) );
    
    aspectRatio = width / (float) height;
    perspective( fovy, aspectRatio, nearPlane, farPlane );
    camera( position.x, position.y, position.z,
            position.x + forwardDir.x, position.y + forwardDir.y, position.z + forwardDir.z,
            upDir.x, upDir.y, upDir.z );
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyPressed()
  {
    if ( key == 'w' ) positiveMovement.z = 1;
    if ( key == 's' ) negativeMovement.z = -1;
    if ( key == 'a' ) negativeMovement.x = -1;
    if ( key == 'd' ) positiveMovement.x = 1;
    if ( key == 'q' ) positiveMovement.y = 1;
    if ( key == 'e' ) negativeMovement.y = -1;
    
    if ( keyCode == LEFT )  negativeTurn.x = 1;
    if ( keyCode == RIGHT ) positiveTurn.x = -1;
    if ( keyCode == UP )    positiveTurn.y = 1;
    if ( keyCode == DOWN )  negativeTurn.y = -1;
  }
  
  // only need to change if you want difrent keys for the controls
  void HandleKeyReleased()
  {
    if ( key == 'w' ) positiveMovement.z = 0;
    if ( key == 'q' ) positiveMovement.y = 0;
    if ( key == 'd' ) positiveMovement.x = 0;
    if ( key == 'a' ) negativeMovement.x = 0;
    if ( key == 's' ) negativeMovement.z = 0;
    if ( key == 'e' ) negativeMovement.y = 0;
    
    if ( keyCode == LEFT  ) negativeTurn.x = 0;
    if ( keyCode == RIGHT ) positiveTurn.x = 0;
    if ( keyCode == UP    ) positiveTurn.y = 0;
    if ( keyCode == DOWN  ) negativeTurn.y = 0;
  }
  
  // only necessary to change if you want different start position, orientation, or speeds
  PVector position;
  float theta;
  float phi;
  float moveSpeed;
  float turnSpeed;
  
  // probably don't need / want to change any of the below variables
  float fovy;
  float aspectRatio;
  float nearPlane;
  float farPlane;  
  PVector negativeMovement;
  PVector positiveMovement;
  PVector negativeTurn;
  PVector positiveTurn;
};
