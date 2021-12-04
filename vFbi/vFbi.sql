INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_fbi', 'Fbi', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_fbi', 'Fbi', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_fbi', 'Fbi', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
	('fbi', 'FBI')
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('fbi', 0, 'recruit', 'Recrue', 20, '{}', '{}'),
	('fbi', 1, 'officer', 'Officier', 40, '{}', '{}'),
	('fbi', 2, 'sergeant', 'Sergent', 60, '{}', '{}'),
	('fbi', 3, 'lieutenant', 'Lieutenant', 85, '{}', '{}'),
	('fbi', 4, 'boss','Commandant', 100, '{}', '{}');