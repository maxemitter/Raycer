class Position {
    float x, y;
    
    Position(float x, float y) {
        this.x = x;
        this.y = y;
    }
    
    boolean equals(float x, float y) {
        return this.x == x && this.y == y;
    }
    
    boolean equals(Position pos) {
        return pos.x == x && pos.y == y;
    }
}
