float sizeY = 600;
float sizeX = 800;

int time = 0;

// Settings and vars for the player
int playerSize = 50;

// Settings for the game
int pointsCounter = 0;
int numberOfLanes = 5;
int [] laneHeight;

// Settings for the goats
int goatSizeX = 50;
int goatSizeY = 30;
int goatPointsWorth = 1;

Player player;
float playerInitialPositionX = 100;
float playerInitialPositionY = sizeY - 50;

ArrayList<Balls> balls;
ArrayList<Goat> goats;

void setup () {
  size(sizeX, sizeY);
  background(255);

  laneHeight = new float [5];
  for (int i = 0; i < laneHeight; i++) {
    laneHeight[i] = sizeY/numberOfLanes;
  }

  bolts = new ArrayList<Ball>();
  goats = new ArrayList<Goat>();

  player = new Player(playerInitialPositionX, playerInitialPositionY);
}

void draw () {
  background(255);
  // draw lanes
  for (int i = 0; i < 5; i++) {
    line(sizeY/5, 0, sizeX, sizeY);
  }

  // Draw player on screen
  player.draw();

  // remove the bolts out of the canvas and draw the ones inside
  for (int i = 0; i < balls.size(); i++) { // loop though the balls
    for (int j = 0; j < targets.size(); j++) { // for each bolt loop though all the goats to check the collisions ball <-> goat
      if (balls.get(i).distanceToInX(goats.get(j).posX) <= goats.get(j).sizeX/2) { // we only check on the X axis.
        // Impact!


        // add points to the player
        pointsCounter = pointsCounter + targets.get(j).pointsWorth;
        // remove the bolt that has just caused the impact
        bolts.remove(i);
        // remove the target
        targets.remove(j);
      } 
      else {
        // check for out of canvas bolts and draw the ones inside
        if (bolts.get(i).isOutOfCanvas()) {
          bolts.remove(i);
        } 
        else {
          // draw bolt
          bolts.get(i).draw();
        }
      }
    }

    // -------

    /*    // check for collisions    
     if (bolts.get(i).distanceToInX(wert.posX) <= wert.size/2 && bullets.get(i).distanceToInY(wert.posY) <= wert.size/2) {
     // impact!
     println("IMPACTO");
     wert.takeDamage(bullets.get(i).damage);
     // remove the bullet that has just caused the impact
     bullets.remove(i);
     } 
     else {
     // check for out of canvas bullets and draw the ones inside
     if (bullets.get(i).isOutOfCanvas()) {
     // destroy bullet
     println("Bullet " + bullets.get(i) + " removed.");
     bullets.remove(i);
     } 
     else {
     // draw bullet
     bullets.get(i).draw();
     }
     }
     }
     
     */

    for (int i = 0; i < bullshits.size(); i++) {
      // check for collisions    
      if (bullshits.get(i).distanceToInX(student.posX) <= student.size/2 && bullshits.get(i).distanceToInY(student.posY) <= student.size/2) {
        // impact!
        println("IMPACTO");
        student.takeDamage(bullshits.get(i).damage);
        // remove the bullet that has just caused the impact
        bullshits.remove(i);
      } 
      else {
        // check for out of canvas bullets and draw the ones inside
        if (bullshits.get(i).isOutOfCanvas()) {
          // destroy bullet
          println("Bullshit " + bullshits.get(i) + " removed.");
          bullshits.remove(i);
        } 
        else {
          // draw bullet
          bullshits.get(i).draw();
        }
      }
    }

    time++;
  }

  // This class represents the targets that the player has to blast in order to get points.
  class Goat {
    int pointsWorth = goatPointsWorth;
    int posX = 0;
    int posY = 0;
    int sizeX;
    int sizeY;

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
  }

  // This class represents a blast bolt on the screen
  class Ball {
    int posX = 0;
    int posY = 0;
    int damage = 1;

    Ball (int pX, int pY) {
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

    int distanceToInX(int pos) {
      int a = posX - pos;
      if (a < 0) {
        return -a;
      } 
      else {
        return a;
      }
    }

    int distanceToInY(int pos) {
      int a = posY - pos;
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
    Player (int lane) {
      if (0 >= lane >= numberOfLanes) {
        posY = laneHeight[lane];
      } else {
        println("There is no such a lane...");
      }
    }

    void shootBall () {
      balls.add(new Ball(posX, posY));
    }

    void draw () {
      fill(0);
      rect(posX, posY, sizeX, sizeY);
      fill(255);
    }
  }

  void keyPressed() {
    switch(key) {  
    case 'a':
      player.shootBall();
      break;

    case 'b':
      // bla
      break;
    }
  }
