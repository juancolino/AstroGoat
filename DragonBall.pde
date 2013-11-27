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

Player player2;
float player2InitialPositionX = sizeX - 100;
float player2InitialPositionY = sizeY - 50;

void setup () {
  size(sizeX, sizeY);
  background(255);

  player1 = new Player(0, player1InitialPositionX, player1InitialPositionY);
  player2 = new Player(0, player2InitialPositionX, player2InitialPositionY);
  player1.assignOpponent(player2);
  player2.assignOpponent(player1);
}

void draw () {
  background(255);
  drawEnergyBars();
  if (time % 10 == 0) {
    int r = (int)random(1, 10);
    for (int i = 0; i < r; i++) {
      player1.chargeEnergy();
    }
    r = (int)random(1, 10);
    for (int i = 0; i < r; i++) {
      player2.chargeEnergy();
    }
  }

  if (player1.energy == player1.maxEnergy) {
    // Victory for Player 1
  } 
  else if (player2.energy == player2.maxEnergy) {
    // Victory for Player 2
  }

  player1.drawPlayer();
  player2.drawPlayer();
  time++;
}


// This class represents a player on the screen
class Player {
  int energy;
  int maxEnergy = maximumEnergy;
  float posX;
  float posY;
  Player opponent;

  // The constructor takes the initial energy level and the initial position of the player on screen (initialPosX and initialPosY)
  Player (int initialEnergy, float initialPosX, float initialPosY) {
    energy = initialEnergy;
    posX = initialPosX;
    posY = initialPosY;
  }

  void assignOpponent (Player opp) {
    opponent = opp;
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

  // Player 2 bar
  if (player2.energy < (int)maximumEnergy*0.75) {
    fill(0, 0, 0);
  } 
  else if (player2.energy == maximumEnergy) {
    if (time % barBlinkingFreq < (int)barBlinkingFreq/2) {
      fill(255);
    } 
    else {
      fill(255, 0, 0);
    }
  } 
  else if (player2.energy >= (int)maximumEnergy*0.75) {
    fill(255, 0, 0);
  }

  textSize(30);
  noStroke();
  rect(sizeX/2 + 50, 50, player2.energy, energyBarHeight);
  fill(0);
  text(player2.energy + "/" + maximumEnergy, sizeX/2 + 50, 150);
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

    //player 2 cases
  case 'd':
    player2.chargeEnergy();
    break;

  case 'e':
    player2.shootEnergyBlast();
    break;

  case 'f':
    player2.drawEnergyFromOpponent();
    break;
  }
}
