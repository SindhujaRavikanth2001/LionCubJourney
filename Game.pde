
GameEngine gameEngine;

// Setup function, runs once at the start of the program
void setup() {
    // Set the size of the game window to 925x500 pixels
    size(925, 500);
    // Initialize the GameEngine with "active" status
    gameEngine = new GameEngine("active");
}

// Draw function, runs continuously in a loop
void draw() {
    // Call the drawGame method of the GameEngine to update and display the game
    gameEngine.drawGame();
}

// Event handler for key presses
void keyPressed() {
    // Pass the pressed key to the GameEngine's handleKeyPress method
    gameEngine.handleKeyPress(key);
}

// Event handler for mouse clicks
void mousePressed() {
    // Call the GameEngine's handleMouseClick method when the mouse is clicked
    gameEngine.handleMouseClick();
}
