#define N 128

void mat_mul (int mat1[][N], int mat2[][N], int res[][N]) {
    int i, j, k;

    for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            res[i][j] = 0;
            for (k = 0; k < N; k++) {
                if (mat1[i][k] == 0 || mat2[k][j] == 0)
                    continue;
                res[i][j] += mat1[i][k] * mat2[k][j];
            }
        }
    }

    printf("Done\n");
}