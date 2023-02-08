#import "Basic";
#import "String";
#import "File";
#import "Math";
#import "Random";
#import "stb_image_write";

width :: 800;
height :: 800;
depth :: 255;
num_chans :: 3;
light_dir :: Vector3.{0, 0, -1};

main :: () {
	print("\n===================================\n");

	// width :s32 = 512;
	// height :s32 = 512;
	// num_chans := 3;

	red := Vector4.{255, 0, 0, 255};
	white := Vector4.{255, 255, 255, 255};
	green := Vector4.{0, 255, 0, 255};
	cyan := Vector4.{0, 255, 255, 255};

	// print("content of cube\n%\n", obj_data);

	// pixels_amount :: width * height * num_chans;	
	// img := Image.{width, height, num_chans, pixels};

	// print("Color indexing % % %\n", red.x, red.y, red.z);

	// output_buffer : []s32;
    // output_buffer.data = alloc (size_of (s32) * width * height * num_chans);
    // output_buffer.count = width * height * num_chans;

    // for i : 0..output_buffer.count - 1
    // {
    //     output_buffer[i] = 0;
    // }

	img := create_image(width, height, num_chans);

    // model := parse_obj("obj/cube.obj");
    model := parse_obj("obj/african_head.obj");
    // model := parse_obj("obj/susanne.obj");
    // model := parse_obj("obj/gear.obj");

    // for face, i: model.faces {
    // 	// face is a [..]Vector3
    // 	// is there a better way to implement this part?
    // 	// making the Vector into an array
    // 	_face :[3]int;
    // 	_face[0] = cast(int)face.x;
    // 	_face[1] = cast(int)face.y;
    // 	_face[2] = cast(int)face.z;

    // 	for 0..2 {
    // 		v0 := model.verts[_face[it]];
    // 		v1 := model.verts[_face[(it + 1) % 3]];

    // 		x0 := (v0.x + 1.0) * (width - 1) / 2.0;
    // 		y0 := (v0.y + 1.0) * (height - 1) / 2.0;
    // 		x1 := (v1.x + 1.0) * (width - 1) / 2.0;
    // 		y1 := (v1.y + 1.0) * (height - 1) / 2.0;

    // 		draw_line(cast(int)x0, cast(int)y0, cast(int)x1, cast(int)y1, img, cyan);
    // 	}
    // }

    // print("numfaces: %\n", model.faces.count);

    // draw_line(13, 20, 80, 40, img, white);
    // draw_line(20, 13, 40, 80, img, red);
    // draw_line(80, 40, 13, 20, img, red);
	// set_pixel(img, 50, 50, red);

	// Draw triangles
	// t0 := Vector2.[Vector2.{10,70},   Vector2.{50,160},  Vector2.{70, 80}];
	// t1 := Vector2.[Vector2.{180,50},  Vector2.{150,1},   Vector2.{70, 180}];
	// t2 := Vector2.[Vector2.{180,150}, Vector2.{120,160}, Vector2.{130, 180}];

	// triangle(t0[0], t0[1], t0[2], img, red);
	// triangle(t1[0], t1[1], t1[2], img, white);
	// triangle(t2[0], t2[1], t2[2], img, green);

	// // create a light
	// light_dir := Vector3.{0, 0, -1};

	// // Draw Flat shading render
	// for face, i: model.faces {
	// 	// print("face: %\n", face);
	// 	// print("Face index: %\n", face.component[1]);
	// 	screen_coords :[3]Vector2;
	// 	world_coords :[3]Vector3;
	// 	for j: 0..2 {
	// 		// world_coords := model.verts[cast(int)face.component[j]];
	// 		v := model.verts[cast(int)face.component[j]];
	// 		screen_coords[j] = Vector2.{(v.x + 1) * width /2, (v.y + 1) * height / 2};
	// 		world_coords[j] = v;
	// 	}
	// 	// rand_color := Vector4.{random_get_within_range(1, 255), random_get_within_range(1, 255), random_get_within_range(1, 255), 255}; 
	// 	n1 := world_coords[2] - world_coords[0];
	// 	n2 := world_coords[1] - world_coords[0];
	// 	n :Vector3 = cross_product(n1, n2); 
	// 	normalize(*n);
	// 	// print("normal: %\n", n);
	// 	intensity :float = dot_product(n, light_dir);
	// 	// print("intensity %\n", intensity);
	// 	shade_color := Vector4.{intensity * 255, intensity * 255, intensity * 255, 255}; 
	// 	if intensity > 0 {
	// 		triangle(screen_coords[0], screen_coords[1], screen_coords[2], img, shade_color); 
	// 	}
	// }
	// a_float := 1.0;
	// triangle_other(*testing, *a_float, img, red);

    // output_buffer.data = alloc (size_of (s32) * width * height * num_chans);
    // output_buffer.count = width * height * num_chans;
	zbuffer :[..]float;
	for 0..(width * height){
		array_add(*zbuffer, -FLOAT32_MIN);
	}

	// for < 0..(width*height) {
		// zbuffer[it] = FLOAT32_MAX;
	// }

	rand_color := Vector4.{random_get_within_range(1, 255), random_get_within_range(1, 255), random_get_within_range(1, 255), 255}; 
	for face, i: model.faces {
		// _face : Vector3 = face.component[i];
		// print("face: %\n", face);
		// print("Face index: %\n", face.component[1]);
		screen_coords : [3]Vector3;
		world_coords : [3]Vector3;

		for j: 0..2 {
			v : Vector3 = model.verts[cast(int)face.component[j]];
			screen_coords[j] = Vector3.{floor((v.x + 1) * width /2.0), (v.y + 1) * floor(height / 2.0), floor((v.z + 1) * depth / 2.0)};
			world_coords[j] = v;
		}
		n : Vector3 = cross_product((world_coords[2] - world_coords[0]), (world_coords[1] - world_coords[0]) );
		n = normalize(n);

		intensity : float = dot_product(n, light_dir);
		// print("screen_coords %\n", screen_coords);
		if intensity > 0 {
			intensity_color := Vector4.{intensity * 255, intensity * 255, intensity * 255, 255};
			triangle(screen_coords[0], screen_coords[1], screen_coords[2], img, intensity_color, zbuffer);
		}
	}


	stbi_flip_vertically_on_write(1);
	stbi_write_png("output_chapter_03.png", width, height, 3, img.pixels.data, cast(s32)(width * num_chans));

	// Dump Z-Buffer (debugging purposes only)
	zbimg := create_image(width, height, num_chans);
	for i: 0..(width -1) {
		for j: 0..(height -1) {
			set_pixel(zbimg, i, j, Vector4.{zbuffer[i + j * width], zbuffer[i + j * width],zbuffer[i + j * width], 255});
		}
	}

	stbi_flip_vertically_on_write(1);
	stbi_write_png("output_depth_chapter_03.png", width, height, 3, zbimg.pixels.data, cast(s32)(width * num_chans));
}

