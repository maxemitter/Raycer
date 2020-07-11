Line currentLine;
ArrayList<Line> lines;
boolean drawMode;

void settings() {
    size(800, 800);
}

void setup() {
    frameRate(60);
    lines = new ArrayList<Line>();
    drawMode = true;
}

void draw() {
    background(255);
    
    for(Line line : lines) {
        line.draw();
    }
    
    if(drawMode) {
        if(currentLine != null) {
            currentLine.draw();
        }
    }
    else {
        for(float radians = 0; radians < 2 * PI; radians += 0.1) {
            Line current = new Line(new Position(mouseX + cos(radians) * 5, mouseY + sin(radians) * 5), 
                                    new Position(mouseX + cos(radians) * 2000, mouseY + sin(radians) * 2000));
            cast(current);
            line(current.startPos.x, current.startPos.y, current.endPos.x, current.endPos.y);
        }
    }
}

void mousePressed() {
    if(drawMode) {
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
    }
}

void keyPressed() {
    switch(key) {
        case ESC:
            if(currentLine != null) {
                currentLine = null;
                key = 0;
            }
        break;
        case ' ':
            drawMode = !drawMode;
            if(currentLine != null) {
                currentLine = null;
            }
        break;
    }
}

void cast(Line castedLine) {
    float intersection;
    for(Line line : lines) {
        intersection = calculateIntersection(castedLine, line);
        if(intersection != -1) {
            castedLine.setEndPos(new Position(intersection, castedLine.equation.calculateYAt(intersection)));
        }
    }
}

float calculateIntersection(Line one, Line two) {
    //If one of the lines is vertical
    if(one.equation.isVertical) {
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
    
    //If it is not a special case and intersections have to be calculated
    float x = (two.equation.intercept - one.equation.intercept) / (one.equation.slope - two.equation.slope);
    if(one.equation.isInInterval(x) && two.equation.isInInterval(x)) {
        return x;
    }
    return -1;
}
