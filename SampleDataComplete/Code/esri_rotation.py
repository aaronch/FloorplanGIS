#Generates the rotation angle to get georeferenced floorplans back to the AutoCAD rotation using an esri world file.
#Authors: Aaron Cheuvront, Anthony Duc Nguyen, John Tran Vu
#University of Washingngton Capital Projects Office - Information Systems
#Created 05/10/2013

import sys, os, math, arcpy

def extract_data(esri_file):
	"""Given the path to the .wld file, will create a list where each index is a cordinate.
	Ex: ['0,0', '126.907,231.283', '1000,1000', '126.82,23.7459']"""
	
	file = open(esri_file, "r")
	values = []
	for line in file:
		for num in line.split():
			values.append(num)
	return values

def data_transform(values):
	"""Given a list of coordinates in an esri_cad.wld file where each index is a set of coordinates, returns a list where each x and y coordinate is its own index. 
	Ex: [0.0, 0.0, 126.907, 231.283', 1000.0, 1000.0, 126.82, 23.7459]"""
	
	coordinates = [] 
	for coord in values: 
		value = coord.split(',') 
		coordinates.append(float(value[0]))
		coordinates.append(float(value[1])) 
	return coordinates
	
def rotation_calc(pt1, pt2, pt3, pt4, pt5, pt6, pt7, pt8):
	"""Given a list of all the x and y coordinates in an esri_cad.wld file, returns the new rotation."""

	rot1 = math.degrees(math.atan2(pt6 - pt2, pt5 - pt1)) 
	rot2 = math.degrees(math.atan2(pt8 - pt4, pt7 - pt3))
	rot_calc = rot1 - rot2
	return rot_calc

def main():
	esri_file = arcpy.GetParameterAsText(0)
	
	arcpy.AddMessage("This is the rotation:")
	arcpy.AddMessage(rotation_calc(*data_transform(extract_data(esri_file))))
	
if __name__ == "__main__":
	main()

		