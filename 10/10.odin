
package day_10

import "core:os"
import "core:bufio"
import "core:strings"
import "core:fmt"
import "core:slice"

read_lines :: proc() -> []string {
    reader: bufio.Reader
    bufio.reader_init(&reader, os.stream_from_handle(os.stdin))
    result: [dynamic]string
    for {
        line, err := bufio.reader_read_string(&reader, '\n')
        if err != .None do break
        append(&result, strings.trim_space(line))
    }
    return result[:]
}

iv2 :: distinct [2]int

N : iv2 : { 0, -1}
E : iv2 : { 1,  0}
W : iv2 : {-1,  0}
S : iv2 : { 0,  1}
delta_table: map[u8][]iv2 = {
    '|' =  {N, S},
    'L' =  {N, E},
    'J' =  {N, W},
    '7' =  {S, W},
    'F' =  {S, E},
    '-' =  {E, W},
    '.' =  {},
}

pipe_at_raw :: proc(lines: []string, x, y: int) -> u8 { return lines[y][x]}
pipe_at_iv2 :: proc(lines: []string, v: iv2) -> u8 { return pipe_at_raw(lines, v.x, v.y)}
pipe_at :: proc { pipe_at_raw, pipe_at_iv2 }

main :: proc() {
    lines := read_lines()
    w, h := len(lines[0]), len(lines)

    S: iv2
    for line, y in lines {
        x := strings.index_byte(line, 'S')
        if x != -1 {
            S = {x,y}
            break
        }
    }

    S_deltas: [2]iv2
    S_delta_index := 0
    for dy in -1..=1 {
        for dx in -1..=1 {
            if dx == 0 && dy == 0 do continue
            d := iv2{dx, dy}
            n := S + d
            if n.x < 0 || n.x > w || n.y < 0 || n.y > h do continue
            p := pipe_at(lines, S + d)
            if slice.contains(delta_table[p], -d) {
                S_deltas[S_delta_index] = d
                S_delta_index += 1
            }
        }
    }

    delta_table['S'] = S_deltas[:] // prob not necessary

    start := S + S_deltas[0]
    end   := S + S_deltas[1]

    next :: proc(lines: []string, from, pos: iv2) -> iv2 {
        for d in delta_table[pipe_at(lines, pos)] {
            n := pos + d
            if n != from do return n
        }
        unreachable()
    }

    steps := 0
    for from, at := S, start;
        at != end;
        from, at = at, next(lines, from, at)
    {
        steps += 1
    }

    part1 := (steps + 2) / 2
    fmt.println(part1)
}
