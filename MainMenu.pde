class Menu {
  // Current state of the menu
  String currentState;

  // Constructor
  Menu() {
    currentState = "MAIN";
  }

  // Display the appropriate menu based on the current state
  void display() {
    if (currentState.equals("MAIN")) {
      displayMainMenu();
    } else if (currentState.equals("INSTRUCTIONS")) {
      displayInstructions();
    }
  }

  // Display the main menu
  void displayMainMenu() {
    background(200);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Lion Cub's Journey", width/2, height/4);
    textSize(24);
    text("Press 'S' to Start", width/2, height/2);
    text("Press 'I' for Instructions", width/2, height/2 + 40);
    text("Press 'Q' to Quit", width/2, height/2 + 80);
  }

  // Display the instructions screen
  void displayInstructions() {
    background(200);
    textAlign(CENTER, CENTER);
    textSize(24);
    text("Instructions", width/2, height/4);
    textSize(16);
    text("Use arrow keys to move", width/2, height/2 - 40);
    text("Press SPACE to eat meat", width/2, height/2);
    text("Avoid snakes and reach the cave", width/2, height/2 + 40);
    text("Press 'B' to go back", width/2, height - 50);
  }

  // Handle user input for menu navigation
  void handleInput(char key) {
    if (currentState.equals("MAIN")) {
      if (key == 's' || key == 'S') {
        currentState = "GAME";
      } else if (key == 'i' || key == 'I') {
        currentState = "INSTRUCTIONS";
      } else if (key == 'q' || key == 'Q') {
        exit();
      }
    } else if (currentState.equals("INSTRUCTIONS")) {
      if (key == 'b' || key == 'B') {
        currentState = "MAIN";
      }
    }
  }

  // Getter for the current state
  String getState() {
    return currentState;
  }

  // Setter for the current state
  void setState(String state) {
    currentState = state;
  }
}
