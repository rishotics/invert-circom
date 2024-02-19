pragma circom 2.1.2;

// include "utils/comparators.circom";
template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}

template LessThan(n) {
    assert(n <= 252);
    signal input in[2];
    signal output out;

    component n2b = Num2Bits(n+1);

    n2b.in <== in[0]+ (1<<n) - in[1];

    out <== 1-n2b.out[n];
}

// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";


template DecBrightness(h, w) {

    signal input orig[h][w];

    signal output out_img[h][w];

    component ifLessFive[h][w];

    for (var i=0; i< h; i++){
        for (var j=0; j<w; j++){
            ifLessFive[i][j] = LessThan(8);
            ifLessFive[i][j].in[0] <== orig[i][j];
            ifLessFive[i][j].in[1] <== 5;
            out_img[i][j] <== 0*ifLessFive[i][j].out + (orig[i][j] - 5)*(1-ifLessFive[i][j].out);
        }
    }
}

template IncBrightness(h, w) {

    signal input orig[h][w];

    signal output out_img[h][w];

    
        for (var i=0; i< h; i++){
            for (var j=0; j<w; j++){
                out_img[i][j] <== orig[i][j] + 5; 
            }
        }
    

}

template Transpose(h, w) {

    signal input orig[h][w];

    signal output out_img[h][w];

    signal temp[h][w];

        for (var i=0; i< h; i++){
            for (var j=i; j<w; j++){
                temp[i][j] <== orig[j][i];
                out_img[j][i] <== orig[i][j]; 
                out_img[i][j] <== temp[i][j];
            }
        }
}


template Invert(h, w) {

    signal input orig[h][w];

    signal output out_img[h][w];

    
    for (var i=0; i< h; i++){
        for (var j=0; j<w; j++){
//              new_mat[j][n - i - 1] = mat[i][j];
            out_img[j][h - i -1] <== orig[i][j]; 
        }
    }
}

template EditImage(h, w) {

    signal input orig[h][w];
    signal input option;

    assert(option < 3);

    signal output out_img[h][w];

    component dec = DecBrightness(h, w);
    component inc = IncBrightness(h, w);
    component inv = Invert(h, w);

    for (var i=0; i< h; i++){
        for (var j=0; j<w; j++){
            dec.orig[i][j] <== orig[i][j];
            inc.orig[i][j] <== orig[i][j];
            inv.orig[i][j] <== orig[i][j];
        }
    }

   signal temp[h][w][3];

    for (var i=0; i< h; i++){
        for (var j=0; j<w; j++){

            temp[i][j][0] <== option*dec.out_img[i][j];
            temp[i][j][1] <== (option - 1)*inc.out_img[i][j];
            temp[i][j][2] <== (option - 2)*inv.out_img[i][j];
        }
    }

    for (var i=0; i< h; i++){
        for (var j=0; j<w; j++){
            out_img[i][j] <== temp[i][j][0] + temp[i][j][1] + temp[i][j][2];
        }
    }
    
    
}

component main { public [ orig ] } = EditImage(128, 128);

/* INPUT = {
    "orig": [[["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]], [["1", "2", "3"], ["1", "2", "3"], ["1", "2", "3"]], [["1", "2", "3"], ["1", "2", "3"], ["1", "2", "3"]]]
} */