Vec2i ::[2]int;

Image :: struct {
	width:		int;
	height:		int;
	num_chans:	int;
	pixels:		[..]u8;
}

Mesh :: struct {
	verts:		[..]Vector3;
	// faces:		[..]s64;	
	faces:		[..]Vector3;	
	num_faces:	int;
}

world_2_screen :: (v : Vector3, width : int, height : int) -> Vector3 {
	return Vector3.{(v.x + 1) *  width/2.0 + 0.5, (v.y + 1) * height / 2.0 + 0.5, v.z};
}

create_image :: (width : int, height:int, num_chans:int) -> Image {
	pixels :[..]u8;
	for 0..(width * height * num_chans){
		array_add(*pixels, 0);
	}
	return Image.{width, height, num_chans, pixels};
}

set_pixel :: (img: Image, x: int, y: int, color: Vector4){
	index: int = y * img.width * img.num_chans + x * img.num_chans;
	img.pixels[index + 0] = cast(u8)color.x;
	img.pixels[index + 1] = cast(u8)color.y;
	img.pixels[index + 2] = cast(u8)color.z;
}

draw_line :: (x0: int, y0: int, x1: int, y1: int, img: Image, color: Vector4){
	steep: bool = false;
	if abs(x0 - x1) < abs(y0 - y1) {
		Swap(*x0, *y0);
		Swap(*x1, *y1);
		steep = true;
	}

	if x0 > x1 {
		Swap(*x0, *x1);
		Swap(*y0, *y1);
	}

	dx := x1 - x0;
	dy := y1 - y0;
	derror2 := abs(dy) * 2;
	error2 := 0;
	y := y0;
	// x := x0;

	for x0..x1 {
		x := it;
		if steep {
			set_pixel(img, y, x, color);

		} else {
			set_pixel(img, x, y, color);
		}

		error2 += derror2;
		if error2 > dx {
			y += ifx y1 > y0 then 1 else -1;
			error2 -= dx * 2;
		}
	}
}
parse_obj :: (obj_path: string) -> Mesh {
	obj_data, success := read_entire_file(obj_path);	
	lines := split(obj_data, "\n");
	mesh: Mesh;

	if !success {
		print("couldn't load file: %\n", obj_path);
		// return;
	} 

	for lines {
		// print("line: %\n", split(it, " "));
		line_elems := split(it, " ");
		if line_elems[0] == "v"{
			// print("A vertex: %\n", it);
			x := string_to_float(line_elems[1]);
			y := string_to_float(line_elems[2]);
			z := string_to_float(line_elems[3]);
			array_add(*mesh.verts, Vector3.{x, y, z});
		}	
		
		else if line_elems[0] == "f" {
			// print("A face: %\n", it);

			vert1 := split(line_elems[1], "/")[0];
			vert2 := split(line_elems[2], "/")[0];
			vert3 := split(line_elems[3], "/")[0];

			// x := to_integer(vert1);
			// y := to_integer(vert2);
			// z := to_integer(vert3);

			x := string_to_float(vert1);
			y := string_to_float(vert2);
			z := string_to_float(vert3);

			// array_add(*mesh.faces, x);
			// array_add(*mesh.faces, y);
			// array_add(*mesh.faces, z);
			array_add(*mesh.faces, Vector3.{x - 1 , y - 1, z - 1});
		}
	}

	// print("verts: %\n", mesh.verts.count);
	// print("faces: %\n", mesh.faces.count);
	// print("faces total: %\n", mesh.faces.count /3);
	mesh.num_faces = mesh.faces.count / 3;
	return mesh;
}

