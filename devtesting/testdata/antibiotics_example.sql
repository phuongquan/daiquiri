/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [PrescriptionID]
	,Clusterid + 6428 as PatientID
      ,[PrescriptionDate]
      ,[PrescriptionType]
      ,[AdmissionDate]
      ,[Drug]
      ,[Formulation]
      ,[Dose]
      ,[DoseUnit]
      ,[FirstAdministrationDateTime]
      ,[NumberOfDosesAdministered]
      ,[AntibioticsSource]
  FROM [PSS2_Snapshot].[pss2_snapshot].[antibiotics]
  where [PrescriptionDate] between '20140701' and '20150101'
  and right(cast(Clusterid as varchar),1)  in (1,3,5,7,9)