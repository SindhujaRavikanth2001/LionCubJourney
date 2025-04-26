
import java.util.ArrayList;
import java.util.Iterator;

class GameEngine {
    // Game state variables
    String gameStatus;
    private String gameState = "menu";
    int currentLevel;

    // Sprite management
    Sprites sprites;
    ArrayList<Snake> snakes;
    ArrayList<Sprite> bushes;
    Meat meat;
    boolean meatEaten;
    Sprite splat;

    // UI and visual elements
    PImage background, menuBackground;
    private PFont gameFont;
    PImage heartIcon;

    // Game mechanics
    HealthManager healthManager;
    int mX, mY, snakeStep;
    float bushDistance;

    // Snake spawning parameters
    private float spawnChance = 0.02f;

    // Level-specific constants
    private static final int LEVEL_1_SNAKES = 3;
    private static final int LEVEL_2_SNAKES = 4;
    private static final int LEVEL_3_SNAKES = 5;
    private static final float BASE_SNAKE_SPEED = 0.5f;

    // Reset mechanics
    private static final int RESET_DELAY = 2000;
    private boolean isResetting = false;
    private long resetStartTime = 0;

    // Constructor
    GameEngine(String status) {
        this.gameStatus = status;
        this.currentLevel = 1;
        this.sprites = new Sprites();
        this.snakes = new ArrayList<Snake>();
        this.bushes = new ArrayList<Sprite>();
        this.healthManager = new HealthManager("active", 3, "healthy");
        this.meatEaten = false;
        this.bushDistance = 200;
        this.gameFont = createFont("Arial", 32);
        this.heartIcon = loadImage("heart.png");
        this.menuBackground = loadImage("menu_background.png");
        this.menuBackground.resize(width, height);
    }

    // Main game loop
    public void drawGame() {
        switch(gameState) {
            case "menu":
                drawMenu();
                break;
            case "howToPlay":
                drawHowToPlay();
                break;
            case "playing":
                drawGameplay();
                break;
        }
    }

private void drawMenu() {
    // Draw background with subtle parallax effect
    float parallaxOffset = sin(frameCount * 0.01) * 10;
    image(menuBackground, parallaxOffset, 0);
    
    // Add semi-transparent overlay for text contrast
    fill(0, 150);
    rect(0, 0, width, height);

    textFont(gameFont);
    textAlign(CENTER, CENTER);

    // Animated title with shadow and glow
    textSize(72);
    fill(0, 100);
    text("The Lion Cub's Journey", width/2 + 4, height/3 + 4);
    fill(255, 200, 100);
    text("The Lion Cub's Journey", width/2, height/3);

    // Interactive menu options with hover and animation effects
    drawMenuOption("Start Game", width/2, height/2, height/2 - 20, height/2 + 20);
    drawMenuOption("View Instructions", width/2, height/2 + 60, height/2 + 40, height/2 + 80);

    // Optional: Add decorative paw prints
    drawPawPrints();
}

private void drawMenuOption(String text, float x, float y, float hoverStart, float hoverEnd) {
    textSize(36);
    if (mouseY > hoverStart && mouseY < hoverEnd) {
        fill(255, 255, 0);
        // Glow effect on hover
        for (int i = 5; i > 0; i--) {
            fill(255, 255, 0, 50 - i * 10);
            text(text, x, y + sin(frameCount * 0.1) * 3);
        }
    } else {
        fill(200);
    }
    text(text, x, y);
}

private void drawPawPrints() {
    for (int i = 0; i < 5; i++) {
        float x = random(width);
        float y = random(height);
        fill(255, 100);
        ellipse(x, y, 15, 20);
        ellipse(x + 20, y, 15, 20);
        ellipse(x + 5, y + 25, 10, 15);
        ellipse(x + 15, y + 25, 10, 15);
    }
}

    // Draw the how to play screen
    private void drawHowToPlay() {
        image(menuBackground, 0, 0);
        textFont(gameFont);
        textAlign(CENTER, CENTER);
        textSize(32);
        fill(0);
        text("Instructions", width / 2, height / 4);
        textSize(20);
        text("1. Use arrow keys to move the cub.\n2. Collect meat to gain health.\n3. Avoid snakes to stay alive.\n4. Reach the cave to complete levels.\n5. esc to exit the game.", width / 2, height / 2);
        textSize(28);
        if (mouseY > height - 80 && mouseY < height - 40) {
            fill(255, 255, 0);
        } else {
            fill(0);
        }
        text("Back to Menu", width / 2, height - 60);
    }

