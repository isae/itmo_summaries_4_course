DROP DATABASE IF EXISTS laundry;
CREATE DATABASE laundry CHARACTER SET utf8 COLLATE utf8_bin;
USE laundry;

CREATE TABLE model (
  id INT NOT NULL,
  name VARCHAR(32) NOT NULL,
  max_load INT NOT NULL,
  CONSTRAINT model_pk PRIMARY KEY(id)
);

CREATE TABLE washer (
  id INT NOT NULL,
  model_id INT NOT NULL,
  CONSTRAINT washer_pk PRIMARY KEY(id,model_id),
  CONSTRAINT washer_model_id FOREIGN KEY(model_id) REFERENCES model(id)
);

CREATE TABLE tariff (
  id INT NOT NULL,
  name VARCHAR(32) NOT NULL,
  cost INT NOT NULL,
  duration INT DEFAULT 120,
  CONSTRAINT tariff_pk PRIMARY KEY (id)
);

CREATE TABLE fitness (
  tariff_id INT NOT NULL,
  washer_id INT NOT NULL,
  model_id INT NOT NULL,
  CONSTRAINT fit_pk PRIMARY KEY (tariff_id, washer_id, model_id),
  CONSTRAINT fit_tariff_id FOREIGN KEY (tariff_id) REFERENCES tariff(id),
  CONSTRAINT fit_model_id FOREIGN KEY (model_id) REFERENCES model(id),
  CONSTRAINT fit_washer_id FOREIGN KEY (washer_id, model_id) REFERENCES washer(id, model_id)
);

CREATE TABLE occupation (
  tariff_id INT NOT NULL,
  washer_id INT NOT NULL,
  model_id INT NOT NULL,
  start_time DATETIME NOT NULL,
  run_load INT NOT NULL,
  CONSTRAINT occup_fk FOREIGN KEY (tariff_id, washer_id, model_id)
    REFERENCES fitness (tariff_id, washer_id, model_id)
);

ALTER TABLE occupation ADD CONSTRAINT occup_pk PRIMARY KEY (tariff_id, washer_id, model_id, start_time);

SHOW TABLES;

INSERT INTO model (id, name, max_load) VALUES
  (1, 'WM Regular08', 5),
  (2, 'Катюша505', 5),
  (3, 'WM Big325', 10),
  (4, 'WM Huge9000', 18);

INSERT INTO washer (id, model_id) VALUES
  (1,1), (2,1), (3,1), (4,1), (5,1),
  (6,2),
  (7,3), (8,3),
  (9,4);

INSERT INTO tariff (id, name, cost) VALUES 
  (1, 'Just wash', 100),
  (2, 'Drying', 100),
  (3, 'Lux premium wash', 200);

INSERT INTO tariff (id, name, cost, duration) VALUES 
  (4, 'Fast wash', 200, 30),
  (5, 'Big wash', 250, 180),
  (6, 'Huuuge wash', 350, 180);

INSERT INTO fitness (tariff_id, washer_id, model_id) VALUES
  (1,1,1), (1,2,1), (1,3,1), (1,4,1), (1,5,1),
  (2,1,1), (2,2,1), (2,3,1), (2,4,1), (2,5,1),
  (4,1,1), (4,2,1), (4,3,1), (4,4,1), (4,5,1),
  (1,6,2), (2,6,2), (3,6,2), (4,6,2),
  (5,7,3), (4,7,3), (2,7,3), (1,7,3),
  (5,8,3), (4,8,3), (2,8,3), (1,8,3),
  (6,9,4), (5,9,4), (4,9,4), (2,9,4), (1,9,4);

INSERT INTO occupation (tariff_id, washer_id, model_id, start_time, run_load) VALUES
  (1, 1, 1, '2016-01-13 10:00', 4),
  (1, 1, 1, '2016-01-13 13:00', 4),
  (2, 1, 1, '2016-01-13 13:00', 4),
  (2, 2, 1, '2016-01-13 13:00', 4),
  (1, 1, 1, '2016-01-12 13:00', 4),
  (1, 1, 1, '2016-01-13 17:00', 4);

ALTER TABLE occupation ADD INDEX time_idx USING BTREE (start_time);

