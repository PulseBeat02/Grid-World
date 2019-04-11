import arb.soundcipher.*;
import arb.soundcipher.constants.*;

/*

Objective: Get all Gems before Dying
- You can lose health if you step into lava (Red)
- You can lose health if your thirst level is 0. You can get water to increase your thirst, however, these water cells will go away
if you drink too much! The same goes with hunger.
- Do not touch the black at all times.
- The pink are chug jugs, giving you max everything
Good Luck!

*/

int[] notes = {
 60,
 69,
 64,
 62,
 64,
 67,
 64
};
SoundCipher sc = new SoundCipher(this); // Import Soundcipher
int frames_per_beat = 30;

int[][] world;

int ROWS, COLS;
int C_SIZE = 25; // CELL SIZE  (how many pixels is a cell across/up&down)

int GRASS = 0; // constant variables - not going to change
int WATER = 1; //   stand-in for actual numbers - usually all-caps
int SWAMP = 2;
int LAVA = 3;
int STONE = 4;
int GEMS = 5;
int collectedGem = 6;
int FOOD = 7;
int CHUGJUG = 8;
int ILLUMANATI = 9;

int GemsCollected = 0;
int totalGems = 0;

double health = 100;
double hunger = 100;
double thirst = 100;
double energy = 100;

boolean isDamage = false;
boolean isAlive = true;
boolean isMoving = true;

boolean isIllumanati = false;

// to store where the player is
int pr, pc;

int waterDranked = 3;
int foodEaten = 5;

int moves = 0;

PImage player, dead, gem, illumanati, good, ok, bad; // Defining PImages

// int [][] lava = new int[50][50];

void setup() {

 size(1600, 1200);

 ROWS = height / C_SIZE;
 COLS = width / C_SIZE;

 initBoard();

 pr = ROWS / 2;
 pc = COLS / 2;

 player = loadImage("https://i.ibb.co/BZYDjjz/download.jpg"); // Loading URL's
 dead = loadImage("https://i.ibb.co/BP6KfdS/download.png");
 gem = loadImage("https://i.ibb.co/Scfddhm/gem.png");
 illumanati = loadImage("https://i.ibb.co/Ptdcz1V/illuminati.jpg");
 good = loadImage("https://i.ibb.co/DCmd7x5/smileemoji.png");
 ok = loadImage("https://i.ibb.co/WsLhGhG/warning.png");
 bad = loadImage("https://i.ibb.co/XWyXVzy/bad.png");

}

void keyPressed() {

 if (isAlive && isMoving) {

  if (keyCode == RIGHT && energy > 15) {

   pc++;
   energy -= 0.5;
   moves++;


  } else if (keyCode == LEFT && energy > 15) {

   pc--;
   energy -= 0.5;
   moves++;

  } else if (keyCode == UP && energy > 15) {

   pr--;
   energy -= 0.5;
   moves++;

  } else if (keyCode == DOWN && energy > 15) {

   pr++;
   energy -= 0.5;
   moves++;

  }

 }

}

void initBoard() {

 world = new int[ROWS][COLS];
 // filled with 0s

 for (int r = 0; r < ROWS; r++) {

  for (int c = 0; c < COLS; c++) {

   float rand = random(1); // even chance b/w 0.0 and 1.0

   if (rand < 0.65) { // 0.0 - 0.8 -> 80%

    world[r][c] = GRASS;

   } else if (rand >= 0.65 && rand < 0.73) {

    world[r][c] = WATER;

   } else if (rand >= 0.73 && rand < 0.81) {

    world[r][c] = LAVA;

   } else if (rand >= 0.81 && rand < 0.86) {

    world[r][c] = SWAMP;

   } else if (rand >= 0.86 && rand < 0.88) {

    world[r][c] = STONE;

   } else if (rand >= 0.88 && rand < 0.98) {

    world[r][c] = FOOD;

   } else if (rand >= 0.98 && rand < 0.998) {

    world[r][c] = GEMS;
    totalGems++;

   } else if (rand >= 0.998 && rand < 0.9998) {

    world[r][c] = CHUGJUG;

   } else {

    world[r][c] = ILLUMANATI;

   }

  }

  world[pr][pc] = GEMS;

 }

}

