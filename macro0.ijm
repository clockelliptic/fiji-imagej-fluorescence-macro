filepath = "C:/Users/Bob/Documents/lif_files/"; //location containing your file
filename = "my_file.lif" //the name of the file itself
open(filepath+filename);

n_images = 13; //number of images in the set

function measure_intensity(image_name){
	selectWindow(image_name);
	run("Z Project...", "projection=[Sum Slices]");
	run("Duplicate...", "duplicate");
	run("Gaussian Blur...", "sigma=0.40 scaled stack");
	setAutoThreshold("MinError dark");
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Huang background=Dark calculate black");
	//run("Median...", "radius=100 stack"); // this is the part that takes a long time
	run("Dilate", "stack");
	run("Create Selection");
	run("ROI Manager...");
	roiManager("Add");
	run("Make Inverse");
	roiManager("Add");
	selectWindow(image_name);
	roiManager("Measure");
	roiManager("Deselect");
	roiManager("Delete");

}

for (i=1; i <= n_images && i <= 9; i++) {
	image_name = filename + " - Series00"+i;
	measure_intensity(image_name);
}

for (i=10; i <= n_images && i <= 99; i++) {
	image_name = filename + " - Series0"+i;
	measure_intensity(image_name);
}

for (i=100; i <= n_images && i <= 999; i++) {
	image_name = filename + " - Series"+i;
	measure_intensity(image_name);
}

// Comment-out the Close All command in order to prevent macro from closing all images at the end
// You might need to do this if you want to inspect the masks that the macro applies to each image
// Place // before the code to comment it out
run("Close All");