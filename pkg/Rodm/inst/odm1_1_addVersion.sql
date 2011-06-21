CREATE TABLE  DataValuesRepository (
	ValueID int(11)  NOT NULL COMMENT 'Same integer identifier as DataValues for each data value.',
	VersionID int(11) NOT NULL COMMENT 'Identifier of the Version of the data',
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

 	PRIMARY KEY  (`ValueID`),
   CONSTRAINT FKValue1ID FOREIGN KEY (ValueID) REFERENCES DataValues (ValueID) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT FKVersionID FOREIGN KEY (VersionID) REFERENCES Versions (VersionID) ON DELETE CASCADE ON UPDATE CASCADE,
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

CREATE TABLE Versions (
	VersionID int(11)  NOT NULL auto_increment COMMENT 'The Version ID',
	ValidUntil datetime NULL COMMENT 'Date when this Version has been replaced',
	VersionComment  varchar(255) NOT NULL COMMENT 'Text describing the reason for the update', 
	PRIMARY KEY (VersionID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='The Versions table records Comments and Valdity Periods for DataValue Entries';

 DELETE FROM ODMVersion;
 INSERT INTO ODMVersion (VersionNumber) Values("1.1Ver");
