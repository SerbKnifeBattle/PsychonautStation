/datum/crewmonitor
	jobs = list(
		// Note that jobs divisible by 10 are considered heads of staff, and bolded
		// 00: Captain
		JOB_CAPTAIN = 00,
		// 10-19: Security
		JOB_HEAD_OF_SECURITY = 10,
		JOB_WARDEN = 11,
		JOB_SECURITY_OFFICER = 12,
		JOB_SECURITY_OFFICER_MEDICAL = 13,
		JOB_SECURITY_OFFICER_ENGINEERING = 14,
		JOB_SECURITY_OFFICER_SCIENCE = 15,
		JOB_SECURITY_OFFICER_SUPPLY = 16,
		JOB_DETECTIVE = 17,
		JOB_BRIG_PHYSICIAN = 18,
		// 20-29: Medbay
		JOB_CHIEF_MEDICAL_OFFICER = 20,
		JOB_CHEMIST = 21,
		JOB_VIROLOGIST = 22,
		JOB_MEDICAL_DOCTOR = 23,
		JOB_PARAMEDIC = 24,
		// 30-39: Science
		JOB_RESEARCH_DIRECTOR = 30,
		JOB_SCIENTIST = 31,
		JOB_ROBOTICIST = 32,
		JOB_GENETICIST = 33,
		// 40-49: Engineering
		JOB_CHIEF_ENGINEER = 40,
		JOB_STATION_ENGINEER = 41,
		JOB_ATMOSPHERIC_TECHNICIAN = 42,
		JOB_WORKER = 43,
		// 50-59: Cargo
		JOB_QUARTERMASTER = 50,
		JOB_SHAFT_MINER = 51,
		JOB_CARGO_TECHNICIAN = 52,
		// 60+: Civilian/other
		JOB_HEAD_OF_PERSONNEL = 60,
		JOB_BARTENDER = 61,
		JOB_COOK = 62,
		JOB_BOTANIST = 63,
		JOB_CURATOR = 64,
		JOB_CHAPLAIN = 65,
		JOB_CLOWN = 66,
		JOB_MIME = 67,
		JOB_JANITOR = 68,
		JOB_LAWYER = 69,
		JOB_PSYCHOLOGIST = 71,
		// 200-229: Centcom
		JOB_CENTCOM_ADMIRAL = 200,
		JOB_CENTCOM = 201,
		JOB_CENTCOM_OFFICIAL = 210,
		JOB_CENTCOM_COMMANDER = 211,
		JOB_CENTCOM_BARTENDER = 212,
		JOB_CENTCOM_CUSTODIAN = 213,
		JOB_CENTCOM_MEDICAL_DOCTOR = 214,
		JOB_CENTCOM_RESEARCH_OFFICER = 215,
		JOB_ERT_COMMANDER = 220,
		JOB_ERT_OFFICER = 221,
		JOB_ERT_ENGINEER = 222,
		JOB_ERT_MEDICAL_DOCTOR = 223,
		JOB_ERT_CLOWN = 224,
		JOB_ERT_CHAPLAIN = 225,
		JOB_ERT_JANITOR = 226,
		JOB_ERT_DEATHSQUAD = 227,

		// ANYTHING ELSE = UNKNOWN_JOB_ID, Unknowns/custom jobs will appear after civilians, and before assistants
		JOB_ASSISTANT = 999,
	)
