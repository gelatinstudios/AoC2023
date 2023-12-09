
package day_8

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

Node :: struct {
    left, right: string
}

Network :: map[string]Node

next_key :: proc(network: Network, key: string, instruction: rune) -> string {
    node := network[key]
    switch instruction {
        case 'L': return node.left
        case 'R': return node.right
    }
    unreachable()
}

Nothing :: struct{}
String_Set :: map[string]Nothing

count_steps: : proc(network: Network, instructions: string, keys: []string, end_keys: String_Set) -> int {
    steps := 0
    at_end := false
    step_loop: for {
        for instruction in instructions {
            fmt.println(keys)
            if at_end do break step_loop

            at_end = true
            for &key in keys {
                key = next_key(network, key, instruction)
                if at_end && key not_in end_keys do at_end = false
            }
            steps += 1
        }
    }

    return steps
}

main :: proc() {
    lines := read_lines()
    
    instructions := lines[0]

    network: Network
    for line in lines[2:] {
        using strings
        key, _, node_str := partition(line, " = ")
        left, _, right := partition(trim(node_str, "()"), ", ")
        network[key] = Node{left, right}
    }

    //fmt.println(count_steps(network, instructions, []string{"AAA"}, String_Set{"ZZZ"={}}))
    
    part2_end: String_Set
    for key in network {
        if key[len(key)-1] == 'Z' do part2_end[key] = {}
    }
    
    ends_with_a :: proc(s: string) -> bool { return s[len(s)-1] == 'A' }
    keys, err := slice.map_keys(network)
    assert(err == .None)
    part2_keys := slice.filter(keys, ends_with_a)
    
    fmt.println(count_steps(network, instructions, part2_keys, part2_end))
}
