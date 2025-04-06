// Bird variables
PImage[] birdSprites = new PImage[4]; // Array to hold the bird sprite frames

int birdX = 50; // X position of the bird
int birdY; // The vertical position of the bird
int birdWidth = 64; // bird width
int birdHeight = 64; // bird height
int birdVelocity; // The current vertical velocity of the bird
int gravity = 1; // The force pulling the bird downward
int lift = -15; // The upward force applied when the bird jumps
int maxBirdVelocity = 9; // Max vertical velocity of the bird

// Score and game state variables
int score = 0; // The player's score, increases "when passing pipes"
boolean gameOver;

// Pipe variables
int pipeWidth = 80; // The width of each pipe
int pipeMinHeight = 50; // Minimum height of the pipes
int pipeGap = 300; // The vertical gap between the upper and lower pipes
int pipeSpeed = 3; // The speed at which pipes move leftward
int pipeDistance = 200; // Horizontal distance between pipes
int pipeTotal = 20; // The total number of pipes generated

// Arrays for pipe positions
int[] pipeX = new int[pipeTotal]; // X-coordinate of the pipe's left edge.
int[] pipeY = new int[pipeTotal]; // Y-coordinate of the bottom pipe's top edge.

// For testing purposes (turning pipes red instead of gameover)
boolean TESTING = false; // Set to false to play the game normally
boolean[] pipeCollided = new boolean[pipeTotal]; // Tracks whether each pipe has been collided with by the bird

int birdFrame = 0; // Current frame of the bird animation
int frameCounter = 0; // Counter to control animation speed

void setup() {
    frameRate(60);
    size(400, 600);
    init();
    
    // Load the bird sprite frames
    birdSprites[0] = loadImage("b1.png"); 
    birdSprites[1] = loadImage("b2.png");
    birdSprites[2] = loadImage("b3.png");
    birdSprites[3] = loadImage("b4.png");
}

void draw() {
    background(135, 206, 235);
    
    if (!gameOver) {
        // Bird
        /* Practice1-1: Draw bird and add gravity to it */
        pushMatrix();
        // println(birdX, birdY, birdWidth, birdHeight);
        translate(birdX, birdY);
        imageMode(CENTER);
        image(birdSprites[(frameCount / 10) % birdSprites.length], 0, 0, birdWidth, birdHeight);
        popMatrix();

        birdY += birdVelocity;
        birdVelocity = constrain(birdVelocity += gravity, -maxBirdVelocity, maxBirdVelocity);
         
    
        /* --------------------------------------------- */
        
        // Pipes
        drawPipes();
        
        /* Practice1-3: Check if bird hits the ground or ceiling */
        if (birdY - birdHeight / 2 <= 0 || birdY + birdHeight / 2 >= height) {
            gameOver = true;
        }
       
        /* --------------------------------------------- */
        
        // Display score
        fill(0);
        textSize(32);
        text("Score: " + score, 10, 30);
       
        /* --------------------------------------------- */
        
    } else {
        fill(0);
        textSize(32);
        if(score == pipeTotal) {
            text("Game Win", width / 2 - 80, height / 2);
        } else {
            text("Game Over", width / 2 - 80, height / 2);
        }
        text("Score: " + score, width / 2 - 60, height / 2 + 40);
        text("Press 'r' to restart", width / 2 - 120, height / 2 + 80);
        /* --------------------------------------------- */
    }
}

void drawPipes() {
    /* Practice2-2: Use loop to move pipes and check collision with bird */
    for (int i = 0; i < pipeTotal; i++) {
        //pipeX add spped
        pipeX[i] -= pipeSpeed;
       
        // If pipe is not in screen(left or right), skip
        if (pipeX[i] + pipeWidth < 0 || pipeX[i] > width) {
            continue;
        }
       
        // If bird is going to pass through this pipe, add score
        if (i >= score && birdX - birdWidth / 2 > pipeX[i] + pipeWidth) {
            ++score;
        }
      
        // Check if this is the last pipe, if so, game over
        gameOver = score == pipeTotal;

        // Practice2-3: Check collision between the bird and pipes
        pipeCollided[i] = (birdX + birdWidth / 2 >= pipeX[i] && birdX - birdWidth / 2 <= pipeX[i] + pipeWidth) &&
                          (birdY + birdHeight / 2 >= pipeY[i] || birdY - birdHeight / 2 <= pipeY[i] - pipeGap);
        if (!TESTING && pipeCollided[i]) {
            gameOver = true;
            break;
        }
        
        
        // Draw pipe
        drawPipe(pipeX[i], pipeY[i], pipeWidth, pipeGap, pipeCollided[i]);
    }
    /* --------------------------------------------- */
}

void drawPipe(int x, int y, int w, int gap, boolean collided) {
    if (collided) {
        fill(255, 0, 0); //red
    } else {
        fill(34, 139, 34); //green
    }
    rect(x, 0, w, y - gap); // upper pipe
    rect(x, y, w, height - y); // lower pipe
}

void keyPressed() {
    /* Practice1-2: Add lift to bird when space is pressed */
    if (!gameOver && key == ' ') {
        birdVelocity += lift;
    }   
   
    /* --------------------------------------------- */
    if (gameOver && key == 'r') {
        init();
    }
}

void init() {
    birdY = height / 3;
    birdVelocity = 0;
    /* Practice2-1: Setup pipe positions using for loop */
    for (int i = 0; i < pipeTotal; ++i) {
        pipeX[i] = i * pipeDistance + width;
        pipeY[i] = (int)(random((float)(pipeMinHeight + pipeGap), (float)(height - pipeMinHeight)));
    }
   
    /* --------------------------------------------- */
    score = 0;
    gameOver = false;
}
