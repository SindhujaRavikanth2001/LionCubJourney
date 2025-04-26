class Cub extends Sprite {
  // Stores the current status of the cub (e.g., "idle", "moving").
  String cubStatus;

  // Indicates whether the cub has moved.
  boolean cubMoved;

  // The cub's current health
  int health;

  // The maximum health of the cub
  final int MAX_HEALTH = 3;

  /**
   * Constructor for the Cub class.
   * @param sName Name of the cub sprite.
   * @param fName File name of the cub image.
   * @param cubStatus Current status of the cub.
   * @param cubMoved Whether the cub has moved.
   */
  Cub(String sName, String fName, String cubStatus, boolean cubMoved) {
    super(sName, fName);
    this.cubStatus = cubStatus;
    this.cubMoved = cubMoved;
    this.health = MAX_HEALTH;
  }

  /**
   * Moves the cub in the specified direction.
   * @param dx Change in x-coordinate.
   * @param dy Change in y-coordinate.
   */
  @Override
  void move(float dx, float dy) {
    super.move(dx, dy);
    cubMoved = true;
    cubStatus = "moving";
  }

  /**
   * Resets the cub's position to the starting point.
   */
  void resetPosition() {
    set(20, height/2);
    cubStatus = "idle";
    cubMoved = false;
  }

  /**
   * Decreases the cub's health by 1.
   */
  void decreaseHealth() {
    if (health > 0) {
      health--;
    }
    updateStatus();
  }

  /**
   * Increases the cub's health by 1, up to the maximum.
   */
  void increaseHealth() {
    if (health < MAX_HEALTH) {
      health++;
    }
    updateStatus();
  }

  /**
   * Updates the cub's status based on its health.
   */
  private void updateStatus() {
    if (health == MAX_HEALTH) {
      cubStatus = "healthy";
    } else if (health > 0) {
      cubStatus = "injured";
    } else {
      cubStatus = "dead";
    }
  }

  /**
   * Checks if the cub is still alive.
   * @return true if the cub has health remaining, false otherwise.
   */
  boolean isAlive() {
    return health > 0;
  }

  /**
   * Gets the current health of the cub.
   * @return The current health value.
   */
  int getHealth() {
    return health;
  }

  /**
   * Gets the current status of the cub.
   * @return The current status.
   */
  String getStatus() {
    return cubStatus;
  }
}
