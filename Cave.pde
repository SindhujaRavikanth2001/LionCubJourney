class Cave extends Sprite {
  // Indicates whether the cave has been reached.
  boolean isReached;

  // Stores the current status of the cave (e.g., "open", "closed").
  String caveStatus;

  /**
   * Constructor for the Cave class.
   * @param sName Name of the cave sprite.
   * @param fName File name of the cave image.
   * @param isReached Whether the cave has been reached.
   * @param caveStatus Current status of the cave.
   */
  Cave(String sName, String fName, boolean isReached, String caveStatus) {
    super(sName, fName);
    this.isReached = isReached;
    this.caveStatus = caveStatus;
  }

  /**
   * Checks if the cub has reached the cave.
   * @param cub The Cub object to check against.
   */
  void checkReached(Cub cub) {
    if (this.collidesWith(cub)) {
      this.isReached = true;
      this.caveStatus = "reached";
    }
  }

  /**
   * Resets the cave's status for a new level.
   */
  void reset() {
    this.isReached = false;
    this.caveStatus = "open";
  }

  /**
   * Returns the current status of the cave.
   * @return The cave's status as a String.
   */
  String getStatus() {
    return this.caveStatus;
  }

  /**
   * Checks if the cave has been reached.
   * @return true if the cave has been reached, false otherwise.
   */
  boolean isReached() {
    return this.isReached;
  }
}
