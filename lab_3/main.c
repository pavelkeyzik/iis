#include <stdio.h>
#include <math.h>

int main() {
    int n = 5, x = 2;
    float result = 0;
    
    for(int i = 0; i < n; i++) {
        float num = sin(pow((double) i, 2));
        float num2 = (2 * i + 1);
        int k = 1, y = 1;
        for(int j = 0; j < num2; j++) {
            y *= k;
            k++;
        }
        float num3 = pow(x, i);
        result += num / y * num3;
    }

    printf("%lf", result);

    return 0;
}