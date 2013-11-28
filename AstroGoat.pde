float canvasSizeY = 600;
float canvasSizeX = 800;

int time = 0;
int previewsSize = 0;

PImage ballImg;
PImage astronautImg;
PImage goatImg;
PImage goatDyingImg;


// Settings and vars for the player
int playerSize = 120;

// Settings for the game
int pointsCounter = 0;
int numberOfLanes = 5;
float [] laneHeight;
int initialLane = 2;
int goatsInThePool = 0;
int initialGoatFreq = 150; // The higher the lower is the freq (invocation lapse)
int goatFreq = initialGoatFreq;

// settings for the environment
int redCode = 255;
int greenCode = 214;
int blueCode = 130;
int collisionSpriteOffset = 65;

// Settings for the goats
int goatSizeX = 135;
int goatSizeY = 120;
int goatPointsWorth = 1;
float GoatInitialPositionX = canvasSizeX - 100;

Player player;
float playerInitialPositionX = 100;
float playerInitialPositionY = canvasSizeY - 50;

ArrayList<Ball> balls;
ArrayList<Goat> goats;

void setup () {
  ballImg = loadImage("ball.png");
  goatImg = loadImage("goat_ok.png");
  astronautImg = loadImage("astronaut.png");
  goatDyingImg = loadImage("goat_die.png");

  size((int)canvasSizeX, (int)canvasSizeY);
  background(redCode, greenCode, blueCode);

  laneHeight = new float [numberOfLanes];
  for (int i = 0; i < numberOfLanes; i++) {
    laneHeight[i] = canvasSizeY/numberOfLanes*i+60;
  }

  balls = new ArrayList<Ball>();
  goats = new ArrayList<Goat>();

  player = new Player(initialLane); // Initial position lane
}

void draw () {
  background(redCode, greenCode, blueCode);
  fill(41, 171, 226);
  rect(0, 0, 30, height); // pool
  fill(255);
  rect(25, 0, 5, height); // pool
  // draw lanes
  for (int i = 0; i < 5; i++) {
    line(0, laneHeight[i]-60, canvasSizeX, laneHeight[i]-60);
  }

  if (time % goatFreq == 0) {
    //goats.add(new Goat(GoatInitialPositionX, laneHeight[2], goatPointsWorth));
    goats.add(new Goat(canvasSizeX, laneHeight[(int)random(0, 5)], 1));
  }

  if (time % 100 == 0) {
    goatFreq--;
  }

  // Draw player on screen
  player.draw();


  if (previewsSize != balls.size()) {
    println("Balls.size(): " + balls.size());
    previewsSize = balls.size();
  }

  // remove the balls out of the canvas and draw the ones inside. Then check for collisions with goats
  for (int i = 0; i < balls.size(); i++) { 
    // check for out of canvas balls and draw the ones inside
    if (balls.get(i).isOutOfCanvas()) {
      balls.remove(i);
      println("Ball removed due out of canvas");
    } 
    else {
      // draw ball
      balls.get(i).draw();

      // for each ball loop though all the goats to check the collisions ball <-> goat
      for (int j = 0; j < goats.size(); j++) { 
        if (balls.get(i).distanceToInX(goats.get(j).posX) <= goats.get(j).sizeX/2+collisionSpriteOffset && balls.get(i).posY == goats.get(j).posY) {
          // add points to the player
          pointsCounter = pointsCounter + goats.get(j).pointsWorth;

          // Impact! Goat screams and we remove it.
          goats.get(j).deathScream();
          println("Goat removed due ball hit");
          goats.get(j).bleed();

          // remove the ball that has just caused the impact
          println("Ball removed due to impact");
          balls.remove(i);
          break;
        }
      }
    }
  }

  // check for goats out of the canvas, draw the ones inside and check for collisions with the player or the pool (end line)
  for (int i = 0; i < goats.size(); i++) {
    // check for out of canvas goats and draw the ones inside
    if (goats.get(i).isOutOfCanvas()) {
      goats.remove(i);
      println("Goat removed due out of canvas");
    } 
    else {
      // draw goat
      goats.get(i).draw();
    }
  }

  // Check for goats that have touched the player or the end of the screen
  for (int i = 0; i < goats.size(); i++) {
    // check for collisions    
    if (goats.get(i).distanceToInX(player.posX) <= player.sizeX/2 && goats.get(i).posY == player.posY) {
      // impact!
      player.scream();
      // remove the goat that has just caused the impact
      println("Goat removed due hit with player");
      goats.remove(i);
      gameOver();
    } 
    else {
      // check for out of canvas goats and draw the ones inside
      if (goats.get(i).isOutOfCanvas()) {
        // destroy goat
        println("Goat removed due out of canvas");
        goats.remove(i);
      } 
      else {
        // draw goat
        goats.get(i).draw();
      }
    }
  }

  for (int i = 0; i < goats.size(); i++) {
    if (goats.get(i).bleeding()) {
      goats.get(i).bleed();
    }
    if (goats.get(i).dead()) {
      goats.remove(i);
    }
  }

  time++;
}

