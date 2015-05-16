spkr_h = 17;
spkr_w = 34;
spkr_l = 70;
spkr_pylon_h=14;
spkr_pylon_d=10;
spkr_screw_w=24;
spkr_screw_inset = (spkr_w - spkr_screw_w)/2;

intersleeve_space = 0.1;
spkr_screw_d = 3.05;
spkr_screw_l = 10;

bar_d = 22.4;

thickness = 5;
mount_h = 20;

e = 0.02;
e2 = e*2;


module screw_hole(d, l, g) {
    g = g + 1;
    head_d = 2 * d * g;
    head_h = 0.6 * d * g;
    union() {
        translate([0,0,-e]) cylinder(d = head_d, h = head_h + e2, $fn=24);
        translate([0,0,head_h]) cylinder(d = d, h = l+e, $fn=24);
        
        //space above screw head
        translate([0,0,-head_d]) cylinder(d = head_d, h = head_d + e, $fn=24);
    }
}

module screw_pad() {
    cube(size=[thickness, 2*thickness, mount_h]);
} 

module screw_pad_holes() {
    color("red") union() {
        translate([0,thickness,0]) 
            rotate([0,90,0]) {
                translate([-thickness,0,0]) screw_hole(3.1,30,0,0.1);
                translate([-(mount_h-thickness),0,0]) screw_hole(3.1,30,0,0.1);
            }
    }
} 
mount_outer_d = bar_d + 2*thickness;

module sleeve() {
    difference() {
        union() {
            difference() {
                cylinder(d = mount_outer_d, h = mount_h);
                translate([0,0,-e]) cylinder(d = bar_d, h = mount_h + e2);
                translate([0,-mount_outer_d/2-e,-e]) cube(size=[mount_outer_d/2+e, mount_outer_d+e, mount_h + e2]);
            }
            translate([-thickness, -mount_outer_d/2 - thickness,0])
                screw_pad(); 
            translate([-thickness, +mount_outer_d/2 - thickness,0])
                screw_pad();            
        }
        translate([-thickness, -mount_outer_d/2 - thickness,0])
            screw_pad_holes();
        translate([-thickness, +mount_outer_d/2 - thickness,0])
            screw_pad_holes();
        translate([-intersleeve_space,-2*mount_outer_d,-e])
            cube(size=[4*mount_outer_d, 4*mount_outer_d,2*mount_h]);
        
    }
}

module speaker_pad() {
    difference () {
        union() {
            translate([-bar_d/2 - thickness,-spkr_w/2,0]) 
                cube(size=[thickness, spkr_w, mount_h]);
            union() {
                translate([-spkr_pylon_h/2-mount_outer_d/2,0,spkr_pylon_d/2]) {
                    union() {
                        translate([0,spkr_w/2 - spkr_pylon_d/2,0])
                            cube(size=[spkr_pylon_h,spkr_pylon_d,spkr_pylon_d],
                                center=true);
                        translate([0,-spkr_w/2 + spkr_pylon_d/2,0])
                            cube(size=[spkr_pylon_h,spkr_pylon_d,spkr_pylon_d],
                                center=true); 
                        
                    }                
                }
            }
        }
        color("red") rotate([0,-90,0]) translate([spkr_pylon_d/2,0,mount_outer_d/2+spkr_pylon_h - spkr_screw_l]) {
            translate([0,spkr_screw_w/2,0]) 
                cylinder(h=spkr_screw_l+e, d=spkr_screw_d, $fn=12);
            translate([0,-spkr_screw_w/2,0]) 
                cylinder(h=spkr_screw_l+e, d=spkr_screw_d, $fn=12);

        }
    }
}


union() {
    translate([10,0,0]) rotate(180) sleeve();
    
    intersection() {
        union() {
            sleeve();
            speaker_pad();
        }
    }
}
