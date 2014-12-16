function MeasureText(num, ctx) {
    for (i = 0; i < 100; i++) {
        x = Math.floor(Math.random() * canvas.width);
        y = Math.floor(Math.random() * canvas.height);
        w = Math.random().toString(36).replace(/[^a-z]+/g, '').substring(0,4);
        
        ctx.fillStyle = "black";
        ctx.font = "10pt Calibri";
        ctx.fillText(w, x, y);
        ctx.measureText(w);
    }
}
