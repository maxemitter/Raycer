class Equation {
    float slope, intercept;
    float startInterval, endInterval;
    boolean isVertical = false;
    
    Equation(Position startPos, Position endPos) {
        if(startPos.x == endPos.x) {
            isVertical = true;
            
            startInterval = min(startPos.y, endPos.y);
            endInterval = max(startPos.y, endPos.y);
        }
        else {
            Position smallerPos, biggerPos;
            
            if(startPos.x < endPos.x) {
                smallerPos = startPos;
                biggerPos = endPos;
            }
            else {
                smallerPos = endPos;
                biggerPos = startPos;
            }
            
            float deltaX = biggerPos.x - smallerPos.x;
            float deltaY = biggerPos.y - smallerPos.y;
            slope = deltaY / deltaX;
            
            intercept = smallerPos.y - slope * smallerPos.x;
            
            startInterval = smallerPos.x;
            endInterval = biggerPos.x;
        }
    }
}
