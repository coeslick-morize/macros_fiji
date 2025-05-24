images=getList("image.titles");
image_RFP="";
image_GFP="";

for (i = 0; i < images.length; i++) {
	if (endsWith(images[i], "_RFP.tiff")) {
		image_RFP=images[i];
	}
	if (endsWith(images[i], "_GFP.tiff")) {
		image_GFP=images[i];
	}
}
selectImage(image_RFP);
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input': '" + image_RFP + "', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.5', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
while (!isOpen("Label Image")) {
	wait(100);
}

selectImage("Label Image");
if (image_GFP != "") {
	selectImage(image_GFP);
}

setAutoThreshold("Default dark no-reset");
//run("Threshold...");
setOption("BlackBackground", true);
run("Convert to Mask");
roiManager("Show All");
roiManager("Measure");
// calc coloc
total_RFP = nResults;
total_GFP = 0;
for (i=0; i < nResults; i++) {
    if (getResult("Max", i) == 255)
        total_GFP++;
}

percent = total_GFP / total_RFP *100;

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