    // Draw the main gameplay
    private void drawGameplay() {
        if (gameStatus.equals("active")) {
            image(background, 0, 0);
            
            sprites.advance();
            checkCollision();
            updateSnakes();
            displayUI();
            sprites.show();
            checkGameOver();
            if (meatEaten) {
                sprites.remove(meat);
            }
        } else if (gameStatus.equals("over")) {
            drawGameOver();
        } else if (gameStatus.equals("won")) {
            text("You Win!", width / 2, height / 4);
            displayNextLevelPrompt();
        }
    }

    // Handle key presses
    public void handleKeyPress(char key) {
        if (gameState.equals("playing")) {
            Cub cub = (Cub) sprites.find("cub");
            if (key == ' ') {
                if (cub != null && meat != null) {
                    float distance = dist(cub.X(), cub.Y(), meat.X(), meat.Y());
                    if (distance < 300) {
                        eatMeat(cub);
                    }
                }
            } else if (key == CODED) {
                int step = 3;
                switch (keyCode) {
                    case LEFT:
                        moveCub(-step, 0);
                        break;
                    case RIGHT:
                        moveCub(step, 0);
                        break;
                    case UP:
                        moveCub(0, -step);
                        break;
                    case DOWN:
                        moveCub(0, step);
                        break;
                }
            }
        } else if (gameState.equals("over")) {
            if (key == ' ') {
                setupGame(); // Restart the game
                gameState = "playing";
                gameStatus = "active";
            } else if (key == ESC) {
                exit(); // Exit the game
            }
        } else if (gameStatus.equals("won")) {
            if (key == ENTER) {
                setupGame(); // Restart the game after winning
                gameState = "playing";
                gameStatus = "active";
            }
        }
    }

    // Handle mouse clicks
    public void handleMouseClick() {
        if (gameState.equals("menu")) {
            if (mouseY > height/2 - 20 && mouseY < height/2 + 20) {
                gameState = "playing";
                setupGame();
            } else if (mouseY > height/2 + 40 && mouseY < height/2 + 80) {
                gameState = "howToPlay";
            }
        } else if (gameState.equals("howToPlay")) {
            if (mouseY > height - 80 && mouseY < height - 40) {
                gameState = "menu";
            }
        }
    }

    // Handle eating meat
    private void eatMeat(Cub cub) {
        if (meat != null && meat.isFresh()) {
            float distance = dist(cub.X(), cub.Y(), meat.X(), meat.Y());
            if (distance < 50) {
                healthManager.incrementLivesCounter();
                meat.eat();
                meatEaten = true;
                sprites.remove(meat);
            }
        }
    }

    // Set up meat
    private void setupMeat() {
        if (meatEaten || meat == null) {
            float newX = random(100, width - 100);
            float newY = height - 60;
            meat = new Meat("meat", "meat.png", false, false, "fresh");
            meat.set(newX, newY);
            meat.scale(0.15f);
            sprites.add(meat);
            meatEaten = false;
        }
    }

    // Display UI elements
    private void displayUI() {
        textFont(gameFont);
        textAlign(LEFT, TOP);
        fill(255);
        textSize(24);
        text("Level: " + currentLevel, width - 120, 20);
        text("Health: ", 20, 20);
        for (int i = 0; i < healthManager.getLiveCount(); i++) {
            image(heartIcon, 100 + (i * 30), 15, 25, 25);
        }
    }

    // Handle level completion
    private void levelComplete() {
        if (currentLevel < 3) {
            currentLevel++;
            bushDistance -= 15;
            gameStatus = "active";
            healthManager = new HealthManager("active", 3, "healthy");
            removeAllSprites();
            setupGame();
            // Reset cub position after setupGame
            Cub cub = (Cub) sprites.find("cub");
            if (cub != null) {
                cub.set(1, height/2);
            }
            displayLevelTransition();
        } else {
            gameStatus = "won";
            text("Congratulations!\nYou've completed all levels!", width / 2, height / 4);
        }
    }

