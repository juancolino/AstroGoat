float sizeY = 600;
float sizeX = 800;

int time = 0;
int previewsSize = 0;

// Settings and vars for the player
int playerSize = 50;

// Settings for the game
int pointsCounter = 0;
int numberOfLanes = 5;
float [] laneHeight;
int initialLane = 2;

// Settings for the goats
int goatSizeX = 50;
int goatSizeY = 30;
int goatPointsWorth = 1;

Player player;
float playerInitialPositionX = 100;
float playerInitialPositionY = sizeY - 50;

ArrayList<Ball> balls;
ArrayList<Goat> goats;

void setup () {
  size((int)sizeX, (int)sizeY);
  background(255);

  laneHeight = new float [numberOfLanes];
  for (int i = 0; i < numberOfLanes; i++) {
    laneHeight[i] = sizeY/numberOfLanes*i+60;
  }

  balls = new ArrayList<Ball>();
  goats = new ArrayList<Goat>();

  player = new Player(initialLane); // Initial position lane
}

void draw () {
  background(255);
  // draw lanes
  for (int i = 0; i < 5; i++) {
    line(0, laneHeight[i]-60, sizeX, laneHeight[i]-60);
  }

  // Draw player on screen
  player.draw();

  // remove the balls out of the canvas and draw the ones inside
  if (previewsSize != balls.size()) {
    println("Balls.size(): " + balls.size());
    previewsSize = balls.size();
  }
  for (int i = 0; i < balls.size(); i++) { // loop though the balls
    // check for out of canvas balls and draw the ones inside
    if (balls.get(i).isOutOfCanvas()) {
      balls.remove(i);
      println("Ball removed due out of canvas");
    } 
    else {
      // draw ball
      balls.get(i).draw();
    }

    for (int j = 0; j < goats.size(); j++) { // for each ball loop though all the goats to check the collisions ball <-> goat
      if (balls.get(i).distanceToInX(goats.get(j).posX) <= goats.get(j).sizeX/2) { // we only check on the X axis.
        // Impact! Goat screams and we remove it.
        goats.get(i).deathScream();
        goats.remove(j);

        // add points to the player
        pointsCounter = pointsCounter + goats.get(j).pointsWorth;

        // remove the bolt that has just caused the impact
        println("Ball removed due to impact");
        balls.remove(i);
      }
    }
  }

  // Check for goats that have touched the player or the end of the screen
  for (int i = 0; i < goats.size(); i++) {
    // check for collisions    
    if (goats.get(i).distanceToInX(player.posX) <= player.sizeX/2) {
      // impact!
      player.scream();
      gameOver();
      // remove the goat that has just caused the impact
      goats.remove(i);
    } 
    else {
      // check for out of canvas goats and draw the ones inside
      if (goats.get(i).isOutOfCanvas()) {
        // destroy goat
        goats.remove(i);
      } 
      else {
        // draw goat
        goats.get(i).draw();
      }
    }
  }


  time++;
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
}

// This class represents the targets that the player has to blast in order to get points.
class Goat {
  int pointsWorth = goatPointsWorth;
  float posX = 0;
  float posY = 0;
  float sizeX;
  float sizeY;

  Goat (int pX, int pY, int p) {
    posX = pX;
    posY = pY;
    pointsWorth = p;
    sizeX = goatSizeX;
    sizeY = goatSizeY;
  }

  void draw () {
    fill(0);
    rect(posX, posY, sizeX, sizeY);
    fill(255);
    posX--;
  }

  boolean isOutOfCanvas() {
    if (posX > sizeX || posX < 0 || posY < 0 || posY > sizeY ) {
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
    rect(posX, posY, 20, 20);
    fill(255);
    posX++;
  }

  boolean isOutOfCanvas() {
    if (posX > sizeX || posX < 0 || posY < 0 || posY > sizeY ) {
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
    rect(posX-(sizeX/2), posY-(sizeY/2), sizeX, sizeY);
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
