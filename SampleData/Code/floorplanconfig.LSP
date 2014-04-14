(defun getfloorplanconfig (/ separator dwgname BUILDINGID FLOORCODE FLOORID)
    ;;;;  this is a configurable code set.  update the variables in the next section depending on your schema

  ;;; DO NOT CHANGE THE VARIABLE NAMES, JUST THE VALUES.
  ;;; the variables are mostly listed as (cons "variable_name" "variable_value").  the values are always preceded by the variable names.

  
  ;this set of variables hard coded
  ;The separator is used to define a character to separate building, floor, and room numbers when building a unique identifier.
  (setq separator "_")
  
  ;this set of variables are based on the drawing name.
  ;dwgname is the drawing name with the dwg stripped off.
  (setq dwgname (substr (getvar "dwgname") 1 (- (strlen (getvar "dwgname"))4))
	;BUILDINGID (substr dwgname 1 4) means for the string dwgname, start at the first character and get 4 characters.
	;drawing name 1027XP_01.dwg would have a buildingID of "1027"
	BUILDINGID (substr dwgname 1 4)
	;FLOORCODE (substr dwgname 8) means for the string dwgname, start at the 8th character and get that character and all remaining characters.
	;drawing name 1027XP_01.dwg would have a floorID of "01"
	FLOORCODE (substr dwgname 8)
	;FLOORID combines the BUILDINGID separator and FLOORCODE into a single string.
	FLOORID (strcat BUILDINGID separator FLOORCODE)
	)
  
  (setq floorplanconfig
	 (LIST
	   ;This set of variables is used to define the configuration for rooms.
	   		;this is the featureclass name to use for rooms.
	       (CONS "INTERIORSPACE_FCNAME" "INTERIORSPACE")
	       		;this is the layer that contains the room boundary polylines
	       (CONS "INTERIORSPACE_LAYER" "A-AREA-PLIN")
	       		;this is the name of the layer that contains the room number blocks
	       (CONS "INTERIORSPACE_BLOCK_LAYER" "A-AREA-RMNO")
	       		;this is the name of the room number block
	       (CONS "INTERIORSPACE_BLOCK_NAME" "ROOM")
	       		;this is the tag name for the room number within the room number block
	       (CONS "INTERIORSPACE_BLOCK_ROOMNUMBER_TAG_NAME" "ROOM_NUMBER")
	       		;this is the tag name for the room area within the room number block.
	       (CONS "INTERIORSPACE_BLOCK_AREA_TAG_NAME" "ROOM_AREA")
	       		;this is the name of the field to use for the globally unique space id that will be created in the interior space featureclass
	       (CONS "SPACEID_NAME" "SPACEID")
	       		;this is the field type for the space id field
	       (CONS "SPACEID_TYPE" "STRING")
	       		;this is the field length for the space id field
	       (CONS "SPACEID_LENGTH" 30)
	       		;this is the name of the room number field in the featureclass that will be created
	       (CONS "ROOMNUMBER_FIELD" "ROOMNUMBER")
       			;this is the field type for the room number field
	       (CONS "ROOMNUMBER_TYPE" "STRING")
	       		;the is the length of the room number field.
	       (CONS "ROOMNUBER_LENGTH" 20)
	       		;this is the name of the room are field.  other config values such as type and length are not available for editing.
	       (CONS "SPACEAREA_FIELD" "SPACEAREA")
	       		;this is the type of value to use for the space id.
	       		;VALUES CAN BE STANDARD OR ROOMNUMBER.
	       		;ROOMNUMBER WILL USE JUST THE ROOM NUMBER VALUE AS THE SPACEID.
	       		;STANDARD WILL USE THE COMBINATION OF BUILDINGID, SEPARATOR, FLOORID, SEPARATOR, ROOMNUMBER
	       (CONS "SPACEID_VALUE" "STANDARD")
	       		;the link prefix and suffix allow you to configure the field for linking the room polyline to the room number block.
	       		;as an example %<\AcObjProp.16.2 Object(%<\_ObjId 8796087856992>%).Area \f "%lu2%pr0%ps[, SQ. FT.]%ct8[0.006944444444444444]">% is a sample link.
	       		;the object id is the part that refers to the polyline, in this case it is 8796087856992
	       		;you can manually configure a link in autocad and copy and paster the prefix and suffix here so that the field will display how you want it.
	       		;for the prefix, DO NOT omit the space after ObjId.
	       (CONS "LINK_PREFIX" "%<\\AcObjProp.16.2 Object(%<\\_ObjId ")
	       (CONS "LINK_SUFFIX" ">%).Area \\f \"%lu2%pr0%ps[, SQ. FT.]%ct8[0.006944444444444444]\">%")


	       ;This set of variables are used to define the configuration for architectural linework 
	       		;this is the name of the featureclass for the architectural linework
	       (CONS "FLOORPLANLINE_FCNAME" "FLOORPLANLINE")
	       		;this controls whether the list of layers will be included or excluded.
	       		;I FOR INCLUSIVE - inclusive will ONLY include the layers listed
	       		;E FOR EXCLUSIVE - exclusive will contain everything in the drawing EXCEPT the layer listed.
	       (CONS "FLOORPLANLINE_LAYER_INCLUSIVE/EXCLUSIVE" "I")
	       		;this is the list of layers for the floorplanline featureclass.
	       		;!!!!!!!!! THI IS A COMMA SEPARATED LIST.  DO NOT USE ANY SPACES TO SEPARATE THE LAYERS!!!!!!!!!!!
	       (CONS "FLOORPLANLINE_LAYERS" "A-DOOR,A-FLOR-LEVL,A-FLOR-STRS,A-FURN-PNLS,A-GLAZ,A-WALL-FULL")

	       
	       ;This set of variables are used to define the configuration for floor boundary polyline
	       		;this is the name of the featureclass that for the floor boundary
	       (CONS "FLOORAREA_FCNAME" "FLOORAREA")
	       		;this is the name of the field that will contain the area of the polyline
	       (CONS "FLOORAREA_FIELD" "FLOOR_AREA")
	       		;this is the layer that contains the floor boundary polyline(s).
	       (CONS "FLOORAREA_LAYER" "A-AREA-GSFT")


	       ; this is a set of drawing based variables to define the schema for buildingid, floor code, and floor id.  refer to your database schema for field length values.
	       		;this is the name of the field used for the building identifier
	       (CONS "BUILDINGID_NAME" "BUILDINGID")
	       		;this is the field type used for the buildingID
	       (CONS "BUILDINGID_TYPE" "STRING")
	       		;this is the length of the field for the buidingID
	       (CONS "BUILDINGID_LENGTH" 4)
	       		;this is the name of the feature class for the globally unique identifier for the floor.
	       (CONS "FLOORID_NAME" "FLOORID")
	       		;this is the field type for the floorid
	       (CONS "FLOORID_TYPE" "STRING")
	       		;this is the field length for the floorid
	       (CONS "FLOORID_LENGTH" 9)
	       		;this is the name of the field for the floor code 
	       (CONS "FLOORCODE_NAME" "FLOORCODE")
	       		;this is the field type for the floor id
	       (CONS "FLOORCODE_TYPE" "STRING")
	       		;this is the field length for the floor id
	       (CONS "FLOORCODE_LENGTH" 4)
	       
	      
	       ; this set of variables are based on the drawing name and/or hard coded values.  refer the the top section for how these are defined.
	       (CONS "SEPARATOR" SEPARATOR)
	       (CONS "DWGNAME" DWGNAME)
	       (CONS "BUILDINGID" BUILDINGID)
	       (CONS "FLOORCODE" FLOORCODE)
	       (CONS "FLOORID" FLOORID)
	       
	      
	       )
	)
  ;;;;;;;;;;;;;;;;;;end config section
  )