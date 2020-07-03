class Line {
    Position startPos, endPos;
    Equation equation;
    
    Line(Position startPos) {
        this.startPos = startPos;
    }
    
    void draw() {
        if(endPos != null) {
            line(startPos.x, startPos.y, endPos.x, endPos.y);
        }
        else {
            line(startPos.x, startPos.y, mouseX, mouseY);
        }
    }
    
    void setEndPos(Position endPos) {
        this.endPos = endPos;
        equation = new Equation(startPos, endPos);
    }
}
