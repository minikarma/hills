@0: #00f;
@1: #6bc9d7;
@2: #6bd782;
@3: #84e26b;
@4: #b5e94b;
@5: #dbeb34;
@6: #ffc817;  
@7: #ff8000;  
@8: #ff2018;    


Map {
  background-color: black;
}

#highway {
  line-width:2;
  line-color:#888;
}



#hills {

  line-width:1;
  line-cap: round;
  line-join: round;
  line-opacity: 0.9;

  
  [zoom>9] {
    [highway='motorway'] { line-width: 4; }
    [highway='motorroad'] { line-width: 4; }
    [highway='trunk'] { line-width: 4; }
    [highway='primary'] { line-width: 2.5; }
    [highway='secondary'] { line-width: 1; }
    [highway='tertiary'] { line-width: 0.7; }
    [highway='residential'] { line-width: 0.7; }
  }  

  [zoom>10] {
    [highway='motorway'] { line-width: 6; }
    [highway='motorroad'] { line-width: 6; }
    [highway='trunk'] { line-width: 6; }
    [highway='primary'] { line-width: 4; }
    [highway='secondary'] { line-width: 2.5; }
    [highway='tertiary'] { line-width: 1; }
    [highway='residential'] { line-width: 1; }
 
  }  
    
  [zoom>12] {
    [highway='motorway'] { line-width: 8; }
    [highway='motorroad'] { line-width: 8; }
    [highway='trunk'] { line-width: 8; }
    [highway='primary'] { line-width: 6; }
    [highway='secondary'] { line-width: 4; }
    [highway='tertiary'] { line-width: 1.5; }
    [highway='residential'] { line-width: 1.5; }  
  }
  
  
  [zoom>15][angle>1]  {
  	marker-file:url("shape://arrow");
  	marker-width:15;
  	marker-placement:line;
  	marker-line-width:1;
  	marker-line-opacity:0.8;
  	marker-line-color:#fff;
  	marker-spacing: 50;
  	marker-fill:spin(lighten(#ddd,50),-10);
  	marker-opacity:1;
  }
 [zoom>16] {   
    text-face-name:@font_reg;
  //text-halo-radius:1;
  text-size: 10;
  text-placement:line;
  text-spacing: 100;
  text-name:"[angle]" ;
  text-fill: #f0f0f8;
  
  text-halo-fill: black;
  }



  [a_height <= 100] {  line-color:@0; }
  [a_height > 100] {  line-color:@1; }
  [a_height > 120] {  line-color:@2; }
  [a_height > 140] {  line-color:@4; }
  [a_height > 160] {  line-color:@6; }
  [a_height > 180] {  line-color:@7; }
  [a_height > 200] {  line-color:@8; }

  
}




#roads {
  line-width:1;
  line-color:#bcd;
  line-opacity: 0.3;
}



@font_reg: "Ubuntu Regular","Arial Regular","DejaVu Sans Book";
@secondary: #fff;
@primary: #fff;
@trunk: #fff;
@motorway: #fff;
/* ---- HIGHWAY ---- */


#roads_txt[zoom>15] {
  text-face-name:@font_reg;
  //text-halo-radius:1;
  text-size: 12;
  text-placement:line;
  text-name:"[name]";
  text-fill: rgba(180,180,180,100);
  //text-halo-fill: #222;
  text-dy: -10;
}

#parks {
  polygon-fill: @3;
  polygon-opacity: 0.2;
  }

#water {
  polygon-fill: @1;
  polygon-opacity: 0.4;
  }
