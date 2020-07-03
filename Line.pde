class Line {
    Position startPos, endPos;
    
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
}
