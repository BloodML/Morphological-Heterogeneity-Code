# Morphological-Heterogeneity-Code

## Introduction
This respository contains the code and trained neural networks that were used to create the ["Morphological Heterogeneity" (MH) dataset](https://doi.org/10.18738/T8/76JRDQ), which contains images, binary masks, bounding boxes, morphology labels, and other metrics of red blood cells (RBCs) flowing through a microfluidic device.  What follows is a brief tutorial on how to use it.

## Requirements
- MATLAB 2021b or higher
- Image Processing Toolbox (11.4) 
- Statistics and Machine Learning Toolbox (12.2)
- Computer Vision Toolbox (10.1)

## Tutorial
### Test Run
To test your MATLAB setup and the code. 
1. Download and extract the repository.
2. Delete the **U0W0_0_Output** folder
3. Open the **Routt_Austin_Segmenter_Classifier_ME_Main.m** script in MATLAB
4. Press **Play**
5. When finished, MATLAB should display blended images (microscope images with segmented cells) and the elapsed time in seconds it took the script to finish. If the **U0W0_0_Output** folder and all of its contents are recreated, your setup and the code are in working order.

### Reproduce the MH Dataset from the raw microscope data
There is a lot of data in the MH dataset, so the code is designed to work iteratively. In other words, you derive masks, bounding boxes, and other statistics one Unit-Week-Run at a time. This can be done manually, or by modifying the script with a `for-loop`. To reproduce the MH dataset:
1. Go to the [MH dataverse](https://doi.org/10.18738/T8/76JRDQ) repository to download, and then extract the Unit-Week-Run  images you want. 
	- Each Unit-Week-Run is in a zip file labeled **U#W#_#.zip**, where **#** corresponds to an integer for unit number, week number, or run number. 
	-  To keep track, extract each into a folder named **MH Dataset**. Keep the **U#W#_#** designation for the subfolders, as this is required for data analysis.
	-  Note that the Unit-Week-Run zip files contain the original images and derived masks, bounding boxes, and various statistics. Only extract the images because you are generating the other data with the script.
2. After extracting the images into a folder (e.g. **D:\MH Dataset\U#W#_#\Images**) go into the script and set the import and export paths
	-  The import path is on line 50.  By default it is **dir = ".\U0W0_0";**. Change this to **dir = "D:\MH Dataset\U#W#_#\Images";** or wherever you extracted the image data.
	- 	The export path is broken up into two, where the base path is on line 113 and the Unit-Week-Run folder name is on line 115.  By default the base is  **baseDir ='.\';** and the output folder is **unitWeekRun = 'U0W0_0_Output';**. Change these to something like **baseDir ='D:\MH Dataset\'** and **unitWeekRun = 'U#W#_#';** or wherever you'd prefer to output the data.
3. Press **Play** and let the script collect the data into the output folder.
4. Repeat this process for all Unit-Week-Run zip files, or you  can download and extract all images and modify the code with a **for-loop** that goes through each folder.

### Reproduce the Average Diameter Data & High Resolution RBC Images.
This will require all unit-week-run data. The data must also be separated into subfolders with the **U#W#_#** naming convention. By default, the script assumes the base path is **'D:\MH Dataset'**.
1. In the code folder, go to the **MH Data Analysis** subfolder and open the **Routt_Austin_MH_Data_Analysis_Main.m** script.
2. The script is broken up into sections, and at the top of each section a base directory path is typically defined. Change these to the base directory of your copy of the entire Unit-Week-Run MH dataset. Alternatively, find and replace all instances of **D:\MH Dataset** with your chosen base path name.
3. Run each section at a time, reading the code and comments to understand what is happening, or just press play.
	- This will take a while to finish.
