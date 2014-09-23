function Rave(num, ctx) {
    var numGradients = 10;
    var numColors = 6;
    var cols = [];
    var w = window.innerWidth;
    var h = window.innerHeight;
    var dy = Math.floor(h / numGradients);
    
    var y = 0;
    for (i = 0; i < numGradients; i++) {
        for (j = 0; j < numColors; j++) {
            c1 = Math.floor(Math.random() * 255);
            c2 = Math.floor(Math.random() * 255);
            c3 = Math.floor(Math.random() * 255);
            cols[j] = String("rgb(" + c1 + "," + c2 + "," + c3 + ")");
        }
        
        ctx.beginPath()
        ctx.rect(0, y, w, dy);
        var grd = ctx.createLinearGradient(0, y, w, y + dy);
        
        var maxIndex = numColors - 1;
        for (k = 0; k < numColors; k++) {
                grd.addColorStop(k / maxIndex, cols[k]);
        }

        ctx.fillStyle = grd;
        ctx.fill();
        ctx.closePath();

        y += dy;
    }
}
