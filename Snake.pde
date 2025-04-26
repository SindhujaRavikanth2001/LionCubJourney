class Snake extends Sprite {
  // Unique identifier for the snake instance.
  int id;

  // Indicates the current location status of the snake (e.g., "present", "absent").
  boolean snakeLocation;

  // Indicates whether the snake has been generated or spawned.
  boolean snakeGenerated;

  // Stores the current status of the snake (e.g., "idle", "aggressive").
  String snakeStatus;

  // The speed at which the snake moves
  float speed;

  /**
   * Constructor for the Snake class.
   * @param sName Name of the snake sprite.
   * @param fName File name of the snake image.
   * @param snakeLocation Whether the snake is at a specific location.
   * @param snakeGenerated Whether the snake has been generated.
   * @param snakeStatus Current status of the snake.
   */
  private boolean active;
    
    // Update constructor
    Snake(String sName, String fName, boolean snakeLocation, boolean snakeGenerated, String snakeStatus) {
        super(sName, fName);
        this.id = (int)random(1000);
        this.snakeLocation = snakeLocation;
        this.snakeGenerated = snakeGenerated;
        this.snakeStatus = snakeStatus;
        this.speed = 2;
        this.active = false;
    }
    
    // Add methods to control snake state
    public void setActive(boolean active) {
        this.active = active;
    }
    
    public boolean isActive() {
        return active;
    }

  /**
   * Updates the snake's position based on its current speed.
   */
  void update() {
    move(0, speed);
  }

  /**
   * Sets the speed of the snake.
   * @param newSpeed The new speed to set.
   */
  void setSpeed(float newSpeed) {
    this.speed = newSpeed;
  }

  /**
   * Checks if the snake has reached the bottom of the screen.
   * @param screenHeight The height of the game screen.
   * @return true if the snake has reached the bottom, false otherwise.
   */
  boolean reachedBottom(float screenHeight) {
    return Y() > screenHeight;
  }

  /**
   * Resets the snake's position to the top of the screen at a random x-coordinate.
   * @param screenWidth The width of the game screen.
   */
  void resetPosition(float screenWidth) {
    set(random(screenWidth), 0);
    snakeLocation = true;
    snakeStatus = "active";
  }

  /**
   * Changes the snake's status to "aggressive" when near the cub.
   * @param cubX The x-coordinate of the cub.
   * @param cubY The y-coordinate of the cub.
   * @param aggroDistance The distance at which the snake becomes aggressive.
   */
  void checkAggro(float cubX, float cubY, float aggroDistance) {
    if (dist(X(), Y(), cubX, cubY) < aggroDistance) {
      snakeStatus = "aggressive";
    } else {
      snakeStatus = "idle";
    }
  }

  /**
   * Checks if the snake collides with the cub.
   * @param cub The Cub object to check collision with.
   * @return true if there's a collision, false otherwise.
   */
  boolean collidesWithCub(Cub cub) {
    return this.collidesWith(cub);
  }
}
