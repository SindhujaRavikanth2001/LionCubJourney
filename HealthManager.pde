class HealthManager {
  // Stores the current status of the health manager (e.g., "active", "paused").
  String status;

  // Tracks the number of lives remaining.
  int liveCounter;

  // Stores the current health status (e.g., "healthy", "injured").
  String healthStatus;

  // Maximum number of lives
  final int MAX_LIVES = 3;

  /**
   * Constructor for the HealthManager class.
   * @param status Current status of the health manager.
   * @param liveCounter Number of lives remaining.
   * @param healthStatus Current health status.
   */
  HealthManager(String status, int liveCounter, String healthStatus) {
    this.status = status;
    this.liveCounter = liveCounter;
    this.healthStatus = healthStatus;
    updateHealthStatus();
  }

  /**
   * Increments the lives counter if it's below the maximum.
   */
  void incrementLivesCounter() {
    if (liveCounter < MAX_LIVES) {
      liveCounter++;
      updateHealthStatus();
    }
  }

  /**
   * Decrements the lives counter and updates the health status.
   */
  void decrementLivesCounter() {
    if (liveCounter > 0) {
      liveCounter--;
      updateHealthStatus();
    }
  }

  /**
   * Updates the health status based on the current live count.
   */
  private void updateHealthStatus() {
    if (liveCounter == MAX_LIVES) {
      healthStatus = "healthy";
    } else if (liveCounter > 0) {
      healthStatus = "injured";
    } else {
      healthStatus = "dead";
      status = "inactive";
    }
  }

  /**
   * Returns the current number of lives.
   * @return The current live count.
   */
  int getLiveCount() {
    return liveCounter;
  }

  /**
   * Returns the current health status.
   * @return The current health status.
   */
  String getHealthStatus() {
    return healthStatus;
  }

  /**
   * Sets the status of the health manager.
   * @param newStatus The new status to set.
   */
  void setStatus(String newStatus) {
    this.status = newStatus;
  }

  /**
   * Resets the health manager to its initial state.
   */
  void reset() {
    liveCounter = MAX_LIVES;
    status = "active";
    updateHealthStatus();
  }

  /**
   * Checks if the player is still alive.
   * @return true if the player has lives remaining, false otherwise.
   */
  boolean isAlive() {
    return liveCounter > 0;
  }
}
