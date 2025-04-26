# Lion Cub's Journey - Adventure Game

A top-down 2D survival game where players guide a young lion cub back to its cave, overcoming dangers and restoring health by collecting meat while avoiding snakes.

## ✨ Project Overview

- **Goal**: Navigate the lion cub safely through levels filled with predators.
- **Scope**: 3 progressive levels with increasing difficulty, health management, collision detection, survival mechanics.
- **Team**: The Roaring Pride (Sindhuja Ravikanth, Shanmukha Chowdary Nalla, Bashir Dahir, Akhil Sai Baru)

## 🌐 Features

- Character movement via arrow keys.
- Health system with collectible meat to restore lost lives.
- Random meat placement and snake spawn mechanics.
- Three progressively challenging levels.
- User Interface including main menu, instructions screen, HUD, and game-over screen.
- Collision detection and boundary restriction.

## 📅 Technologies Used

- **Game Engine**: Processing (version 4.3)
- **Programming Language**: Java (Processing framework)
- **Graphics**: 2D Sprites

## 📖 Gameplay Mechanics

- ▶️ **Movement**: Move the lion cub up, down, left, right using arrow keys.
- 💛 **Health Management**:
  - 3 starting lives.
  - Lose life on snake collision.
  - Gain life on collecting meat (up to 3 lives).
- 🐢 **Enemy Behavior**: Snakes spawn from bushes and pursue paths.
- 🔹 **Level Progression**:
  - Level 1: 3 bushes, slower snakes.
  - Level 2: 4 bushes, moderate difficulty.
  - Level 3: 5 bushes, faster snakes.
- 📅 **Win Condition**: Reach the cave safely to complete each level.
- 🚫 **Game Over**: All lives lost results in a game over screen.

## 📊 Project Structure

```
LionCubsJourney/
├── Source Code (Processing PDE files)
├── Assets (Sprites, backgrounds)
├── Documentation
│   ├── Final Report
│   └── Test Cases
├── Deliverables (Prototype stages)
└── README.md
```

## 🔢 Setup Instructions

1. **Download and install Processing (version 4.3)**
   - [https://processing.org/download/](https://processing.org/download/)

2. **Clone the Repository**
   ```bash
   git clone <your-repo-url>
   ```

3. **Open Project**
   - Open `.pde` files in Processing IDE.
   - Run the project.

## 🏋️ Testing

- **Static Testing**: Verified correct logic for movement, collision, health management, game over handling.
- **Dynamic Testing**: Executed test cases ensuring correct functionality:
  - Movement in all directions.
  - Health decreases on collision.
  - Health restoration on collecting meat.
  - Level transitions upon reaching the cave.
  - Proper display of win and game-over screens.

## 🌍 Future Enhancements

- Multiplayer mode.
- Expanded environments (savannahs, rivers).
- Story-driven cutscenes.
- Improved difficulty balancing.
- Performance optimization synced with clock rate.
