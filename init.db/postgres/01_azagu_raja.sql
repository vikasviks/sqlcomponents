DROP TABLE IF EXISTS azagu_raja;
DROP TABLE IF EXISTS azagu_raja_reference;

CREATE TABLE azagu_raja_reference (
    code VARCHAR(80) PRIMARY KEY,
    name VARCHAR(80),
    UNIQUE(name)
);

CREATE TABLE azagu_raja(
   id SERIAL PRIMARY KEY,
   reference_code VARCHAR(80),
   CONSTRAINT fk_code
      FOREIGN KEY(reference_code) 
	  REFERENCES azagu_raja_reference(code)
);
