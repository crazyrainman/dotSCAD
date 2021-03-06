/**
* px_circle.scad
*
* @copyright Justin Lin, 2019
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib2x-px_circle.html
*
**/ 

use <_impl/_px_circle_impl.scad>;
use <../util/sort.scad>;
use <../util/dedup.scad>;

function px_circle(radius, filled = false) = 
    let(
        _ = echo("<b><i>pixel/px_circle</i> is deprecated: use <i>voxel/vx_circle</i> instead.</b>"),
        all = _px_circle_impl(radius, filled)
    )
    dedup(sort(all, by = "vt"), sorted = true);