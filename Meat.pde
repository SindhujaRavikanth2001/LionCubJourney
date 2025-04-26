class Meat extends Sprite {
  // Unique identifier for the meat instance.
  int id;

  // Indicates whether the meat has been reached.
  boolean isReached;

  // Indicates whether the meat has been eaten.
  boolean isEaten;

  // Stores the current status of the meat (e.g., "fresh", "rotten").
  String meatStatus;

  /**
   * Constructor for the Meat class.
   * @param sName Name of the meat sprite.
   * @param fName File name of the meat image.
   * @param isReached Whether the meat has been reached.
   * @param isEaten Whether the meat has been eaten.
   * @param meatStatus Current status of the meat.
   */
  Meat(String sName, String fName, boolean isReached, boolean isEaten, String meatStatus) {
    super(sName, fName);
    this.id = (int)random(1000); // Generate a random ID
    this.isReached = isReached;
    this.isEaten = isEaten;
    this.meatStatus = meatStatus;
  }

  /**
   * Resets the meat's position and status.
   */
  void reset() {
    this.set(random(width), 440); // Place meat at a random x-position at y=440
    this.isReached = false;
    this.isEaten = false;
    this.meatStatus = "fresh";
  }

  /**
   * Marks the meat as eaten.
   */
  void eat() {
    this.isEaten = true;
    this.meatStatus = "eaten";
  }

  /**
   * Checks if the meat is fresh and available to be eaten.
   * @return true if the meat is fresh and not eaten, false otherwise.
   */
  boolean isFresh() {
    return !isEaten && meatStatus.equals("fresh");
  }

  /**
   * Updates the meat's status based on game conditions.
   * This method can be expanded to include time-based rotting or other mechanics.
   */
  void updateStatus() {
    if (isEaten) {
      meatStatus = "eaten";
    } else if (isReached && !isEaten) {
      meatStatus = "reached";
    }
  }
}
