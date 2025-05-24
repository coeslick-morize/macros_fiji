images=getList("image.titles");
image_CY5p5="";
image_RFP="";

for (i = 0; i < images.length; i++) {
	if (endsWith(images[i], "_CY5p5.tiff")) {
		image_CY5p5=images[i];
	}
	if (endsWith(images[i], "_RFP.tiff")) {
		image_RFP=images[i];
	}
}
selectImage(image_CY5p5);
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input': '" + image_CY5p5 + "', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.5', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
while (!isOpen("Label Image")) {
	wait(100);
}

selectImage("Label Image");
if (image_RFP != "") {
	selectImage(image_RFP);
}

setAutoThreshold("Default dark no-reset");
//run("Threshold...");
setOption("BlackBackground", true);
run("Convert to Mask");
roiManager("Show All");
roiManager("Measure");
// calc coloc
total_CY5p5 = nResults;
total_RFP = 0;
for (i=0; i < nResults; i++) {
    if (getResult("Max", i) == 255)
        total_RFP++;
}

percent = total_RFP / total_CY5p5 *100;

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