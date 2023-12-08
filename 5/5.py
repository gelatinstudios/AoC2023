
import sys

def parse_int_list(s): return list(map(int, s.split()))

paragraphs = sys.stdin.read().split("\n\n")

seeds_line = parse_int_list(paragraphs[0].split(":")[1])

def nonempty(r): return r[1]>r[0]
def contains(r, a): return a >= r[0] and a < r[1]
def transform(ss, sources, dests):
    result = []
    while len(ss) > 0:
        s = ss.pop()

        for i, src in enumerate(sources):
            if contains(src, min(s)) or contains(s, min(src)):
                a = min(s[0], src[0])
                b = max(s[0], src[0])
                c = min(s[1], src[1])
                d = max(s[1], src[1])
                A = (a, b)
                B = (b, c)
                C = (c, d)
                if nonempty(A) and contains(s, min(src)):
                    ss.append(A)
                if nonempty(C) and contains(s, max(src)):           
                    ss.append(C)

                dest = min(dests[i])
                result.append((dest + min(B) - min(src),
                               dest + max(B) - min(src)))
                break
        else:
            result.append(s)

    return result

def parse_map_paragraph(paragraph):
    sources = []
    dests = []
    for line in paragraph.strip().split("\n")[1:]:
        dest, src, length = parse_int_list(line)
        sources.append((src, src+length))
        dests.append((dest, dest+length))
    return sources, dests

part1 = [(s, s+1) for s in seeds_line]

it = iter(seeds_line)
part2 = [(s, s+next(it)) for s in it]

for seeds in [part1, part2]:
    for p in paragraphs[1:]:
       seeds = transform(seeds, *parse_map_paragraph(p))
    print(min(map(min, seeds)))