// TODO: Fix float errors, we need vector of ints
triangle :: (t0: Vector3, t1: Vector3, t2: Vector3, img: Image, color: Vector4, zbuffer: []float){
	if t0.y == t1.y && t0.y == 2 return;	// I dont care about degenerate triangles
	// sort the vertices, t0, t1, t2 lower-to-upper (bubblesort yay!)
	if t0.y > t1.y Swap(*t0, *t1);
	if t0.y > t2.y Swap(*t0, *t2);
	if t1.y > t2.y Swap(*t1, *t2);
	total_height := t2.y - t0.y;

	for i: 0..cast(int)total_height {
		second_half :bool = cast(bool)(ifx cast(float)i > (t1.y - t0.y) || t1.y == t0.y then 1 else 0);
		segment_height := ifx second_half then t2.y - t1.y else t1.y - t0.y;
		alpha :float = cast(float)i/ total_height;
		beta :float = (i - ( ifx second_half then t1.y - t0.y else 0 )) / segment_height;
		A :Vector3 = t0 + (t2 - t0) * alpha;
		B :Vector3 = ifx second_half then t1 + (t2 - t1) * beta else t0 + (t1 - t0) * beta;

		if A.x > B.x Swap(*A, *B);

		for j: cast(int)A.x..cast(int)B.x {
			phi : float = ifx B.x == A.x then 1.0 else cast(float)(j - A.x) / cast(float)(B.x - A.x);
			P :Vector3 = A + (B - A) * phi;
			idx : int = j + cast(int)(t0.y + i) * width;
			if zbuffer[idx] < P.z {
				zbuffer[idx] = P.z;
				set_pixel(img, cast(int)P.x, cast(int)P.y, color);
			}
		}
	}
}

// TODO : DELETE THIS, this is the cross product
operator ^ :: (a :Vector3, b :Vector3) -> Vector3 {
	return Vector3.{cast(float)( (cast(int)a.x) ^ (cast(int)b.x) ),
					cast(float)( (cast(int)a.y) ^ (cast(int)b.y) ),
					cast(float)( (cast(int)a.z) ^ (cast(int)b.z) )};
}


barycentric :: (A :Vector3, B :Vector3, C :Vector3, P :Vector3) -> Vector3 {
	s :[2]Vector3;
	for < i: 1..0 {
		s[i].component[0] = C.component[i] - A.component[i];
		s[i].component[1] = B.component[i] - A.component[i];
		s[i].component[2] = A.component[i] - P.component[i];
	}
	u := cross_product(s[0], s[1]);
	if abs(u.component[2]) > 1.0e-2 {
		return Vector3.{1.0 - (u.x + u.y) / u.z, u.y / u.z, u.x/u.z};
	}
	return Vector3.{-1, 1, 1};
}

barycentric_2d :: (pts :*Vec2i, P :Vec2i) -> Vector3 {
	u := Vector3.{cast(float)(pts[2][0] - pts[0][0]), 
			      cast(float)(pts[1][0] - pts[0][0]),
			      cast(float)(pts[0][0] - P[0])} ^ 
	     Vector3.{cast(float)(pts[2][1] - pts[0][1]),
	     	      cast(float)(pts[1][1] - pts[0][1]),
	     	      cast(float)(pts[0][1]-P[1])};

	if abs(u.z) < 1 return Vector3.{-1, 1, 1};
	return Vector3.{1 - (u.x + u.y) / u.z, u.y / u.z, u.x / u.z};
}