    // Display level transition
    private void displayLevelTransition() {
        background(0, 150);
        textAlign(CENTER, CENTER);
        fill(255);
        textSize(64);
        text("Level " + currentLevel, width/2, height/2);
        textSize(32);
        text("Get ready!", width/2, height/2 + 60);
        isResetting = true;
        delay(2000);
    }

    // Display next level prompt
    private void displayNextLevelPrompt() {
        fill(0, 150);
        rect(0, 0, width, height);
        textAlign(CENTER, CENTER);
        textSize(48);
        fill(255, 200, 0);
        fill(0, 0, 0, 150);
        text("Press Enter to restart the Game", width / 2 + 2, height / 2 + 102);
        fill(255, 200, 0);
        text("Press Enter to restart the Game", width / 2, height / 2 + 100);
        float pulseSize = 4 * sin(millis() * 0.005f);
        textSize(48 + pulseSize);
        fill(255);
        text("Press Enter to restart the Game", width / 2, height / 2 + 100);
    }

    // Check for collisions
    public void checkCollision() {
        Cub cub = (Cub) sprites.find("cub");
        if (cub == null) return;

        for (Snake snake : snakes) {
            if (snake.snakeStatus.equals("active")) {
                if (isColliding(cub, snake)) {
                    healthManager.decrementLivesCounter();
                    resetLevel();
                    if (healthManager.getLiveCount() <= 0) {
                        gameOver();
                    } else {
                        delay(1000);
                    }
                    break;
                }
            }
        }

        Cave cave = (Cave) sprites.find("cave");
        if (cave != null) {
            //float distance = dist(cub.X(), cub.Y(), cave.X(), cave.Y());
            if (isCollidingCave(cub, cave)) {
                if (healthManager.getLiveCount() > 0) {
                    cave.isReached = true;
                    cave.caveStatus = "reached";
                    levelComplete();
                }
            }
            if (meat != null && isColliding(cub, meat)) {
                eatMeat(cub);
            }
        }
    }

    // Check if two sprites are colliding
    private boolean isColliding(Sprite A, Sprite B) {
        float currentWidth = max(A.X() + A.Width(), B.X() + B.Width()) - min(A.X(), B.X());
        float minWidth = A.Width() + B.Width();
        float currentHeight = max(A.Y() + A.Height(), B.Y() + B.Height()) - min(A.Y(), B.Y());
        float minHeight = A.Height() + B.Height();
        return (currentWidth <= minWidth) && (currentHeight <= minHeight);
    }
    
private boolean isCollidingCave(Sprite A, Sprite B) {
    float currentWidth = max(A.X() + A.Width(), B.X() + B.Width()) - min(A.X(), B.X());
    float minWidth = A.Width() + (B.Width() / 2); // Adjusted width for both A and B

    float currentHeight = max(A.Y() + A.Height(), B.Y() + B.Height()) - min(A.Y(), B.Y());
    float minHeight = (A.Height()) + (B.Height() / 2); // Adjusted height for both A and B

    return (currentWidth <= minWidth) && (currentHeight <= minHeight);
}

    // Reset the level
    private void resetLevel() {
        isResetting = true;
        resetStartTime = millis();
        Cub cub = (Cub) sprites.find("cub");
        cub.set(cub.X(), height/2);
        for (Snake snake : snakes) {
            snake.set(-50, -50);
            snake.snakeStatus = "inactive";
        }
        if (meatEaten) {
            sprites.remove(meat);
        }
        text("Get Ready!", width / 2, height / 4);
        if (healthManager.getLiveCount() > 0) {
            gameStatus = "active";
        } else {
            gameOver();
        }
    }

    // Set up the game
    public void setupGame() {
        healthManager = new HealthManager("active", 3, "healthy");
        gameStatus = "active";
        gameState = "playing";
        setupSprites();
        setupMeat();
        Cub cub = (Cub) sprites.find("cub");
        if (cub != null) {
            cub.set(5, height/2);
        }
        sprites.show();
        isResetting = true;
        resetStartTime = millis();
    }

