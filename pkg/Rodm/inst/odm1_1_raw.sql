
CREATE TABLE  CensorCodeCV (
	Term varchar(255) NOT NULL COMMENT 'Controlled vocabulary for CensorCode.', 
	Definition  varchar(255) COMMENT 'Definition of CensorCode controlled vocabulary term. The definition is optional if the term is self explanatory.', 
	PRIMARY KEY  (Term)
) ENGINE=InnoDB DEFAULT CHARSET=latin1  COMMENT='The CensorCodeCV table contains the controlled vocabulary for censor codes. Only values from the Term field in this table can be used to populate the CensorCode field of the DataValues table.';


CREATE TABLE  DataTypeCV (
	Term varchar(255) NOT NULL COMMENT 'Controlled vocabulary for DataType.', 
	Definition  varchar(255) COMMENT 'Definition of DataType controlled vocabulary term. The definition is optional if the term is self explanatory.', 
	PRIMARY KEY  (Term)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The DataTypeCV table contains the controlled vocabulary for data types. Only values from the Term field in this table can be used to populate the DataType field in the Variables table.';





CREATE TABLE  GeneralCategoryCV (
	Term  varchar(255) NOT NULL COMMENT 'Controlled vocabulary for GeneralCategory.', 
	Definition  varchar(255) NOT NULL COMMENT 'Definition of GeneralCategory controlled vocabulary term. The definition is optional if the term is self explanatory.', 
 	PRIMARY KEY  (Term)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The GeneralCategoryCV table contains the controlled vocabulary for the general categories associated with Variables. The GeneralCategory field in the Variables table can only be populated with values from the Term field of this controlled vocabulary table.';

CREATE TABLE  GroupDescriptions (
	GroupID int(11)  NOT NULL COMMENT 'Unique integer identifier for each group of data values that has been formed.  This also references to GroupID in the Groups table.',
	GroupDescription  varchar(255) NOT NULL COMMENT 'Text description of the group.', 
 	PRIMARY KEY  (GroupID)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The GroupDescriptions table lists the descriptions for each of the groups of data values that have been formed.';




CREATE TABLE  LabMethods (
	LabMethodID int(11)  NOT NULL auto_increment COMMENT 'Unique integer identifier for each laboratory method. This is the key used by the Samples table to reference a laboratory method.',
	LabName  varchar(255) NOT NULL COMMENT 'Name of the laboratory responsible for processing the sample.', 
	LabOrganization  varchar(255) NOT NULL COMMENT 'Organization responsible for sample analysis.', 
	LabMethodName  varchar(255) NOT NULL COMMENT 'Name of the method and protocols used for sample analysis.', 
	LabMethodDescription  varchar(255) NOT NULL COMMENT 'Description of the method and protocols used for sample analysis.', 
	LabMethodLink  varchar(255) NOT NULL COMMENT 'Link to additional reference material on the analysis method.', 
 	PRIMARY KEY  (LabMethodID)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The LabMethods table contains descriptions of the laboratory methods used to analyze physical samples for specific constituents.';

CREATE TABLE  Methods (
	MethodID int(11)  NOT NULL auto_increment COMMENT 'Unique integer ID for each method.',
	MethodDescription  varchar(255) NOT NULL COMMENT 'Text description of each method.', 
	MethodLink  varchar(255) NOT NULL COMMENT 'Link to additional reference material on the method.', 
 	PRIMARY KEY  (MethodID)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The Methods table lists the methods used to collect the data and any additional information about the method.';

CREATE TABLE  ODMVersion (
	VersionNumber  varchar(50) NOT NULL COMMENT 'String that lists the version of the ODM database.', 
 	PRIMARY KEY  (VersionNumber)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The ODM Version table has a single record that records the version of the ODM database. This table must contain a valid ODM version number. This table will be pre-populated and should not be edited.';



CREATE TABLE  Qualifiers (
	QualifierID int(11)  NOT NULL auto_increment COMMENT 'Unique integer identifying the data qualifier.',
	QualifierCode  varchar(50) NOT NULL COMMENT 'Text code used by organization that collects the data.', 
	QualifierDescription  varchar(255) NOT NULL COMMENT 'Text of the data qualifying comment.', 
 	PRIMARY KEY  (QualifierID)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The Qualifiers table contains data qualifying comments that accompany the data.';

CREATE TABLE  QualityControlLevels (
	QualityControlLevelID int(11)  NOT NULL COMMENT 'Unique integer identifying the quality control level.',
	QualityControlLevelCode  varchar(50) NOT NULL COMMENT 'Code used to identify the level of quality control to which data values have been subjected.', 
	Definition  varchar(255) NOT NULL COMMENT 'Definition of Quality Control Level.', 
	Explanation  varchar(255) NOT NULL COMMENT 'Explanation of Quality Control Level', 
 	PRIMARY KEY  (QualityControlLevelID)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The QualityControlLevels table contains the quality control levels that are used for versioning data within the database.';

CREATE TABLE  SampleMediumCV (
	Term  varchar(255) NOT NULL COMMENT 'Controlled vocabulary for sample media.', 
	Definition  varchar(255) NOT NULL COMMENT 'Definition of sample media controlled vocabulary term. The definition is optional if the term is self explanatory.', 
 	PRIMARY KEY  (Term)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The SampleMediumCV table contains the controlled vocabulary for sample media.';

CREATE TABLE  SampleTypeCV (
	Term  varchar(255) NOT NULL COMMENT 'Controlled vocabulary for sample type.', 
	Definition  varchar(255) NOT NULL COMMENT 'Definition of sample type controlled vocabulary term. The definition is optional if the term is self explanatory.', 
 	PRIMARY KEY  (Term)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The SampleTypeCV table contains the controlled vocabulary for sample type.';


CREATE TABLE  Samples (
	SampleID int(11)  NOT NULL auto_increment COMMENT 'Unique integer identifier that identifies each physical sample.',
	SampleType  varchar(255) NOT NULL COMMENT 'Controlled vocabulary specifying the sample type from the SampleTypeCV table.', 
	LabSampleCode  varchar(50) NOT NULL COMMENT 'Code or label used to identify and track lab sample or sample container (e.g. bottle) during lab analysis.', 
	LabMethodID int(11)  NOT NULL COMMENT 'Unique identifier for the laboratory method used to process the sample. This references the LabMethods table.',
 	PRIMARY KEY  (SampleID),
   CONSTRAINT FKSampleType FOREIGN KEY (SampleType) REFERENCES SampleTypeCV (Term) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT FKLabMethodID FOREIGN KEY (LabMethodID) REFERENCES LabMethods (LabMethodID) ON DELETE CASCADE ON UPDATE CASCADE 

 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The Samples table gives information about physical samples analyzed in a laboratory.';







CREATE TABLE  SpatialReferences (
	SpatialReferenceID int(11)  NOT NULL COMMENT 'Unique integer identifier for each Spatial Reference System.',
	SRSID int(11)  NOT NULL COMMENT 'Integer identifier for the Spatial Reference System from http://www.epsg.org/.',
	SRSName  varchar(255) NOT NULL COMMENT 'Name of the Spatial Reference System.', 
	IsGeographic  boolean NOT NULL COMMENT 'Value that indicates whether the spatial reference system uses geographic coordinates (i.e. latitude and longitude) or not.', 
	Notes  varchar(255) NOT NULL COMMENT 'Descriptive information about the Spatial Reference System. This field would be used to define a non-standard study area specific system if necessary and would contain a description of the local projection information. Where possible, this should refer to a standard projection, in which case latitude and longitude can be determined from local projection information. If the local grid system is non-standard then latitude and longitude need to be included too.', 
 	PRIMARY KEY  (SpatialReferenceID)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The SpatialReferences table provides information about the Spatial Reference Systems used for latitude and longitude as well as local coordinate systems in the Sites table. This table is a controlled vocabulary.';


CREATE TABLE  SpeciationCV (
	Term  varchar(255) NOT NULL COMMENT 'Controlled vocabulary for Speciation.', 
	Definition  varchar(255) NOT NULL COMMENT 'Definition of Speciation controlled vocabulary term. The definition is optional if the term is self explanatory.', 
 	PRIMARY KEY  (Term)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The SpeciationCV table contains the controlled vocabulary for the Speciation field in the Variables table.';

CREATE TABLE  TopicCategoryCV (
	Term  varchar(255) NOT NULL COMMENT 'Controlled vocabulary for TopicCategory.', 
	Definition  varchar(255) NOT NULL COMMENT 'Definition of TopicCategory controlled vocabulary term. The definition is optional if the term is self explanatory.', 
 	PRIMARY KEY  (Term)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The TopicCategoryCV table contains the controlled vocabulary for the ISOMetaData topic categories.';

CREATE TABLE  ISOMetadata (
	MetadataID int(11)  NOT NULL auto_increment COMMENT 'Unique integer ID for each metadata record.',
	TopicCategory  varchar(255) NOT NULL COMMENT 'Topic category keyword that gives the broad ISO19115 metadata topic category for data from this source. The controlled vocabulary of topic category keywords is given in the TopicCategoryCV table.', 
	Title  varchar(255) NOT NULL COMMENT 'Title of data from a specific data source.', 
	Abstract  varchar(255) NOT NULL COMMENT 'Abstract of data from a specific data source.
', 
	ProfileVersion  varchar(255) NOT NULL COMMENT 'Name of metadata profile used by the data source', 
	MetadataLink  varchar(255) NOT NULL COMMENT 'Link to additional metadata reference material.', 
 	PRIMARY KEY  (MetadataID),
   CONSTRAINT FKTopicCategory FOREIGN KEY (TopicCategory) REFERENCES TopicCategoryCV (Term) ON DELETE CASCADE ON UPDATE CASCADE
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The ISOMetadata table contains dataset and project level metadata required by the CUAHSI HIS metadata system (http://www.cuahsi.org/his/documentation.html) for compliance with standards such as the draft ISO 19115 or ISO 8601. The mandatory fields in this table must be populated to provide a complete set of ISO compliant metadata in the database.';

CREATE TABLE  Sources (
	SourceID int(11)  NOT NULL auto_increment COMMENT 'Unique integer identifier that identifies each data source.',
	Organization  varchar(255) NOT NULL COMMENT 'Name of the organization that collected the data. This should be the agency or organization that collected the data, even if it came out of a database consolidated from many sources such as STORET.', 
	SourceDescription  varchar(255) NOT NULL COMMENT 'Full text description of the source of the data.', 
	SourceLink  varchar(500) NOT NULL COMMENT 'Link that can be pointed at the original data file and/or associated metadata stored in the digital library or URL of data source.', 
	ContactName  varchar(255) NOT NULL COMMENT 'Name of the contact person for the data source.', 
	Phone  varchar(255) NOT NULL COMMENT 'Phone number for the contact person.', 
	Email varchar(255) NOT NULL COMMENT 'Email address for the contact person.', 
	Address  varchar(255) NOT NULL COMMENT 'Street address for the contact person.', 
	City  varchar(255) NOT NULL COMMENT 'City in which the contact person is located.', 
	State  varchar(255) NOT NULL COMMENT 'State in which the contact person is located. Use two letter abbreviations for US.  For other countries give the full country name.', 
	ZipCode  varchar(255) NOT NULL COMMENT 'US Zip Code or country postal code.', 
	Citation  varchar(255) NOT NULL COMMENT 'Text string that give the citation to be used when the data from each source are referenced.', 
	MetadataID int(11)  NOT NULL COMMENT 'Integer identifier referencing the record in the ISOMetadata table for this source.',
 	PRIMARY KEY  (SourceID),
   CONSTRAINT FKMetadataID FOREIGN KEY (MetadataID) REFERENCES ISOMetadata (MetadataID) ON DELETE CASCADE ON UPDATE CASCADE

 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The Sources table lists the original sources of the data, providing information sufficient to retrieve and reconstruct the data value from the original data files if necessary.';

CREATE TABLE  Units (
	UnitsID int(11)  NOT NULL COMMENT 'Unique integer identifier that identifies each unit.',
	UnitsName  varchar(255) NOT NULL COMMENT 'Full text name of the units.', 
	UnitsType  varchar(255) NOT NULL COMMENT 'Text value that specifies the dimensions of the units.', 
	UnitsAbbreviation varchar(255) NOT NULL COMMENT 'Text abbreviation for the units.',  
 	PRIMARY KEY  (UnitsID)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The Units table gives the Units and UnitsType associated with variables, time support, and offsets. This is a controlled vocabulary table.';

CREATE TABLE  OffsetTypes (
	OffsetTypeID int(11)  NOT NULL auto_increment COMMENT 'Unique integer identifier that identifies the type of measurement offset.',
	OffsetUnitsID int(11)  NOT NULL COMMENT 'Integer identifier that references the record in the Units table giving the Units of the OffsetValue.',
	OffsetDescription  varchar(255) NOT NULL COMMENT 'Full text description of the offset type.', 
 	PRIMARY KEY  (OffsetTypeID),
   CONSTRAINT FKOffsetUnitsID FOREIGN KEY (OffsetUnitsID) REFERENCES Units (UnitsID) ON DELETE CASCADE ON UPDATE CASCADE

 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The OffsetTypes table lists full descriptive information for each of the measurement offsets.';


CREATE TABLE  ValueTypeCV (
	Term  varchar(255) NOT NULL COMMENT 'Controlled vocabulary for ValueType.', 
	Definition  varchar(255) NOT NULL COMMENT 'Definition of the ValueType controlled vocabulary term. The definition is optional if the term is self explanatory.', 
 	PRIMARY KEY  (Term)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The ValueTypeCV table contains the controlled vocabulary for the ValueType field in the Variables and SeriesCatalog tables.';

CREATE TABLE  VariableNameCV (
	Term  varchar(255) NOT NULL COMMENT 'Controlled vocabulary for VariableName.', 
	Definition  varchar(255) NOT NULL COMMENT 'Definition of the VariableName controlled vocabulary term. The definition is optional if the term is self explanatory.', 
 	PRIMARY KEY  (Term)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The VariableName CV table contains the controlled vocabulary for the VariableName field in the Variables and SeriesCatalog tables.';

CREATE TABLE  Variables (
	VariableID int(11)  NOT NULL auto_increment COMMENT 'Description Unique integer identifier for each variable.',
	VariableCode  varchar(50) NOT NULL COMMENT 'Text code used by the organization that collects the data to identify the variable.', 
	VariableName  varchar(255) NOT NULL COMMENT 'Full text name of the variable that was measured, observed, modeled, etc. This should be from the VariableNameCV controlled vocabulary table.', 
	Speciation  varchar(255) NOT NULL COMMENT 'Text code used to identify how the data value is expressed (i.e., total phosphorus concentration expressed as P). This should be from the SpeciationCV controlled vocabulary table.', 
	VariableUnitsID int(11)  NOT NULL COMMENT 'Integer identifier that references the record in the Units table giving the units of the data values associated with the variable.',
	SampleMedium  varchar(255) NOT NULL COMMENT 'The medium in which the sample or observation was taken or made. This should be from the SampleMediumCV controlled vocabulary table.', 
	ValueType  varchar(255) NOT NULL COMMENT 'Text value indicating what type of data value is being recorded.  This should be from the ValueTypeCV controlled vocabulary table.', 
	IsRegular  boolean NOT NULL COMMENT 'Value that indicates whether the data values are from a regularly sampled time series.', 
	TimeSupport  double NOT NULL COMMENT 'Numerical value that indicates the time support (or temporal footprint) of the data values. 0 is used to indicate data values that are instantaneous. Other values indicate the time over which the data values are implicitly or explicitly averaged or aggregated.', 
	TimeUnitsID int(11)  NOT NULL COMMENT 'Integer identifier that references the record in the Units table giving the Units of the time support. If TimeSupport is 0, indicating an instantaneous observation, a unit needs to still be given for completeness, although it is somewhat arbitrary.',
	DataType  varchar(255) NOT NULL COMMENT 'Text value that identifies the data values as one of several types from the DataTypeCV controlled vocabulary table.', 
	GeneralCategory  varchar(255) NOT NULL COMMENT 'General category of the data values from the GeneralCategoryCV controlled vocabulary table.', 
	NoDataValue  double NOT NULL COMMENT 'Numeric value used to encode no data values for this variable.', 
 	PRIMARY KEY  (VariableID),
    CONSTRAINT FKVariableName FOREIGN KEY (VariableName) REFERENCES VariableNameCV (Term) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKSpeciation FOREIGN KEY (Speciation) REFERENCES SpeciationCV (Term) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKSampleMedium FOREIGN KEY (SampleMedium) REFERENCES SampleMediumCV (Term) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKValueType FOREIGN KEY (ValueType) REFERENCES ValueTypeCV (Term) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKDataType FOREIGN KEY (DataType) REFERENCES DataTypeCV (Term) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKGeneralCategory FOREIGN KEY (GeneralCategory) REFERENCES GeneralCategoryCV (Term) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKTimeUnitsID FOREIGN KEY (TimeUnitsID) REFERENCES Units (UnitsID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKVariableUnitsID FOREIGN KEY (VariableUnitsID) REFERENCES Units (UnitsID) ON DELETE CASCADE ON UPDATE CASCADE

 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The Variables table lists the full descriptive information about what variables have been measured.';

CREATE TABLE  Categories (
	VariableID int(11)  NOT NULL COMMENT 'Integer identifier that references the Variables record of a categorical variable.',
	DataValue double NOT NULL COMMENT 'Numeric value that defines the category',
	CategoryDescription varchar(255) NOT NULL COMMENT 'Definition of categorical variable value',
	PRIMARY KEY  (VariableID, DataValue),
        CONSTRAINT Categories_fk FOREIGN KEY (VariableID) REFERENCES Variables (VariableID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The Categories table defines the categories for categorical variables. Records are required for variables where DataType is specified as "Categorical." Multiple entries for each VariableID, with different DataValues provide the mapping from DataValue to category description.';


CREATE TABLE  VerticalDatumCV (
	Term  varchar(255) NOT NULL COMMENT 'Description Controlled vocabulary for VerticalDatum.', 
	Definition  varchar(255) NOT NULL COMMENT 'Definition of the VerticalDatum controlled vocabulary. The definition is optional if the term is self explanatory.', 
 	PRIMARY KEY  (Term)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The VerticalDatumCV table contains the controlled vocabulary for the VerticalDatum field in the Sites table.';

CREATE TABLE  Sites  (

	SiteID int(11)  NOT NULL auto_increment COMMENT 'Unique identifier for each sampling location.',
	SiteCode varchar(50) NOT NULL COMMENT 'Code used by organization that collects the data to identify the site',  
	SiteName  varchar(255) NOT NULL COMMENT 'Full name of the sampling site.', 
	Latitude double NOT NULL COMMENT 'Latitude in decimal degrees.',
	Longitude double NOT NULL COMMENT 'Longitude in decimal degrees.  East positive, West negative.', 
	LatLongDatumID int(11)  NOT NULL COMMENT 'Identifier that references the Spatial Reference System of the latitude and longitude coordinates in the SpatialReferences table.',
	Elevation_m  double NOT NULL COMMENT 'Elevation of sampling location (in m). If this is not provided it needs to be obtained programmatically from a DEM based on location information.', 
	VerticalDatum  varchar(255) NOT NULL COMMENT 'Vertical datum of the elevation.  Controlled Vocabulary from VerticalDatumCV.', 
	LocalX  double NOT NULL COMMENT 'Local Projection X coordinate.', 
	LocalY double NOT NULL COMMENT 'Local Projection Y Coordinate.', 
	LocalProjectionID int(11)  NOT NULL COMMENT 'Description Identifier that references the Spatial Reference System of the local coordinates in the SpatialReferences table. This field is required if local coordinates are given.',
	PosAccuracy_m  double NOT NULL COMMENT 'Value giving the accuracy with which the positional information is specified in meters.', 
	State  varchar(255) NOT NULL COMMENT 'Name of state in which the monitoring site is located.', 
	County  varchar(255) NOT NULL COMMENT 'Name of county in which the monitoring site is located.', 
	Comments  varchar(255) NOT NULL COMMENT 'Comments related to the site.', 
 	PRIMARY KEY  (SiteID),
    CONSTRAINT FKLatLongDatumID FOREIGN KEY (LatLongDatumID) REFERENCES SpatialReferences (SpatialReferenceID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKLocalProjectionID FOREIGN KEY (LocalProjectionID) REFERENCES SpatialReferences (SpatialReferenceID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKVerticalDatumID FOREIGN KEY (VerticalDatum) REFERENCES VerticalDatumCV (Term) ON DELETE CASCADE ON UPDATE CASCADE

 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'The Sites table provides information giving the spatial location at which data values have been collected.';





CREATE TABLE  DataValues (
	ValueID int(11)  NOT NULL auto_increment COMMENT 'Unique integer identifier for each data value.',
	DataValue  double NOT NULL COMMENT 'The numeric value of the observation. For Categorical variables, a number is stored here.  The Variables table has DataType as Categorical and the Categories table maps from the DataValue onto Category Description.',
	ValueAccuracy double default NULL COMMENT 'Numeric value that describes the measurement accuracy of the data value. If not given, it is interpreted as unknown.',
	LocalDateTime datetime NOT NULL COMMENT 'Local date and time at which the data value was observed.  Represented in an implementation specific format.',
	UTCOffset  double NOT NULL COMMENT 'Offset in hours from UTC time of the corresponding LocalDateTime value.',
	DateTimeUTC datetime NOT NULL COMMENT 'Universal UTC date and time at which the data value was observed.  Represented in an implementation specific format.',
	SiteID int(11)  NOT NULL COMMENT 'Integer identifier that references the site at which the observation was measured. This links data values to their locations in the Sites table.',
	VariableID int(11)  NOT NULL COMMENT 'Integer identifier that references the variable that was measured. This links data values to their variable in the Variables table.',
	OffsetValue  double default NULL COMMENT 'Distance from a datum or control point to the point at which a data value was observed. If not given the OffsetValue is inferred to be 0, or not relevant/necessary. NULL = No Offset',
	OffsetTypeID int(11)  default NULL COMMENT 'Integer identifier that references the measurement offset type in the OffsetTypes table. NULL = No Offset',
	CensorCode  varchar(50) NOT NULL COMMENT 'Text indication of whether the data value is censored from the CensorCodeCV controlled vocabulary. “nc” = Not Censored', 
	QualifierID int(11)  default NULL COMMENT 'Integer identifier that references the Qualifiers table. If Null, the data value is inferred to not be qualified.',
	MethodID int(11)  NOT NULL COMMENT 'Integer identifier that references method used to generate the data value in the Methods table.  0 = No method specified',
	SourceID int(11)  NOT NULL COMMENT 'Integer identifier that references the record in the Sources table giving the source of the data value.',
	SampleID int(11)  default NULL COMMENT 'Integer identifier that references into the Samples table. This is required only if the data value resulted from a physical sample processed in a lab.',
	DerivedFromID int(11)  default NULL COMMENT 'Integer identifier for the derived from group of data values that the current data value is derived from.  This refers to a group of derived from records in the DerivedFrom table. If NULL, the data value is inferred to not be derived from another data value.',
	QualityControlLevelID int(11)  NOT NULL COMMENT 'Integer identifier giving the level of quality control that the value has been subjected to. This references the QualityControlLevels table.  -9999 = Unknown',

 	PRIMARY KEY  (ValueID),
    CONSTRAINT FKSiteID FOREIGN KEY (SiteID) REFERENCES Sites (SiteID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKVariableID FOREIGN KEY (VariableID) REFERENCES Variables (VariableID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKOffsetTypeID FOREIGN KEY (OffsetTypeID) REFERENCES OffsetTypes (OffsetTypeID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKCensorCodeID FOREIGN KEY (CensorCode) REFERENCES CensorCodeCV (Term) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKQualifierID FOREIGN KEY (QualifierID) REFERENCES Qualifiers (QualifierID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKMethodID FOREIGN KEY (MethodID) REFERENCES Methods (MethodID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKSourceID FOREIGN KEY (SourceID) REFERENCES Sources (SourceID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKSampleID FOREIGN KEY (SampleID) REFERENCES Samples (SampleID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKQualityControlLevelID FOREIGN KEY (QualityControlLevelID) REFERENCES QualityControlLevels (QualityControlLevelID) ON DELETE CASCADE ON UPDATE CASCADE

 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The DataValues table contains the actual data values.';

CREATE TABLE  Groups (
	GroupID int(11)  NOT NULL COMMENT 'Integer ID for each group of data values that has been formed.',
	ValueID int(11)  NOT NULL COMMENT 'Integer identifier for each data value that belongs to a group. This corresponds to ValueID in the DataValues table',
 	PRIMARY KEY  (GroupID, ValueID),
    CONSTRAINT FKGroupID FOREIGN KEY (GroupID) REFERENCES GroupDescriptions (GroupID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKValueID2 FOREIGN KEY (ValueID) REFERENCES DataValues (ValueID) ON DELETE CASCADE ON UPDATE CASCADE
     

 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The Groups table lists the groups of data values that have been created and the data values that are within each group.';

CREATE TABLE  DerivedFrom (
	DerivedFromID int(11)  NOT NULL COMMENT 'Integer identifying the group of data values from which a quantity is derived.',
	ValueID int(11)  NOT NULL COMMENT 'Integer identifier referencing data values that comprise a group from which a quantity is derived. This corresponds to ValueID in the DataValues table.',
 
 	PRIMARY KEY  (DerivedFromID, ValueID),
    CONSTRAINT FKDerivedFromID FOREIGN KEY (DerivedFromID) REFERENCES DataValues (ValueID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKValueID FOREIGN KEY (ValueID) REFERENCES DataValues (ValueID) ON DELETE CASCADE ON UPDATE CASCADE
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The DerivedFrom table contains the linkage between derived data values and the data values that they were derived from.';



CREATE TABLE  SeriesCatalog (
 
	SeriesID int(11)  NOT NULL auto_increment COMMENT 'Unique integer identifier for each data series.',
	SiteID int(11)  NOT NULL COMMENT 'Site identifier from the Sites table.',
	SiteCode varchar(50) NOT NULL COMMENT 'Site code used by organization that collects the data.',  
	SiteName  varchar(255) NOT NULL COMMENT 'Full text name of sampling site.', 
	VariableID int(11)  NOT NULL COMMENT 'Integer identifier for each Variable that references the Variables table.',
	VariableCode varchar(50) NOT NULL COMMENT 'Variable code used by the organization that collects the data.',  
	VariableName varchar(255) NOT NULL COMMENT 'Name of the variable from the variables table.',  
	Speciation varchar(255) NOT NULL COMMENT 'Code used to identify how the data value is expressed (i.e., total phosphorus concentration expressed as P). This should be from the SpeciationCV controlled vocabulary table.',  
	VariableUnitsID int(11)  NOT NULL COMMENT 'Integer identifier that references the record in the Units table giving the Units of the data value.',
	VariableUnitsName varchar(255) NOT NULL COMMENT 'Full text name of the variable units from the UnitsName field in the Units table.',  
	SampleMedium  varchar(255) NOT NULL COMMENT 'The medium of the sample. This should be from the SampleMediumCV controlled vocabulary table.', 
	ValueType varchar(255) NOT NULL COMMENT 'Text value indicating what type of data value is being recorded. This should be from the ValueTypeCV controlled vocabulary table.',  
	TimeSupport double NOT NULL COMMENT 'Numerical value that indicates the time support (or temporal footprint) of the data values. 0 is used to indicate data values that are instantaneous. Other values indicate the time over which the data values are implicitly or explicitly averaged or aggregated.',
	TimeUnitsID int(11)  NOT NULL COMMENT 'Integer identifier that references the record in the Units table giving the Units of the time support. If TimeSupport is 0, indicating an instantaneous observation, a unit needs to still be given for completeness, although it is somewhat arbitrary.',
	TimeUnitsName varchar(255) NOT NULL COMMENT 'Full text name of the time support units from the UnitsName field in the Units table.',  
	DataType varchar(255) NOT NULL COMMENT 'Text value that identifies the data as one of several types from the DataTypeCV controlled vocabulary table.',  
	GeneralCategory varchar(255) NOT NULL COMMENT 'General category of the variable from the GeneralCategoryCV table.',  
	MethodID int(11)  NOT NULL COMMENT 'Integer identifier that identifies the method used to generate the data values and references the Methods table.',
	MethodDescription varchar(255) NOT NULL COMMENT 'Full text description of the method used to generate the data values.',  
	SourceID int(11)  NOT NULL COMMENT 'Integer identifier that identifies the source of the data values and references the Sources table.',
	Organization varchar(255) NOT NULL COMMENT 'Text description of the source organization from the Sources table.',  
	SourceDescription varchar(255) NOT NULL COMMENT 'Text description of the data source from the Sources table.',  
	Citation varchar(255) NOT NULL COMMENT 'Text string that give the citation to be used when the data from each source are referenced.',  
	QualityControlLevelID int(11)  NOT NULL COMMENT 'Integer identifier that indicates the level of quality control that the data values have been subjected to.',
	QualityControlLevelCode varchar(50) NOT NULL COMMENT 'Code used to identify the level of quality control to which data values have been subjected.',  
	BeginDateTime datetime NOT NULL COMMENT 'Date of the first data value in the series. To be programmatically updated if new records are added.', 
	EndDateTime datetime NOT NULL COMMENT 'Date of the last data value in the series. To be programmatically updated if new records are added.', 
	BeginDateTimeUTC datetime NOT NULL COMMENT 'Date of the first data value in the series in UTC. To be programmatically updated if new records are added.', 
	EndDateTimeUTC datetime NOT NULL COMMENT 'Date of the last data value in the series in UTC. To be programmatically updated if new records are added.', 
	ValueCount int(11)  NOT NULL COMMENT 'The number of data values in the series identified by the combination of the SiteID, VariableID, MethodID, SourceID and QualityControlLevelID fields.  To be programmatically updated if new records are added.',
 	PRIMARY KEY  (SeriesID),
    CONSTRAINT FKSiteID2 FOREIGN KEY (SiteID) REFERENCES Sites (SiteID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKVariableID2 FOREIGN KEY (VariableID) REFERENCES Variables (VariableID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKMethodID2 FOREIGN KEY (MethodID) REFERENCES Methods (MethodID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKSourceID2 FOREIGN KEY (SourceID) REFERENCES Sources (SourceID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKQualityControlLevelID2 FOREIGN KEY (QualityControlLevelID) REFERENCES QualityControlLevels (QualityControlLevelID) ON DELETE CASCADE ON UPDATE CASCADE

 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'The SeriesCatalog table lists each separate data series in the database for the purposes of identifying or displaying what data are available at each site and to speed simple queries without querying the main DataValues table. Unique site/variable combinations are defined by unique combinations of SiteID, VariableID, MethodID, SourceID, and QualityControlLevelID.  This entire table should be programmatically derived and should be updated every time data is added to the database. Constraints on each field in the SeriesCatalog table are dependent upon the constraints on the fields in the table from which those fields originated.' ;

 INSERT INTO ODMVersion (VersionNumber) Values('1.1');
