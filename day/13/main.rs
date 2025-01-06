use std::io::prelude::*;
use std::fs;

#[derive(Copy, Clone)]
struct V2 { x: u32, y: u32 }

fn prize(a: V2, b: V2, target: V2) -> V2 {
    let mut score_a = V2 { x: 0, y: 0 };
    let mut score_b = V2 { x: 0, y: 0 };

    while (score_a.x < target.x && score_a.y < target.y) {
        scoreA.x += a.x;
        scoreA.y += a.y;
    }

    while (score_b.x < target.x && score_b.y < target.y) {
        scoreB.x += b.x;
        scoreB.y += b.y;
    }

    score
}

fn parse_record_line(line: &str) -> V2 {
    let colon: usize = line.chars().position(| character | character == ':')
        .expect("parse error: line missing colon");
    
    let comma: usize = line.chars().position(| character | character == ',')
        .expect("parse error: line missing comma");

    let [x, y]: [&str; 2] = [ &line[colon + 4..comma].trim(), &line[comma + 4..].trim() ];

    V2 { 
        x: x.parse().expect("could not parse x value into an integer"), 
        y: y.parse().expect("could not parse y value into an integer")
    }
}

fn main() {
    let text = fs::read_to_string("./day/13/test.txt")
        .expect("could not open file");

    let data: Vec<&str> = text.split("\n\n").collect();

    for record in data {
        let [a, b, target] = record.lines()
            .map(| line | parse_record_line(line))
            .collect::<Vec<V2>>()[..] else { continue };

        let score = prize(a, b, target);

        println!("Ax: {}, Ay: {}", a.x, a.y);
        println!("Bx: {}, By: {}", b.x, b.y);
        println!("Gx: {}, Gy: {}", target.x, target.y);
        println!("x: {}, y: {}\n", score.x, score.y)
    }
}