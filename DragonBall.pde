int sizeY = 600;
int sizeX = 800;

int time = 0;

// Settings and vars for the players
int playerSize = 50;
int barBlinkingFreq = 2;

Player player;
float player1InitialPositionX = 100;
float player1InitialPositionY = sizeY - 50;

void setup () {
  size(sizeX, sizeY);
  background(255);

  player = new Player(player1InitialPositionX, player1InitialPositionY);
}

void draw () {
  background(255);

  player.drawPlayer();
  time++;
}


// This class represents a player on the screen
class Player {
  float posX;
  float posY;

  // The constructor takes the initial energy level and the initial position
  // of the player on screen (initialPosX and initialPosY)
  Player (float initialPosX, float initialPosY) {
    posX = initialPosX;
    posY = initialPosY;
  }

  void shootEnergyBlast () {
  }

  void drawPlayer () {
    fill(0);
    ellipse(posX, posY, playerSize, playerSize);
    fill(255);
  }
}

void keyPressed() {
  switch(key) {  
  case 'a':
    player1.shootEnergyBlast();
    break;

  case 'b':
    // bla
    break;
  }
}
