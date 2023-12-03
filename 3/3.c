
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

static char grid[256][256];

typedef struct {
    int x, y;
} iv2;

typedef struct {
    iv2 start;
    int end_x;
    int value;
} Number;

int main(void) {
    static char line[4096];
    int w = 0;
    int h = 0;
    while (fgets(line, sizeof(line), stdin)) {
        strcpy(grid[h++], line);
        if (!w) w = strlen(line) - 1;
    }

    static Number numbers[4096];
    int number_count = 0;
    
    int start_x, start_y;
    int part_sum = 0;
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            int n = 0;
            int is_part = 0;
            int start_x = x;
            int start_y = y;
            while (isdigit(grid[y][x])) {
                n *= 10;
                n += grid[y][x] - '0';
                for (int dy = -1; dy <= 1; dy++) {
                    for (int dx = -1; dx <= 1; dx++) {
                        int nx = x + dx;
                        int ny = y + dy;
                        if (nx >= 0 && nx < w && ny >= 0 && ny < h) {
                            char c = grid[ny][nx];
                            is_part |= !(c==0 || isdigit(c) || c == '.' || isspace(c));
                        }
                    }
                }
                x++;
            }
            if (n) {
                Number number = {0};
                number.start.x = start_x;
                number.start.y = start_y;
                number.end_x = x;
                number.value = n;
                numbers[number_count++] = number;
                part_sum += is_part * n;
            }
        }
    }
    printf("%d\n", part_sum);

    int gear_sum = 0;
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            if (grid[y][x] != '*') continue;
            int star_x = x;
            int star_y = y;
            int adjacent_numbers[8];
            int adjacent_number_count = 0;
            for (int i = 0 ; i < number_count; i++) {
                int is_adjacent = 0;
                Number number = numbers[i];
                for (int x = number.start.x; x < number.end_x; x++) {
                    int m = abs(x - star_x) <= 1 && abs(number.start.y - star_y) <= 1;
                    is_adjacent |= m;
                }
                if (is_adjacent) {
                    adjacent_numbers[adjacent_number_count++] = number.value;
                }
            }
            if (adjacent_number_count == 2) {
                gear_sum += adjacent_numbers[0] * adjacent_numbers[1];
            }
        }
    }
    printf("%d\n", gear_sum);
}
