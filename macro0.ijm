filepath = "C:\\Users\\Bob\\Documents\\files\\"; //location containing your file
filename = "my_file" //the name of the file itself
open(filepath+filename);

n_images = 13; //number of images in the set

// this routine is performed on each image, one at a time
function measure_intensity(image_name){
	selectWindow(image_name); // select the image we want to work with
	
	// sum together the intensities of each frame in the stack
	run("Z Project...", "projection=[Sum Slices]");
	
	// create a duplicate of our image to transform into a selection mask
	run("Duplicate...", "duplicate");
	
	// very slight gaussian blur helps get a metter mask
	run("Gaussian Blur...", "sigma=0.40 scaled stack");
	
	//convert to mask using Huang method 
	run("Convert to Mask", "method=Huang background=Dark calculate black");
	
	run("Dilate", "stack");          // dilate (expand) the mask slightly to get better selection
	run("Create Selection");         // convert the mask into a selection
	run("ROI Manager...");           // open the ROI manager
	roiManager("Add");               // add the mask to ROI manager
	run("Make Inverse");             // invert the mask so we select the background
	roiManager("Add");               // add the background selection to the ROI manager
	selectWindow("SUM_"+image_name); // select the image that we want to measure from
	roiManager("Measure");           // use ROI manager to apply and measure each selection
	roiManager("Deselect");          // de-select the selection in the image
	roiManager("Delete");            // delete both background masks
}


// The following 3 For Loops allow us to operate on sets of up to 999 images
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