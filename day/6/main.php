<?php
    class Vec2 { 
        private $direction = [0, 1, 0, -1];
        private $memory = []; // detect a cycle of 4, memory of 8

        public $x, $y, $dx = 0, $dy = 3; 

        public function reset() {
            $this->dx = 0;
            $this->dy = 3;
            $this->memory = [];
        }

        public function cycle_detected() {
            // if we hit the same 4 corners twice, its a cycle
            if (count($this->memory) == 8) {
                $a = array_slice($this->memory, 0, 4);
                $b = array_slice($this->memory, 4, 8);

                echo "a: ";
                foreach ($a as $pair)
                    echo "(" . $pair[0] . ", " . $pair[1] . "), ";
                echo PHP_EOL;

                echo "b: ";
                foreach ($b as $pair)
                    echo "(" . $pair[0] . ", " . $pair[1] . "), ";
                echo PHP_EOL.PHP_EOL;

                if ($a == $b)
                    return true;
            }

            return false;
        }

        public function rotate() {
            $this->dx = ($this->dx + 1) % 4;
            $this->dy = ($this->dy + 1) % 4;
            array_push($this->memory, [$this->x, $this->y]);
            if (count($this->memory) == 9)
                array_shift($this->memory);
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
    
    function next_step(&$lines, $gaurd, $width, $height) {        
        $x = $gaurd->get_next_x();
        $y = $gaurd->get_next_y();

        if ($x >= $width || $x < 0 || $y >= $height || $y < 0)
            return false; // end the program, gaurd is out

        if ($lines[$y][$x] == '#')
            $gaurd->rotate();
        else
            $gaurd->move();
        
        return true;
    }

    $input = trim(file_get_contents("./day/6/test.txt"));
    $lines = explode(PHP_EOL, $input);
    $gaurd = new Vec2();

    $height = count($lines);
    $width = strlen($lines[0]);

    $check = [];
    $part2 = 0;

    foreach ($lines as $y => $line) {
        foreach (str_split($line) as $x => $char) {
            if ( $char === '^' ) {
                $origin = [$x, $y];
                $lines[$y][$x] = 'X';
                $gaurd->x = $x;
                $gaurd->y = $y;
            } else if ($char !== '#')
                array_push($check, [$x, $y]);
        }
    }

    while (next_step($lines, $gaurd, $width, $height))
        $lines[$gaurd->y][$gaurd->x] = 'X';

    $part1 = substr_count(implode("", $lines), "X");



    foreach ($check as $pair) {

        for ($y = 0; $y < $height; $y++)
            $lines[$y] = str_replace("X", ".", $lines[$y]);

        $x = $pair[0];
        $y = $pair[1];
        $gaurd->x = $origin[0];
        $gaurd->y = $origin[1];
        $gaurd->reset();

        $tmp = $lines[$y][$x];
        $lines[$y][$x] = '#';

        while (next_step($lines, $gaurd, $width, $height)) {
            $lines[$gaurd->y][$gaurd->x] = 'X';
            if ($gaurd->cycle_detected())
                break;
            foreach ($lines as $line) {
                foreach (str_split($line) as $char) {
                    echo $char;
                }
                echo PHP_EOL;
            }
            echo PHP_EOL;
        }

        $lines[$y][$x] = $tmp;
    }

    echo "part 2: " . $part2 . PHP_EOL;
?>