// This class represents the targets that the player has to blast in order to get points.
class Goat {
  int pointsWorth = 1;
  float posX;
  float posY;
  float sizeX;
  float sizeY;
  int colorCode = 0;
  int dyingCounter = 10;
  boolean dying = false;

  Goat (float pX, float pY, int p) {
    posX = pX;
    posY = pY;
    pointsWorth = p;
    sizeX = goatSizeX;
    sizeY = goatSizeY;
    colorCode = (int)random(0, 255);
  }

  void draw () {
    fill(colorCode);
    noStroke();
    rect(posX-40, posY-20, 100, 60);
    if (dying) {
      image(goatDyingImg, posX-65, posY-60, sizeX, sizeY);
    } 
    else {
      image(goatImg, posX-65, posY-60, sizeX, sizeY);
    }
    fill(255);
    if (!bleeding()) {
      posX--;
    }
  }

  boolean isOutOfCanvas() {
    if (posX > canvasSizeX || posX < 0 || posY < 0 || posY > canvasSizeY) {
      return true;
    } 
    else {
      return false;
    }
  }

  boolean bleeding () {
    return dying;
  }

  void bleed() {
    dying = true;
    dyingCounter--;
  }

  boolean dead() {
    if (dyingCounter <= 0) {
      return true;
    } 
    else {
      return false;
    }
  }

  void deathScream() {
    // Ahhhhhhh -> play a screem sound
  }

  float distanceToInX(float pos) {
    float a = posX - pos;
    if (a < 0) {
      return -a;
    } 
    else {
      return a;
    }
  }
}

// This class represents a blast bolt on the screen
class Ball {
  float posX = 0;
  float posY = 0;
  int damage = 1;

  Ball (float pX, float pY) {
    posX = pX;
    posY = pY;
  }

  void draw () {
    fill(0);
    image(ballImg, posX+45, posY-5, 40, 40);
    fill(255);
    posX = posX + 2;
  }

  boolean isOutOfCanvas() {
    if (posX > canvasSizeX || posX < 0 || posY < 0 || posY > canvasSizeY) {
      return true;
    } 
    else {
      return false;
    }
  }

  float distanceToInX(float pos) {
    float a = posX - pos;
    if (a < 0) {
      return -a;
    } 
    else {
      return a;
    }
  }

  float distanceToInY(float pos) {
    float a = posY - pos;
    if (a < 0) {
      return -a;
    } 
    else {
      return a;
    }
  }
}

// This class represents a player on the screen
class Player {
  float posX = 100;
  float posY = laneHeight[2];
  int lane = 2;
  int sizeX = playerSize;
  int sizeY = playerSize;

  // The constructor takes the initial energy level and the initial position
  // of the player on screen (initialPosX and initialPosY)
  Player (int l) {
    lane = l;
    if (0 <= lane && lane < numberOfLanes) {
      posY = laneHeight[lane];
    } 
    else {
      println("There is no such a lane...");
    }
  }

  void shootBall () {
    balls.add(new Ball(posX, posY));
    println("Ball out");
  }

  void draw () {
    fill(0);
    image(astronautImg, posX-60, posY-60, sizeX, sizeY);
    fill(255);
  }

  void moveUp() {
    if (lane > 0) {
      lane--;
      posY = laneHeight[lane];
    }
  }

  void moveDown() {
    if (lane < numberOfLanes-1) {
      lane++;
      posY = laneHeight[lane];
    }
  }

  void scream() {
    // ahhhhh!
  }
}

void keyPressed() {
  switch(key) {  
  case 'a':
    player.shootBall();
    break;

  case 'd':
    player.moveDown();
    break;

  case 'j':
    player.moveUp();
    break;

  case 'f':
    player.shootBall();
    break;
  }
}

void gameOver() {
  // Game over motherfucker!
  restart();
}

void restart() {
  goats.clear();
  balls.clear();
  goatFreq = initialGoatFreq;
}
