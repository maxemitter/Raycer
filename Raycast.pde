Line currentLine;
Circle currentCircle;
ArrayList<Line> lines;
ArrayList<Circle> circles;
Mode mode;

void settings() {
    size(800, 800);
}

void setup() {
    frameRate(60);
    lines = new ArrayList<Line>();
    circles = new ArrayList<Circle>();
    mode = Mode.LineDraw;
    ellipseMode(RADIUS);
}

void draw() {
    background(255);
    
    fill(0);
    text("Mode: " + mode, 10, 10);
    noFill();
    
    for(Line line : lines) {
        line.draw();
    }
    
    for(Circle circle : circles) {
        circle.draw();
    }
    
    switch(mode) {
        case LineDraw:
            if(currentLine != null) {
                currentLine.draw();
            }
        break;
        case CircleDraw:
            if(currentCircle != null) {
                currentCircle.draw();
            }
        break;
        case Cast:
            for(float radians = 0; radians < 2 * PI; radians += 0.1) {
                Line current = new Line(new Position(mouseX + cos(radians) * 5, mouseY + sin(radians) * 5), 
                                        new Position(mouseX + cos(radians) * 2000, mouseY + sin(radians) * 2000));
                cast(current);
                line(current.startPos.x, current.startPos.y, current.endPos.x, current.endPos.y);
            }
        break;
    }
}

void mousePressed() {
    switch(mode) {
        case LineDraw:
            if(currentLine == null) {
                currentLine = new Line(new Position(mouseX, mouseY));
            }
            else {
                Position currentPos = new Position(mouseX, mouseY);
                
                if(!currentLine.startPos.equals(currentPos)) {
                    currentLine.setEndPos(currentPos);
                    lines.add(currentLine);
                }
                currentLine = null;
            }
        break;
        case CircleDraw:
            if(currentCircle == null) {
                currentCircle = new Circle(new Position(mouseX, mouseY));
            }
            else {
                float radius = currentCircle.getDistanceToMouse();
                
                if(radius != 0) {
                    currentCircle.radius = radius;
                    circles.add(currentCircle);
                }
                
                currentCircle = null;
            }
        break;
    }
}

void keyPressed() {
    switch(key) {
        case ESC:
            if(currentLine != null || currentCircle != null) {
                currentLine = null;
                currentCircle = null;
                key = 0;
            }
        break;
        case ' ':
            mode = mode.next();
            currentLine = null;
            currentCircle = null;
        break;
    }
}

void cast(Line castedLine) {
    float intersection;
    for(Line line : lines) {
        intersection = calculateLineIntersection(castedLine, line);
        if(intersection != -1) {
            castedLine.setEndPos(new Position(intersection, castedLine.equation.calculateYAt(intersection)));
        }
    }
    
    for(Circle circle : circles) {
        intersection = calculateCircleIntersection(castedLine, circle);
        if(intersection != -1) {
            castedLine.setEndPos(new Position(intersection, castedLine.equation.calculateYAt(intersection)));
        }
    }
}

float calculateLineIntersection(Line one, Line two) {
    //If one of the lines is vertical
    if(one.equation.isVertical) { //<>//
        float y = two.equation.calculateYAt(one.equation.horizontalPosition);
        if(one.equation.isInInterval(y) && two.equation.isInInterval(one.equation.horizontalPosition)) {
            return one.equation.horizontalPosition;
        }
        return -1;
    }
    else if(two.equation.isVertical) {
        float y = one.equation.calculateYAt(two.equation.horizontalPosition);
        if(two.equation.isInInterval(y) && one.equation.isInInterval(two.equation.horizontalPosition)) {
            return two.equation.horizontalPosition;
        }
        return -1;
    }
    
    //If one of the lines ends before the other starts
    if(one.equation.startInterval > two.equation.endInterval || one.equation.endInterval < two.equation.startInterval) {
        return -1;
    }
    
    //If the lines are parallel
    //This is the only time where it is important that one is the casted line and two is the static line
    //It is important because we need to know which direction the line is coming from to calculate the *first* intersection
    if(isApproxEqual(one.equation.slope, two.equation.slope)) {
        if(isApproxEqual(one.equation.intercept, two.equation.intercept)) {
            if(two.equation.startInterval < one.endPos.x) {
                return max(two.equation.startInterval, one.startPos.x);
            }
            return min(two.equation.endInterval, one.startPos.x);
        }
        return -1;
    }
    
    //If it is not a special case and intersections have to be calculated
    float x = (two.equation.intercept - one.equation.intercept) / (one.equation.slope - two.equation.slope);
    if(one.equation.isInInterval(x) && two.equation.isInInterval(x)) {
        return x;
    }
    return -1;
}

float calculateCircleIntersection(Line line, Circle circle) {
    //If the line is vertical we check whether the line is in the circle
    if(line.equation.isVertical) {
        float distance = abs(line.equation.horizontalPosition - circle.pos.x);
        if(distance > circle.radius) {
            return -1;
        }
        else if(distance < circle.radius) {
            float yDiff = sqrt(circle.radius * circle.radius - line.equation.horizontalPosition * line.equation.horizontalPosition);
            float upperY = circle.pos.y + yDiff;
            float lowerY = circle.pos.y - yDiff;
            
            return getCloserToStart(line, upperY, lowerY);
        }
        else {
            return line.equation.horizontalPosition;
        }
    }
    
    //Coefficients for the quadratic equation
    float a = + 1 
              + line.equation.slope * line.equation.slope;
    float b = - 2 * circle.pos.x 
              + 2 * line.equation.intercept * line.equation.slope 
              - 2 * line.equation.slope * circle.pos.y;
    float c = + circle.pos.x * circle.pos.x 
              + line.equation.intercept * line.equation.intercept 
              - 2 * line.equation.intercept * circle.pos.y
              + circle.pos.y * circle.pos.y
              - circle.radius * circle.radius;
    
    //The discriminant to check for the amount of intersections (>0 for 2, 0 for 1 and <0 for none) 
    float discriminant = b * b - 4 * a * c;
    
    if(discriminant > 0) {
        float xOne = (-b + sqrt(discriminant)) / (2 * a);
        float xTwo = (-b - sqrt(discriminant)) / (2 * a);
        
        return getCloserToStart(line, xOne, xTwo);
    }
    else if(discriminant < 0) {
        return -1;
    }
    else {
        return -b / (2 * a);
    }
}

float getCloserToStart(Line line, float one, float two) {
    if(line.equation.isInInterval(one) && line.equation.isInInterval(two)) {
        if(abs(one - line.startPos.x) < abs(two - line.startPos.x)) {
            return one;
        }
        else {
            return two;
        }
    }
    else if(line.equation.isInInterval(one)) {
        return one;
    }
    else if(line.equation.isInInterval(two)) {
        return two;
    }
    else {
        return -1;
    }
}

boolean isApproxEqual(float one, float two) {
    return round(one * 1000) == round(two * 1000);
}
