<?php
    function edgestr($key) { return $key[0].":".$key[1]; }

    class Graph {
        private $data = [];

        public function edges($key) { return $this->data[$key[0].":".$key[1]] ?? []; }

        public function push_edge($key, $value) {
            $keystr = edgestr($key);
            if (array_key_exists($keystr, $this->data)) {
                if (!in_array($value, $this->data[$keystr]))
                    array_push($this->data[$keystr], $value);
            } else
                $this->data[$keystr] = [ $value ];
        }
    }

    class Gaurd {
        private $graph, $memory, $origin, $position, $stack, $visited;
        private $direction = [0, 1, 0, -1];
        private $velocity = [0, 3];

        public $cycle_detected = false;

        private function cycle($key) {
            $keystr = edgestr($key);

            $this->visited[$keystr] = true;
            $this->stack[$keystr] = true;

            foreach ($this->graph->edges($key) as $value) {
                $valuestr = edgestr($value);
                if (!($this->visited[$valuestr] ?? false)) {
                    return $this->cycle($value);
                } else if ($this->stack[$valuestr] ?? false) {
                    return true;
                }
            }

            $this->stack[$keystr] = false;

            return false;
        }

        public function __construct($x, $y) {
            $this->position = [$x, $y];
            $this->origin = [$x, $y];
            $this->memory = [$x, $y];
            $this->graph = new Graph();
        }

        public function reset() {
            $this->velocity = [0, 3];
            $this->position = $this->origin;
            $this->memory = $this->origin;
            $this->graph = new Graph();
        }

        public function detect_cycle() {
            $this->visited = [];
            $this->stack = [];

            $this->cycle_detected = $this->cycle($this->position);
        }

        public function rotate() {
            $this->graph->push_edge($this->memory, $this->position); // add edge to graph
            if ($this->memory != $this->position) // account for double rotations
                $this->detect_cycle(); // in all honesty this maybe should not have passed
                                       // because of triple rotations, but... we'll take it

            $this->memory = $this->position; // remember the last position
            $this->velocity[0] = ($this->velocity[0] + 1) % 4;
            $this->velocity[1] = ($this->velocity[1] + 1) % 4;
        }

        public function move() {
            $this->position[0] += $this->direction[$this->velocity[0]];
            $this->position[1] += $this->direction[$this->velocity[1]];
        }

        public function next_x() { return $this->position[0] + $this->direction[$this->velocity[0]]; }
        public function next_y() { return $this->position[1] + $this->direction[$this->velocity[1]]; }

        public function x() { return $this->position[0]; } // wish I could make these arrow functions :/
        public function y() { return $this->position[1]; }
    }
    
    function next_step($lines, $gaurd, $width, $height) {        
        $x = $gaurd->next_x();
        $y = $gaurd->next_y();

        if ($x >= $width || $x < 0 || $y >= $height || $y < 0)
            return false; // end the program, gaurd is out

        if ($lines[$y][$x] == '#')
            $gaurd->rotate();
        else
            $gaurd->move();
        
        return true;
    }

    function mark_step(&$lines, $gaurd) { $lines[$gaurd->y()][$gaurd->x()] = 'X'; }

    $input = trim(file_get_contents("./day/6/input.txt"));
    $lines = explode(PHP_EOL, $input);
    $gaurd = NULL;

    $height = count($lines);
    $width = strlen($lines[0]);

    $check = [];

    foreach ($lines as $y => $line) {
        foreach (str_split($line) as $x => $char) {
            if ( $char === '^' ) {
                $gaurd = new Gaurd($x, $y);
                mark_step($lines, $gaurd);
            } else if ($char === '.') {
                array_push($check, [$x, $y]);
            }
        }
    }

    if ($gaurd === NULL) {
        echo "could not find gaurd" . PHP_EOL;   
        die();
    }

    while (next_step($lines, $gaurd, $width, $height))
        mark_step($lines, $gaurd);

    $part1 = substr_count(implode("", $lines), "X");
    $part2 = 0;

    foreach ($check as $pair) { // checking each cell... this takes FOREVER
        $x = $pair[0];
        $y = $pair[1];

        $gaurd->reset();

        $tmp = $lines[$y][$x];
        $lines[$y][$x] = '#';

        while (next_step($lines, $gaurd, $width, $height)) {
            if ($gaurd->cycle_detected) {
                $gaurd->cycle_detected = false;
                $part2 += 1;
                break;
            }
        }

        $lines[$y][$x] = $tmp;
    }

    // still right tho...
    echo "part 1: " . $part1 . PHP_EOL;
    echo "part 2: " . $part2 . PHP_EOL;
?>