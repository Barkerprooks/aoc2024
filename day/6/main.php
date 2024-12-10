<?php
    class Vec2 { 
        private $direction = [0, 1, 0, -1];
        public $x, $y, $dx = 0, $dy = 3; 

        public function rotate() {
            $this->dx = ($this->dx + 1) % 4;
            $this->dy = ($this->dy + 1) % 4;
        }

        public function move() {
            $this->x += $this->direction[$this->dx];
            $this->y += $this->direction[$this->dy];
        }

        public function get_next_x() {
            return $this->x + $this->direction[$this->dx];
        }

        public function get_next_y() {
            return $this->y + $this->direction[$this->dy];
        }
    }
    
    function next_step($lines, $gaurd, $width, $height) {        
        $x = $gaurd->get_next_x();
        $y = $gaurd->get_next_y();

        if ($x >= $width || $x < 0 || $y >= $height || $y < 0)
            return false; // end the program, gaurd is out

        if ($lines[$y][$x] === '#')
            $gaurd->rotate();
        else
            $gaurd->move();
        
        return true;
    }

    $input = trim(file_get_contents("./day/6/input.txt"));
    $lines = explode(PHP_EOL, $input);
    $gaurd = new Vec2();

    $height = count($lines);
    $width = strlen($lines[0]);

    $part1 = 1;

    foreach ($lines as $y => $line) {
        foreach (str_split($line) as $x => $char) {
            if ( $char === '^' ) {
                $lines[$y][$x] = 'X';
                $gaurd->x = $x;
                $gaurd->y = $y;
            }
        }
    }

    while(next_step($lines, $gaurd, $width, $height))
        $lines[$gaurd->y][$gaurd->x] = 'X';

    echo "part 1: " . substr_count(implode("", $lines), "X") . PHP_EOL;
?>