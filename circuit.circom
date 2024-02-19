pragma circom 2.1.2;

// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

template Invert(h, w) {

    signal input orig[h][w][3];

    signal output out_img[h][w][3];

    for (var k=0; k< 3; k++){
        for (var i=0; i< h; i++){
            for (var j=0; j<w; j++){
//              new_mat[j][n - i - 1] = mat[i][j];
                out_img[j][h - i -1][k] <== orig[i][j][k]; 
            }
        }
    }

}

component main { public [ orig ] } = Invert(512, 512);

/* INPUT = {
    "orig": [[["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]], [["1", "2", "3"], ["1", "2", "3"], ["1", "2", "3"]], [["1", "2", "3"], ["1", "2", "3"], ["1", "2", "3"]]]
} */