void draw() {

 preventArrayException();

 String GemsCollectedResult = "  Gems Collected: " + GemsCollected + "/" + totalGems;

 float healthString = ((int)(health * 100)) / 100.0;

 drawWorld();

 drawPlayer();

 if (key == ' ') {

  textSize(90);

  text("Press Any Key to Begin", 400, 750);

  GemsCollected = 0;

  totalGems = 0;

  health = 100;

  hunger = 100;

  energy = 100;

  thirst = 100;

  isDamage = false;

  isAlive = true;

  waterDranked = 25;

  initBoard();

 }

 fill(211, 211, 211, 200);

 rect(40, 20, 1520, 120);

 rect(40, 140, 1520, 120);

 rect(40, 260, 1520, 120);

 fill(0);
 textSize(75);


 text("Health: " + healthString + "/100", 50, 100);

 text(GemsCollectedResult, 700, 100);

 fill(0);

 text("Thirst: " + thirst + "/200", 50, 215);

 text("  Hunger: " + hunger + "/200", 705, 215);

 text("Energy " + energy + "/200", 55, 330);

 text("  Rating: ", 705, 330);

 if ((health < 25 || thirst < 25 || hunger < 25 || energy < 25) && (health != 0 || thirst != 0 || hunger != 0 || energy != 0)) {

  image(bad, 1000, 250, 100, 100);
  sc.playNote(64, 10, 1);

 } else if (health < 50 || thirst < 50 || hunger < 50 || energy < 50) {

  image(ok, 1050, 250, 100, 100);


 } else if (health >= 50 || thirst >= 50 || hunger >= 50 || energy >= 50) {

  image(good, 1050, 250, 100, 100);

 } else if (health <= 0) {

  image(dead, 1050, 250, 100, 100);

 }

 fill(255);

 text("Spacebar to Restart :)", 10, 1200);

 if (isDamage) {

  health--;

 }

 if (health <= 0) {

  GemsCollectedResult = "Fail";

  isDamage = false;

  isAlive = false;

  health = 0;

  thirst = 0;

  hunger = 0;

  energy = 0;

  textSize(200);

  fill(211, 211, 211);

  rect(300, 480, 1100, 200);

  fill(166, 16, 30);

  text("YOU DIED!", 325, 650);

 }

 if (GemsCollected == totalGems) {

  isDamage = false;

  isAlive = false;

  health = 0;

  thirst = 0;

  hunger = 0;

  energy = 0;

  textSize(200);

  fill(212, 175, 55);

  text("YOU WON!", 325, 650);

 }

 if (thirst <= 0 || hunger <= 0) {

  thirst = 0;
  hunger = 0;

  if (health > 0) {

   health -= 0.5;

  }

 }

 if (energy <= 15 && energy != 0) {

  println("You crawl onto the ground and fall because of your lack of energy. Your only chance now is to restart the game");

 }

 for (int i = 0; i < notes.length; i++) {

  if ((i * frames_per_beat) + 1 == frameCount) {

   sc.playNote(notes[i], 100, 1);

  }

 }

}

int thirstCounter = 60;
int hungerCounter = 60;
int healthCounter = 240;
int energyCounter = 120;

void drawPlayer() {
 float x = pc * C_SIZE; // middle of the cell of player
 float y = pr * C_SIZE;

 fill(255);

 if (thirstCounter-- <= 0) {

  thirstCounter = 60;

  if (thirst > 0) {

   thirst -= 3.5;

  }

 } else if (hungerCounter-- <= 0) {

  hungerCounter = 60;

  if (hunger > 0) {

   hunger -= 2.5;

  }

 } else if (healthCounter-- <= 0) {

  healthCounter = 240;

  if (health > 0 && health != 100) {

   health += 1;

  }

 } else if (energyCounter-- <= 0) {

  energyCounter = 120;

  if (energy > 0 && energy != 200) {

   energy -= 1;

  }

 }

 if (isAlive) {

  image(player, x, y, C_SIZE, C_SIZE);

 } else {

  image(dead, x, y, C_SIZE, C_SIZE);

 }

 if (world[pr][pc] == LAVA && moves != 0) {

  isDamage = true;

 } else if (world[pr][pc] == GEMS) {

  GemsCollected++;

  world[pr][pc] = collectedGem;
  //   ellipse(x + 20, y + 20, 50, 50);

 } else if (world[pr][pc] == CHUGJUG) {

  health = 100;

  thirst = 200;

  hunger = 200;

  energy = 200;

  world[pr][pc] = GRASS;

 } else if (world[pr][pc] == ILLUMANATI) {

  image(illumanati, 0, 0, 1600, 1200);

  isDamage = false;

  isAlive = false;

  health = 666;

  thirst = 666;

  hunger = 666;

  energy = 666;

  GemsCollected = 666;

  isIllumanati = true;

  for (int g = 0; g < 100; g++) {

   println("You found me");

  }

 } else {

  isDamage = false;

 }

 if (world[pr][pc] == WATER) {

  if (waterDranked == 1) {

   world[pr][pc] = GRASS;

   waterDranked = 15;

  } else if (thirst != 200) {

   thirst += 0.5;

   waterDranked--;

  }

 } else if (world[pr][pc] == FOOD) {

  hunger++;

  energy++;

  if (foodEaten == 1) {

   world[pr][pc] = GRASS;

   foodEaten = 15;

  } else if (hunger != 200) {

   hunger += 0.5;

   foodEaten--;

  }

 } else if (world[pr][pc] == STONE) {
     
    int randomStep = random(2) > 0 ? 1 : -1;
    pr += randomStep;
    pc += randomStep;

 }

}

void drawWorld() {

 for (int r = 0; r < ROWS; r++) {

  for (int c = 0; c < COLS; c++) {

   int x = c * C_SIZE;
   int y = r * C_SIZE;

   int cell = world[r][c];

   if (cell == GRASS) {

    fill(0, 128, 0); // dark green

   } else if (cell == WATER) {

    fill(0, 0, 100); // dark blue

   } else if (cell == SWAMP) {

    fill(153, 50, 204); // purple

   } else if (cell == LAVA) {

    fill(178, 34, 34); // Red

   } else if (cell == STONE) {

    fill(105, 105, 105);

   } else if (cell == collectedGem) {

    fill(255, 233, 0);

   } else if (cell == FOOD) { // Brown

    fill(101, 67, 33);

   } else if (cell == CHUGJUG) { // Pink

    fill(255, 192, 203);

   } else if (cell == ILLUMANATI) {

    fill(0);

   } else {

    fill(135, 206, 250); // Gem (light blue)

    image(gem, x, y);

   }

   noStroke();

   rect(x, y, C_SIZE, C_SIZE);

  }

 }

}

void preventArrayException() {

 if (pr > 47) {

  pr = 47;

 } else if (pr < 0) {

  pr = 0;

 } else if (pc > 63) {

  pc = 63;

 } else if (pc < 0) {

  pc = 0;

 }

}

void throwException(String message) throws Exception {

 println(new Exception(message));

}


// int setIntegerLimit(int value, int begin, int end) {

//     if (value < begin || value > end) {



//     }

// }
