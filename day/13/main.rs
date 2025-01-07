use std::fmt;
use std::fs;

#[derive(Copy, Clone)]
struct V2 { x: f64, y: f64 }

impl V2 {
    pub fn from_strings(x: &str, y: &str) -> Self {
        V2 { 
            x: x.parse().expect("could not parse x value into a float"), 
            y: y.parse().expect("could not parse y value into a float")
        }
    }
}

impl fmt::Display for V2 {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

fn prize(a: V2, b: V2, t: V2) -> f64 {
    let w = t.x + 1.0;
    let target = t.x + w * t.y; // x + w * y => target x is max width
    let step_a = a.x + w * a.y;
    let step_b = b.x + w * b.y;

    let mut x = 0.0;
    let mut y = 0.0;

    loop {
        let p1 = x * step_a + y * step_b;
        let p2 = y * step_a + x * step_b;

        if p1 == target {
            return (x * 3.0) + y;
        } else if p2 == target {
            return (y * 3.0) + x;
        }

        y += 1.0;

        if y > 1000.0 {
            x += 1.0;
            y = 0.0;
        }

        if x > 1000.0 {
            break;
        }

    }

    0.0
}

fn parse_record_line(line: &str) -> V2 {
    let colon: usize = line.chars().position(| character | character == ':')
        .expect("parse error: line missing colon");
    
    let comma: usize = line.chars().position(| character | character == ',')
        .expect("parse error: line missing comma");

    let [x, y]: [&str; 2] = [ 
        &line[colon + 4..comma].trim(), 
        &line[comma + 4..].trim() 
    ];

    V2::from_strings(x, y)
}

fn main() {
    let text = fs::read_to_string("./day/13/input.txt")
        .expect("could not open file");

    let data: Vec<&str> = text.split("\n\n").collect();

    let mut score: f64 = 0.0;

    for record in data {
        let [a, b, t] = record.lines()
            .map(| line | parse_record_line(line))
            .collect::<Vec<V2>>()[..] else { continue };

        //let newt = V2 {x: t.x + 10000000000000.0, y: t.y + 10000000000000.0};
        score += prize(a, b, t);
    }

    println!("{}", score);
}