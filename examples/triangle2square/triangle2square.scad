include <line2d.scad>;
include <hollow_out.scad>;

tri_side_leng = 45;
height = 6;
spacing = 0.4;
ring_width = 1.5;  
shaft_r = 1;  
chain_hole = "YES";  // [YES, NO]
chain_hole_width = 2.5;

// https://www.cs.purdue.edu/homes/gnf/book2/trisqu.html
function triangle_square(tri_side_leng) = 
    let(
        p0 = [0, 0],
        p1 = tri_side_leng * [0.25, 0.4330125],
        p2 = tri_side_leng * [0.5, 0.8660255],
        p4 = tri_side_leng * [1, 0],
        p3 = tri_side_leng * [0.75, 0.4330125],
        p6 = tri_side_leng * [0.254508, 0],
        p5 = tri_side_leng * [0.754508, 0],
        p8 = tri_side_leng * [0.5380015, 0.247745],
        p7 = tri_side_leng * [0.4665065, 0.1852665],
        pieces = [
            [p0, p6, p7, p1],
            [p6, p5, p8],
            [p5, p4, p3, p8],
            [p1, p7, p3, p2]
        ],
        hinged_pts = [p5, p3, p1]
    )
    [pieces, hinged_pts];
    
module triangle2square(tri_side_leng, height, spacing, ring_width, shaft_r) {
	
	half_tri_side_leng = tri_side_leng / 2;
    half_h = height / 2;

    joint_ring_inner = shaft_r + spacing;
    joint_ring_outer = joint_ring_inner + ring_width;
	joint_r_outermost = joint_ring_outer + spacing;

	module joint() {
		module joint_ring() {
            hollow_out(ring_width)
                circle(joint_ring_outer);
		}

		ring_height = height / 3 - spacing;
        linear_extrude(ring_height) joint_ring();
        translate([0, 0, height - ring_height]) 
            linear_extrude(ring_height) joint_ring();
			
		translate([0, 0, half_h]) 
			linear_extrude(height / 3, center = true) 
				line2d([0, 0], [joint_r_outermost, 0], shaft_r * 2, p1Style = "CAP_BUTT", p2Style = "CAP_BUTT");
		
		// pillar
		linear_extrude(height) circle(shaft_r);
	}


    offsetd = -spacing / 2;
    tri_sq = triangle_square(tri_side_leng);
    linear_extrude(height) difference() {
        union() {
            difference() {
                offset(offsetd) polygon(tri_sq[0][0]);
                translate(tri_sq[1][2]) circle(joint_r_outermost);
            }
            difference() {
                offset(offsetd) polygon(tri_sq[0][1]);
                translate(tri_sq[1][0]) circle(joint_ring_inner);
            }
            
            difference() {
                offset(offsetd) polygon(tri_sq[0][2]);
                translate(tri_sq[1][0]) circle(joint_r_outermost);
                translate(tri_sq[1][1]) circle(joint_ring_inner);
            }
            
            difference() {
                offset(offsetd) polygon(tri_sq[0][3]);
                translate(tri_sq[1][2]) circle(joint_ring_inner);
                translate(tri_sq[1][1]) circle(joint_r_outermost);
            }
            
        }
    } 
    
	translate(tri_sq[1][0]) rotate(65) joint();
	translate(tri_sq[1][1]) rotate(170) joint();
	translate(tri_sq[1][2]) rotate(275) joint();
}


$fn = 36;
difference() {
	triangle2square(tri_side_leng, height, spacing, ring_width, shaft_r);
	if(chain_hole == "YES") {
		translate([spacing * 1.5, spacing, height / 2]) 
        linear_extrude(chain_hole_width, center = true)
            hollow_out(chain_hole_width) 
                circle(shaft_r + spacing + chain_hole_width);
	}
}

