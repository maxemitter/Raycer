class Position {
    int x, y;
    
    Position(int x, int y) {
        this.x = x;
        this.y = y;
    }
    
    boolean equals(int x, int y) {
        return this.x == x && this.y == y;
    }
    
    boolean equals(Position pos) {
        return pos.x == x && pos.y == y;
    }
}
