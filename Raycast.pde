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
            line(mouseX + cos(radians) * 5, mouseY + sin(radians) * 5, mouseX + cos(radians) * 1000, mouseY + sin(radians) * 1000);
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