    // Remove all sprites
    private void removeAllSprites() {
        Iterator<Sprite> iterator = sprites.iterator();
        while (iterator.hasNext()) {
            iterator.next();
            iterator.remove();
        }
        snakes = new ArrayList<>();
        bushes = new ArrayList<>();
        meat = null;
    }

    // Set up all sprites
    private void setupSprites() {
        background = loadImage("background.png");
        background.resize(925, 500);
        
        float centerY = height / 2;
        setupCave();
        setupCub();
        Cub cub = (Cub)sprites.find("cub");
        cub.set(1, height/2);
        
        Cave cave = (Cave)sprites.find("cave");
        cave.set(cave.X(), centerY);
        setupBushes();
        setupSnakes();
        setupMeat();
        if (meat != null) {
            meat.set(meat.X(), centerY);
        }
    }

    // Set up the cub
    private void setupCub() {
        Cub cub = new Cub("cub", "cub_run_right.png", "idle", false);
        cub.set(1, height/2);
        println("Setting up cub at position: " + cub.X() + ", " + cub.Y());
        cub.scale(0.15f);
        cub.makeSolid();
        sprites.add(cub);
    }

    // Set up bushes
    private void setupBushes() {
        for (Sprite bush : bushes) {
            sprites.remove(bush);
        }
        bushes = new ArrayList<>();
        int numBushes;
        switch (currentLevel) {
            case 1:
                numBushes = LEVEL_1_SNAKES;
                break;
            case 2:
                numBushes = LEVEL_2_SNAKES;
                break;
            case 3:
                numBushes = LEVEL_3_SNAKES;
                break;
            default:
                numBushes = LEVEL_1_SNAKES;
        }
        float startX = 150;
        for (int i = 0; i < numBushes; i++) {
            Sprite bush = new Sprite("bush" + i, "bush.png");
            bush.set(startX + i * bushDistance, 50);
            bush.scale(0.15f);
            bush.makeSolid();
            bush.makeFixed();
            sprites.add(bush);
            bushes.add(bush);
        }
    }
//setup cave
    private void setupCave() {
        Cave cave = new Cave("cave", "cave.png", false, "open");
        cave.set(width - 100, height - 100);
        cave.scale(0.20f);
        //cave.makeSolid();
        cave.makeFixed();
        sprites.add(cave);
    }
// setup snakes
    private void setupSnakes() {
        for (Snake snake : snakes) {
            sprites.remove(snake);
        }
        snakes = new ArrayList<>();
        int numSnakes;
        switch (currentLevel) {
            case 1:
                numSnakes = LEVEL_1_SNAKES;
                break;
            case 2:
                numSnakes = LEVEL_2_SNAKES;
                break;
            case 3:
                numSnakes = LEVEL_3_SNAKES;
                break;
            default:
                numSnakes = LEVEL_1_SNAKES;
        }
        float snakeSpeed = BASE_SNAKE_SPEED + (currentLevel - 1) * 0.3f;
        for (int i = 0; i < numSnakes; i++) {
            Snake snake = new Snake("snake" + i, "snake.png", false, true, "inactive");
            snake.set(-50, -50);
            snake.scale(0.11f);
            snake.velocity(0, snakeSpeed);
            sprites.add(snake);
            snakes.add(snake);
        }
    }
    

// updating snakes
    private void updateSnakes() {
        if (isResetting) {
            if (millis() - resetStartTime >= RESET_DELAY) {
                isResetting = false;
            }
            return;
        }
        for (int i = 0; i < snakes.size(); i++) {
            Snake snake = snakes.get(i);
            if (snake.snakeStatus.equals("active")) {
                snake.move(0, snake.vY);
                if (isSnakeAtEnd(snake.X(), snake.Y())) {
                    resetSnake(i);
                }
            } else if (snake.snakeStatus.equals("inactive")) {
                if (random(1) < spawnChance) {
          activateSnake(i);
        }
      }
    }
  }
// active snakes.
  private void activateSnake(int index) {
    if (index >= 0 && index < snakes.size()) {
      Snake snake = snakes.get(index);
      Sprite bush = sprites.find("bush" + index);
      snake.set(bush.X(), bush.Y() + 50);
      snake.snakeStatus = "active";
      snake.velocity(0, 1 + currentLevel * 0.5f);
    }
  }

