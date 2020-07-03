ArrayList<Line> lines;
Line currentLine;

void settings() {
    size(800, 800);
}

void setup() {
    frameRate(60);
    lines = new ArrayList<Line>();
}

void draw() {
    background(255);
    
    for(Line line : lines) {
        line.draw();
    }
    
    if(currentLine != null) {
        currentLine.draw();
    }
}

void mousePressed() {
    if(currentLine == null) {
        currentLine = new Line(new Position(mouseX, mouseY));
    }
    else {
        Position currentPos = new Position(mouseX, mouseY);
        
        if(!currentLine.startPos.equals(currentPos)) {
            currentLine.endPos = currentPos;
            lines.add(currentLine);
        }
        currentLine = null;
    }
}
