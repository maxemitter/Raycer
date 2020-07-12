class Circle {
    Position pos;
    float radius;
    
    Circle(Position pos) {
        this.pos = pos;
    }
    
    void draw() {
        if(radius == 0) {
            float currentRadius = getDistanceToMouse();
            ellipse(pos.x, pos.y, currentRadius, currentRadius);
        }
        else {
            ellipse(pos.x, pos.y, radius, radius);
        }
    }
    
    float getDistanceToMouse() {
        return (float) Math.sqrt(Math.pow(pos.x - mouseX, 2) + Math.pow(pos.y - mouseY, 2));
    }
}
