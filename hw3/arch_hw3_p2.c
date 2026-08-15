#include "stdio.h"

int fn(int x, int y);
int re(int x);

int main() {
    int a = 0;
    int b = 0;
    int c = 0;
    int d = 0;

    printf("input a: ");
    scanf("%d", &a);

    printf("input b: ");
    scanf("%d", &b);

    c = re(a);
    printf("ans: %d", c);

    d = fn(b, c);
    printf("ans: %d", d);

    return 0;
}

int fn(int x, int y) {
    if (x <= 0)
        return 0;
    else if (y <= 0)
        return 0;
    else if (x > y)
        return 2;
    else
        return 3 * fn(x - 1, y) + 2 * fn(x, y - 1) + fn(x - 1, y - 1);
}

int re(int x) {
    return (x >= 2) ? (x * x + x * re(x - 1) + (x - 1) * re(x - 2))
                    : ((x == 1) ? 1 : 0);
}
