class Sprite {
  PImage img;
  float pX, pY, aX, aY, vX, vY, oX, oY, step;
  Boolean gravity, solid, fixed;
  String name, colName;

  // Constructor
  Sprite(String sName, String fName) {
    name = sName;
    img = loadImage(fName);
    if (img == null) {
        println("Failed to load image: " + fName);
    } else {
        println("Loaded image: " + fName + " with dimensions " + img.width + "x" + img.height);
    }
    colName = "";
    pX = pY = oX = oY = 0;
    aX = aY = vX = vY = 0;
    gravity = solid = fixed = false;
    step = 10;
  }

  // Display the sprite
  void show() {
    image(img, pX, pY);
  }

  // Set the position of the sprite
  void set(float nX, float nY) {
    pX = nX;
    pY = nY;
  }

  // Move the sprite by a given amount
  void move(float dX, float dY) {
    oX = pX;
    oY = pY;
    pX += dX;
    pY += dY;
  }
 

  // Set the velocity of the sprite
  void velocity(float newVelX, float newVelY) {
    vX = newVelX;
    vY = newVelY;
  }


  // Update the sprite's position based on velocity and gravity
  void advance() {
    if (gravity) {
      oY = pY;
      aY = 0.05f;
      vY += aY;
    }
    pY += vY;
    pX += vX;
  }
  
  // Scale the sprite's image
  void scale(float factor) {
    if (img == null) {
        println("Cannot scale: image is null for sprite " + name);
        return;
    }
    if (factor <= 0) {
        println("Invalid scale factor: " + factor + " for sprite " + name);
        return;
    }
    int newWidth = Math.max(1, (int) (img.width * factor));
    int newHeight = Math.max(1, (int) (img.height * factor));
    println("Resizing sprite " + name + " from " + img.width + "x" + img.height + " to " + newWidth + "x" + newHeight);
    img.resize(newWidth, newHeight);
  }

  // Revert horizontal movement
  void hBackup() {
    pX = oX;
    vX = 0;
  }

  // Revert vertical movement
  void vBackup() {
    pY = oY;
    vY = 0;
  }

  // Getters
  float X() { return pX; }
  float Y() { return pY; }
  int Width() { return img.width; }
  int Height() { return img.height; }
  String Name() { return name; }

  // Toggle gravity effect
  void flipGravity() { gravity = !gravity; }
  // Make the sprite solid (for collision detection)
  void makeSolid() { solid = true; }
  // Make the sprite fixed (immovable)
  void makeFixed() { fixed = true; }

  // Check for collision with another sprite
  Boolean checkCollision(Sprite B, boolean isVertical) {
    float currentWidth = max(pX + Width(), B.X() + B.Width()) - min(pX, B.X());
    float currentHeight = max(pY + Height(), B.Y() + B.Height()) - min(pY, B.Y());
    float minWidth = Width() + B.Width();
    float minHeight = Height() + B.Height();

    if (isVertical) {
        minHeight -= vY;
        return (currentHeight >= minHeight) && (currentWidth <= minWidth);
    } else {
        float stepWidth = step;
        boolean collision = (currentHeight <= minHeight) && 
                            (currentWidth >= minWidth - stepWidth) && 
                            (currentWidth <= minWidth + stepWidth);
        if (collision) {
            colName = B.name;
        }
        return collision;
    }
  }

  // Check for vertical collision
  Boolean checkVertCollision(Sprite B) {
    return checkCollision(B, true);
  }

  // Check for horizontal collision
  Boolean checkHorCollision(Sprite B) {
    return checkCollision(B, false);
  }

  // Check if this sprite collides with another sprite
  boolean collidesWith(Sprite other) {
    float currentWidth = max(this.X() + this.Width(), other.X() + other.Width()) - min(this.X(), other.X());
    float minWidth = this.Width() + other.Width();
    float currentHeight = max(this.Y() + this.Height(), other.Y() + other.Height()) - min(this.Y(), other.Y());
    float minHeight = this.Height() + other.Height();

    return (currentWidth <= minWidth) && (currentHeight <= minHeight);
  }
}

import java.util.ArrayList;
import java.util.Iterator;

class Sprites implements Iterable<Sprite> {
  ArrayList<Sprite> sprites;

  // Constructor
  Sprites() {
    sprites = new ArrayList<>();
  }

  // Add a sprite to the collection
  void add(Sprite newSprite) {
    sprites.add(newSprite);
  }

  // Remove a sprite from the collection
  void remove(Sprite spriteToRemove) {
    sprites.remove(spriteToRemove);
  }

  // Update all sprites' positions and check for vertical collisions
  void advance() {
    for (Sprite spr : sprites) {
      spr.advance();
      if (checkVertCollision(spr)) {
        spr.vBackup();
      }
    }
  }

  // Check for vertical collisions for a given sprite
  Boolean checkVertCollision(Sprite spr) {
    if (spr.solid && !spr.fixed) {
        for (Sprite spr2 : sprites) {
            if (spr != spr2 && spr2.solid && spr.checkVertCollision(spr2)) {
                spr.vBackup();
                return true;
            }
        }
    }
    return false;
  }

  // Check for horizontal collisions for a given sprite
  Boolean checkHorCollision(Sprite spr) {
    spr.colName = "";
    if (spr.solid && !spr.fixed) {
        for (Sprite spr2 : sprites) {
            if (spr != spr2 && spr2.solid && spr.checkHorCollision(spr2)) {
                spr.hBackup();
                return true;
            }
        }
    }
    return false;
  }
  



  // Display all sprites
  void show() {
    for (Sprite spr : sprites) {
      spr.show();
    }
  }

  // Find a sprite by name
  Sprite find(String sName) {
    for (Sprite spr : sprites) {
      if (spr.Name().equals(sName)) {
        return spr;
      }
    }
    return null;
  }

  // Implement iterator() to make Sprites iterable
  @Override
  public Iterator<Sprite> iterator() {
    return sprites.iterator();
  }
}