  private void resetSnake(int index) {
    if (index >= 0 && index < snakes.size()) {
      Snake snake = snakes.get(index);
      snake.set(-50, -50); // Move off-screen
      snake.snakeStatus = "inactive";
    }
  }

  public void setupHealthManager() {
    healthManager = new HealthManager("active", 3, "healthy");
  }

  public PVector getMeatLocation() {
    return new PVector(meat.X(), meat.Y());
  }

  public PVector getCubLocation() {
    Cub cub = (Cub) sprites.find("cub");
    return new PVector(cub.X(), cub.Y());
  }

  public ArrayList<PVector> getSnakeLocation() {
    ArrayList<PVector> snakeLocations = new ArrayList<PVector>();
    for (Snake snake : snakes) {
      snakeLocations.add(new PVector(snake.X(), snake.Y()));
    }
    return snakeLocations;
  }



  public void moveCub(int pX, int pY) {
    Cub cub = (Cub) sprites.find("cub");
    
    // Calculate the new position after movement
    float newX = cub.X() + pX;
    float newY = cub.Y() + pY;

    // Check if the new position is within the bounds of the screen
    newX = constrain(newX, 0, width - cub.Width());
    newY = constrain(newY, 0, height - cub.Height());

    // Update the cub's position
    cub.set(newX, newY);
    cub.move(pX, pY);
    sprites.checkHorCollision(cub);
    sprites.checkVertCollision(cub);
  }

  public int getLiveCount() {
    return healthManager.liveCounter;
  }

  public String getHealthStatus() {
    return healthManager.healthStatus;
  }

  public void incrementLivesCounter() {
    healthManager.incrementLivesCounter();
  }

  public void decrementLivesCounter() {
    healthManager.decrementLivesCounter();
  }
  
public Boolean isSnakeAtEnd(float pX, float pY) {
    return pY > height;
 }
    private void gameOver() {
        gameStatus = "over";
        // Remove all sprites except the cub
        Iterator<Sprite> iterator = sprites.iterator();
        while (iterator.hasNext()) {
            Sprite sprite = iterator.next();
            if (!(sprite instanceof Cub)) {
                iterator.remove();
            }
        }
        // Reset health to 3 lives when restarting game
        healthManager = new HealthManager("active", 3, "healthy");
        currentLevel = 1; // Reset to level 1 when game is over
    }
  private void drawGameOver() {
    // Darken the background with a fade effect
    background(0, 180); // Slight transparency for a soft overlay effect

    // Settings for main "GAME OVER" text with fade-in effect
    textAlign(CENTER, CENTER);
    textSize(72);
    fill(255, 0, 0, 200 + 55 * sin(millis() * 0.005f));  // Red with pulsing fade
    text("GAME OVER", width / 2, height / 3);
    
    // Shadowed subtitle for added depth
    textSize(32);
    fill(0, 0, 0, 150);  // Shadow color with transparency
    text("Your journey has come to an end", width / 2 + 2, height / 2 + 2);
    fill(255);  // White for subtitle
    text("Your journey has come to an end", width / 2, height / 2);
    
    // Restart prompt with pulsing effect for emphasis
    textSize(24);
    fill(200 + 55 * sin(millis() * 0.01f));  // White with gentle pulse
    text("Press ESC to exit", width / 2, height * 2 / 3);
    
    // Display the cub in a defeated pose, slightly transparent and larger for focus
    Cub cub = (Cub) sprites.find("cub");
    if (cub != null) {
        cub.set(5, height/2);
        cub.scale(0.4f);  // Make the cub more prominent
        sprites.show();
    }
}

    
  public void regenerateSnake(int index) {
    if (index >= 0 && index < snakes.size()) {
      Snake snake = snakes.get(index);
      Sprite bush = sprites.find("bush" + index);
      snake.set(bush.X(), bush.Y() + 50);
      snake.velocity(0, 1 + currentLevel * 0.5f);
    }
  }

  private void checkGameOver() {
    if (healthManager.liveCounter <= 0) {
      gameOver();
    }
  }

  public String getGameStatus() {
    return gameStatus;
  }

  public void setGameStatus(String status) {
    this.gameStatus = status;
  }
}