DELIMITER $$
-- these two triggers below prevent intersections between one machine's occupation intervals
-- also, they prevent insert/update if load is bigger than maximum load for this model
CREATE TRIGGER on_occup_update BEFORE UPDATE ON occupation
	FOR EACH ROW
		BEGIN
      DECLARE prev_time DATETIME;
      DECLARE prev_duration INT;
      DECLARE next_time DATETIME;
      DECLARE next_duration INT;
      DECLARE new_duration INT;
      DECLARE machine_max_load INT;

      SELECT start_time, duration INTO prev_time, prev_duration 
        FROM occupation LEFT JOIN tariff ON (occupation.tariff_id = tariff.id) 
        WHERE start_time < NEW.start_time 
          AND NOT (tariff_id = OLD.tariff_id AND washer_id = OLD.washer_id AND model_id = OLD.model_id
          AND start_time = OLD.start_time)
        ORDER BY start_time DESC LIMIT 1;
      SELECT start_time, duration INTO next_time, next_duration 
        FROM occupation LEFT JOIN tariff ON (occupation.tariff_id = tariff.id) 
        WHERE start_time > NEW.start_time 
          AND NOT (tariff_id = OLD.tariff_id AND washer_id = OLD.washer_id AND model_id = OLD.model_id
          AND start_time = OLD.start_time)
        ORDER BY start_time ASC LIMIT 3;

      IF prev_time IS NOT NULL AND NEW.start_time <= (prev_time + INTERVAL prev_duration MINUTE) THEN
				SIGNAL SQLSTATE '45000' set message_text = 'Occupation periods must not collide';
			END IF;
      SELECT duration INTO new_duration FROM tariff WHERE id = NEW.tariff_id;
      IF next_time IS NOT NULL AND next_time <= (NEW.start_time + INTERVAL new_duration MINUTE) THEN
				SIGNAL SQLSTATE '45000' set message_text = 'Occupation periods must not collide';
			END IF;

      SELECT max_load INTO machine_max_load FROM model WHERE id = NEW.model_id;
      IF machine_max_load < NEW.run_load THEN
        SIGNAL SQLSTATE '45000' set message_text = 'Run load must not exceed maximum for machine';
      END IF;
	END$$

CREATE TRIGGER on_occup_insert BEFORE INSERT ON occupation
	FOR EACH ROW
		BEGIN
      DECLARE prev_time DATETIME;
      DECLARE prev_duration INT;
      DECLARE next_time DATETIME;
      DECLARE next_duration INT;
      DECLARE new_duration INT;
      DECLARE machine_max_load INT;

      SELECT start_time, duration INTO prev_time, prev_duration 
        FROM occupation LEFT JOIN tariff ON (occupation.tariff_id = tariff.id) 
        WHERE start_time < NEW.start_time 
          AND (tariff_id = NEW.tariff_id AND washer_id = NEW.washer_id AND model_id = NEW.model_id)
        ORDER BY start_time DESC LIMIT 1;
      SELECT start_time, duration INTO next_time, next_duration 
        FROM occupation LEFT JOIN tariff ON (occupation.tariff_id = tariff.id) 
        WHERE start_time > NEW.start_time 
          AND (tariff_id = NEW.tariff_id AND washer_id = NEW.washer_id AND model_id = NEW.model_id)
        ORDER BY start_time ASC LIMIT 1;

      IF prev_time IS NOT NULL AND NEW.start_time <= (prev_time + INTERVAL prev_duration MINUTE) THEN
				SIGNAL SQLSTATE '45000' set message_text = 'Occupation periods must not collide';
			END IF;
      SELECT duration INTO new_duration FROM tariff WHERE id = NEW.tariff_id;
      IF next_time IS NOT NULL AND next_time <= (NEW.start_time + INTERVAL new_duration MINUTE) THEN
				SIGNAL SQLSTATE '45000' set message_text = 'Occupation periods must not collide';
			END IF;

      SELECT max_load INTO machine_max_load FROM model WHERE id = NEW.model_id;
      IF machine_max_load < NEW.run_load THEN
        SIGNAL SQLSTATE '45000' set message_text = 'Run load must not exceed maximum for machine';
      END IF;
	END$$


DELIMITER ;

SELECT * FROM occupation;

CREATE VIEW tariffs_popularity_unordered (id, name, popularity) AS 
    SELECT tariff.id AS id, tariff.name AS name, COUNT(occupation.start_time) as popularity 
      FROM occupation LEFT JOIN tariff ON (occupation.tariff_id = tariff.id) 
      GROUP BY occupation.tariff_id, occupation.washer_id, occupation.model_id;

CREATE VIEW tariffs_popularity (id, name, popularity) AS 
  SELECT * FROM tariffs_popularity_unordered ORDER BY popularity DESC;

CREATE VIEW laundry_workload_statistics (day, machines_used, runtime_sum) AS
  SELECT 
      DATE(occupation.start_time) as day,
      COUNT(DISTINCT occupation.washer_id, occupation.model_id),
      SUM(tariff.duration)/60 as runtime_sum
    FROM occupation LEFT JOIN tariff ON (occupation.tariff_id = tariff.id)
    GROUP BY DATE(occupation.start_time);

CREATE VIEW hot_days (day, runtime_sum, machines_used) AS 
  SELECT * FROM laundry_workload_statistics ORDER BY runtime_sum, machines_used DESC;


SELECT * FROM laundry_workload_statistics;

SELECT washer_id, model_id 
    FROM occupation LEFT JOIN tariff ON (occupation.tariff_id = tariff.id)
    WHERE (start_time + INTERVAL tariff.duration MINUTE < CURDATE())
    GROUP BY washer_id, model_id;
























