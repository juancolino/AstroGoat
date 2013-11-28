int sizeY = 600;
int sizeX = 800;

int time = 0;

// Settings and vars for the players
int playerSize = 50;
int maximumEnergy = 300;
int energyBarHeight = 50;
int barBlinkingFreq = 2;

Player player1;
float player1InitialPositionX = 100;
float player1InitialPositionY = sizeY - 50;

void setup () {
  size(sizeX, sizeY);
  background(255);

  player1 = new Player(0, player1InitialPositionX, player1InitialPositionY);
}

void draw () {
  background(255);
  drawEnergyBars();
  if (time % 10 == 0) {
    int r = (int)random(1, 10);
    for (int i = 0; i < r; i++) {
      player1.chargeEnergy();
    }
  }

  player1.drawPlayer();
  time++;
}


// This class represents a player on the screen
class Player {
  int energy;
  int maxEnergy = maximumEnergy;
  float posX;
  float posY;

  // The constructor takes the initial energy level and the initial position of the player on screen (initialPosX and initialPosY)
  Player (int initialEnergy, float initialPosX, float initialPosY) {
    energy = initialEnergy;
    posX = initialPosX;
    posY = initialPosY;
  }

  void chargeEnergy () {
    if (energy < maxEnergy) {
      energy++;
    }
  }

  void dischargeEnergy() {
    if (energy > 0) {
      energy--;
    }
  }

  void drawEnergyFromOpponent () {
    opponent.dischargeEnergy();
  }

  void shootEnergyBlast () {
  }

  void drawPlayer () {
    fill(0);
    ellipse(posX, posY, playerSize, playerSize);
    fill(255);
  }
}

void drawEnergyBars() {
  // Player 1 bar
  if (player1.energy < (int)maximumEnergy*0.75) {
    fill(0);
  } 
  else if (player1.energy == maximumEnergy) {
    if (time % barBlinkingFreq < (int)barBlinkingFreq/2) {
      fill(255); // white
    } 
    else {
      fill(255, 0, 0); // red
    }
  } 
  else if (player1.energy >= (int)maximumEnergy*0.75) {
    fill(255, 0, 0);
  }

  textSize(30);
  noStroke();
  rect(50, 50, player1.energy, energyBarHeight);
  fill(0);
  text(player1.energy + "/" + maximumEnergy, 50, 150);
  fill(255);
}

void keyPressed() {
  switch(key) {
    //player 1 cases  
  case 'a':
    player1.chargeEnergy();
    break;

  case 'b':
    player1.shootEnergyBlast();
    break;

  case 'c':
    player1.drawEnergyFromOpponent();
    break;
  }
}
