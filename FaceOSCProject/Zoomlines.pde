class ZoomLine {
  Position start;
  Position lineLoc;
  Position lineEnd;
  Position goal;
  
  Position body;
  Position velocity;
  
  float lineLength;
  float angle;
  
  boolean moving;
  
  float noiseStart = random(100);
  float noiseChange = .007;
  
  float speed;
  
  float offSetX;
  float offSetY;

  float startOffX;
  float startOffY;
  
  int faceIndex;
  int posIndex;
  
  int index;
  
  float radius;
  float points;
  
  float partWidth;
  float partHeight;
  
  float bodyPart;
  
  int rot;
  
  ArrayList<Position> posList;
  
  ZoomLine(float startX, float startY, float goalX, float goalY, int points) {
    
    this.start = new Position(startX, startY);
    this.goal = new Position(goalX, goalY);
    
    this.speed = 5;
   
    this.lineLoc = new Position(startX, startY);
    
    this.index = 0;
    
    if (random(1) < .5) {
      this.rot = -1;
    } else {
      this.rot = 1;
    }
   
    this.points = points;
    
    this.bodyPart = (int)random(4);
    
    findBody();
    
    makePosList();
    updateAngle();
    updateLength();
    updateLineEnd();
    
    float largest = max(width,height) / poseScale;
    this.offSetX = random(-largest * .01,largest * .01);
    this.offSetY = random(-largest * .01,largest * .01);
  }
  
  //Finds a body to float around
  void findBody() {
    //Left Eye
    if (this.bodyPart == 0) { 
      this.radius = 20;
      this.partWidth = 20;
      this.partHeight = 10;
      this.body = new Position(-25, eyeLeft * -9);
    }
    // Right Eye 
    else if (this.bodyPart == 1) {
      this.radius = 20;
      this.partWidth = 20;
      this.partHeight = 10;
      this.body = new Position(25, eyeRight * -9);
    } 
    //Nose
    else if (this.bodyPart == 2) {
      this.radius = 10;
      this.partWidth = 10;
      this.partHeight = 7;
      this.body = new Position(0,nostrils * -1);
    } 
    // Mouth
    else {
      this.radius = mouthWidth * 2;
      this.partWidth = mouthWidth * 2;
      this.partHeight = mouthHeight * 2;
      this.body = new Position(0, 20);
    }
  }
  
  //Creates a list of positions around a given point (goalX and Y in this case)
  void makePosList(){
    this.posList = new ArrayList<Position>();
    float w = this.partWidth;
    float h = this.partHeight;
    for (int i = 0; i < this.points; i++) {
        float theta = i * (6.28 / this.points );
        this.posList.add(new Position(this.body.x + (w * cos(theta)), this.body.y + (h * sin(theta)) ) );
    }
  }
  
  //Updates speed of the line based on distance to the target position.   
  void updateSpeed() {
    float distance = dist(this.goal.x, this.goal.y,
                          this.start.x, this.start.y);
    this.speed = distance / this.lineLength;
  }
      
  //Updates the angle between the goal and lineLoc.
  void updateAngle() {
    float dx = this.goal.x - this.lineLoc.x;
    float dy = this.goal.y - this.lineLoc.y;
    
    this.angle = atan2(dy,dx);
  }
  
  //Semi randomly determines length based on the start, goal and a noise value. 
  void updateLength() {
    float distance = dist(this.goal.x, this.goal.y,
                          this.start.x, this.start.y);
    
    this.noiseStart += this.noiseChange;
    
    this.lineLength = (distance * .4) * .5;
  }
  
  //Updates the end position of the line bases on the angle between the location and goal
  //as well as the length of the line. 
  void updateLineEnd() {
    float yChange = sin(this.angle) * this.lineLength;
    float xChange = cos(this.angle) * this.lineLength;
    this.lineEnd = new Position(this.lineLoc.x + xChange, this.lineLoc.y + yChange);
  }
  
  //Draws the line on the screen. 
  void drawMe() {
    strokeWeight(4);
    line(this.lineLoc.x + offSetX, this.lineLoc.y + offSetY, 
         this.lineEnd.x + offSetX, this.lineEnd.y + offSetY);
  } 
  
  //Updates goal position.
  void updateGoal() {
    this.goal = this.posList.get(this.index);    
  }
  
  //Updates all variables for movement and drawing. 
  void update() {
    this.findBody();
    this.makePosList();
    this.updateGoal();
    this.updateAngle();
    this.updateLineEnd();
    this.move();
  }
  
  //Moves line between lineLoc and goal. Resets Line if it hits goal.
  void move() {
    float distance = dist(this.lineLoc.x,this.lineLoc.y,this.goal.x, this.goal.y);
    this.lineLoc.x += this.speed*((this.goal.x - this.lineLoc.x)/distance);
    this.lineLoc.y += this.speed*((this.goal.y - this.lineLoc.y) / distance);
    
    if (dist(this.lineLoc.x, this.lineLoc.y,this.goal.x, this.goal.y) <= (width * .02)) {
          this.index = abs(this.index + 1) % (int)this.points;
          this.start.x = this.goal.x;
          this.start.y = this.goal.y;
          this.updateGoal();
          this.updateLength();
          this.updateSpeed();

    }
  }
}

//Returns a position vector with the input x, y.
class Position {
    float x;
    float y;
    Position(float x, float y) {
      this.x = x;
      this.y = y;
    }
}

//Returns a random Position in a rectangle drawn from startX, startY, to endX, endY.
class RandomPosition extends Position {
      RandomPosition(float startX, float endX, float startY, float endY) {
      super(random(startX, endX),random(startY, endY));
    }
}


