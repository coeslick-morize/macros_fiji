images=getList("image.titles");
image_DAPI="";
image_TX_RED="";
image_CY5p5="";
for (i = 0; i < images.length; i++) {
	if (endsWith(images[i], "_DAPI.tif")) {
		image_DAPI=images[i];
	}
	if (endsWith(images[i], "_TX Red.tif")) {
		image_TX_RED=images[i];
	}
	if (endsWith(images[i], "_CY5p5.tif")) {
		image_CY5p5=images[i];
	}
}
selectImage(image_DAPI);
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input': '" + image_DAPI + "', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.5', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
while (!isOpen("Label Image")) {
	wait(100);
}

selectImage("Label Image");
if (image_TX_RED != "") {
	selectImage(image_TX_RED);
}
if (image_CY5p5 != "") {
	selectImage(image_CY5p5);
}
setAutoThreshold("Default dark no-reset");
//run("Threshold...");
setOption("BlackBackground", true);
run("Convert to Mask");
roiManager("Show All");
roiManager("Measure");

// calc coloc
total = nResults;
coloc = 0;
for (i=0; i < nResults; i++) {
    if (getResult("Max", i) == 255)
        coloc++;
}

percent = coloc / total *100;

setResult("Colocalisation", 0, percent);

updateResults();
//savefile

folder=getDirectory("image");

last_underscore_index=lastIndexOf(images[0], "_");
csvfile_name=images[0].substring(0, last_underscore_index);
saveAs("Results", folder + csvfile_name + ".csv");
setOption("Changes", false);
close("*");
close("Results");
close("ROI Manager");