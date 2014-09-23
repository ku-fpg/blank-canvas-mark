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
            var c = '#'+Math.floor(Math.random()*16777215).toString(16);
            cols[j] = c;
        }
        
        ctx.beginPath()
        ctx.rect(0, y, w, y + dy);
        var grd = ctx.createLinearGradient(0, y, w, y + dy);
        for (k = 0; k < numColors; k++) {
            if (i % 2 == 0) {
                grd.addColorStop(0, '#8ED6FF');
                grd.addColorStop(1, '#004CB3');
            } else {
                grd.addColorStop(0, '#004CB3');
                grd.addColorStop(1, '#8ED6FF');
            }
        }
        ctx.fillStyle = grd;
        ctx.fill();
        ctx.closePath();

        y += dy;
    }
}
