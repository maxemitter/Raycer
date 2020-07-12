static enum Mode {
    LineDraw,
    CircleDraw,
    Cast;
    
    static Mode[] values = values();
    Mode next() {
        return values[(this.ordinal() + 1) % values.length];
    }
}
