//---------------------------------------------------------------------------------------------------
// This work by Jordan Andersen licensed under the Creative Commons Attribution 3.0 Unported License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/
//---------------------------------------------------------------------------------------------------
//
// Replacement Lower Guide Plate for the Truvativ X-Guide Chain Guide
//
//---------------------------------------------------------------------------------------------------
SHIELD_HEIGHT = 4.5;
HOLE_RADIUS = 2.75;
POST_HEIGHT = 25;

POST_WIDTH_TOP = 4;
POST_WIDTH_BOTTOM = 6;
POST_POSITION = [12.6, 17.5, 0];
POST_ROUNDING_RADIUS = 1;


//---------------------------------------------------------------------------------

//The shield portion of the part. Form is not super strongly connected to function.
module shield()
{
    hull()
    {
         cylinder(r=15, h=SHIELD_HEIGHT, center=false);
    
        translate([7.5, 0, 0]) difference()
        {
            
            cylinder(r=22, h=SHIELD_HEIGHT, center=false);  
            union()
            {     
                translate([0, 0, -2]) cube([100,25,9]);
                translate([-25, -50, -2]) cube([25,100,9]);
            }
        }

        translate([0, -10, 0])  cylinder(r=12, h=SHIELD_HEIGHT, center=false);

        translate([28, 5, 0])  cylinder(r=4, h=SHIELD_HEIGHT, center=false);
        translate([22, 16, 0])  cylinder(r=4, h=SHIELD_HEIGHT, center=false);
        translate([5, 16, 0])  cylinder(r=4, h=SHIELD_HEIGHT, center=false);
    }

}

module hole()
{   
    cylinder(r=HOLE_RADIUS, $fs=1, h=50, center=true);   
}

//*** RED ***
//The post portion of the part. The top is a little thinner than the base to give it 
//a nice slope to allow it to fit in another part.
module post()
{
    rotate( a = 90, v=[1,0,0]) minkowski()
    {
        rotate( a = 90, v=[1,0,0]) cylinder(r=POST_ROUNDING_RADIUS, h=0.0001);
        linear_extrude(height = 1)
        {
            polygon(points=[
                            [0,0],
                            [POST_WIDTH_BOTTOM,0],
                            [POST_WIDTH_BOTTOM,POST_HEIGHT],
                            [POST_WIDTH_BOTTOM - POST_WIDTH_TOP,POST_HEIGHT]
                          ], 
                   paths=[[0,1,2,3]]);
        }
    }
}

//Part minus the fillet
module part()
{
    difference()
    {
         color("yellow", 0.8) shield();
         hole();
    }
    color("red") translate(POST_POSITION) post();
}

//*** BLUE ***
//Fillet on the post. Takes a region around the base of the post and fills
//in the concave portion. 
module fillet()
{
    hull()
    {
        intersection()
        {
            part();
            translate([11, 12, 2.5]) cube([10, 10, 5]);    
        }
    }
    hull()
    {
        intersection()
        {
            part();
            translate([15, 12, 2.5]) cube([3, 10, 15]);    
        }
    }


}

//Final part. Fillet added back in.
module filleted_part()
{
    part();
    color("blue") fillet();
}

//Some spacers to aid visualization
module debugging()
{
    translate([HOLE_RADIUS+ 15, -50, SHIELD_HEIGHT]) cube([5, 100, 6]);
    translate( [-50, HOLE_RADIUS, SHIELD_HEIGHT]) cube([100, 11, 6]);
}

filleted_part();
//color("skyblue") debugging();


