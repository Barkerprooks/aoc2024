<?php
    class Vec2 { public $x, $y; }
    
    $text = file_get_contents("./day/6/input.txt");
    $lines = explode(PHP_EOL, $text);
    $gaurd = new Vec2();

    $height = count($lines);
    $width = strlen($lines[0]);

    foreach ($lines as $y => $line) {
        foreach (str_split($line) as $x => $char) {
            if ( $char === '^' ) {
                $gaurd->x = $x;
                $gaurd->y = $y;
            }
        }
    }

    echo $gaurd->x . ", " . $gaurd->y . PHP_EOL;
    
?>