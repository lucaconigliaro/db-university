-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT * 
FROM `students`
WHERE YEAR(`date_of_birth`) = 1990;


-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT * 
FROM `courses`
WHERE `cfu` > 10;


-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT * 
FROM `students`
WHERE TIMESTAMPDIFF(YEAR, `date_of_birth`, CURDATE()) > 30; 


-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT * 
FROM `courses`
WHERE `period`= "I semestre" 
AND `year`= "1";


-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT * 
FROM `exams`
WHERE `hour`>= "14:00" 
AND `date` = "2020-06-20";

-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT * 
FROM `degrees`
WHERE `level` = "magistrale";


-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) AS `total_departments`
FROM `departments`;


-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT *
FROM `teachers`
WHERE `phone` IS NULL;


-- 9. Inserire nella tabella degli studenti un nuovo record con i propri dati (per il campo degree_id, inserire un valore casuale)
INSERT INTO `students` (`degree_id`, `name`, `surname`, `date_of_birth`, `fiscal_code`, `enrolment_date`, `registration_number`, `email`) 
VALUES ('4', 'Luca', 'Conigliaro', '1996-10-07', 'ASFGFDDFADGBS', CURDATE(), '77777', 'lucaconigliaro@libero.com');


-- 10. Cambiare il numero dell’ufficio del professor Pietro Rizzo in 126
UPDATE `teachers`
SET `office_number` = 126
WHERE `id` = 58;


-- 11. Eliminare dalla tabella studenti il record creato precedentemente al punto 9
DELETE 
FROM `students`
WHERE `id` = 5001;


-- GROUP BY -- 
-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT COUNT(*) 
FROM `students` 
GROUP BY YEAR(`enrolment_date`);


-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT COUNT(*) 
FROM `teachers` 
GROUP BY `office_address`;


-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT AVG(`vote`) 
FROM `exam_student` 
GROUP BY `exam_id`;


-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT COUNT(*) 
FROM `degrees` 
GROUP BY `department_id`;


-- JOIN --
-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT `students`.`name`, `students`.`surname`, `degrees`.`name` AS `degree`
FROM `students`
INNER JOIN `degrees`
ON `students`.`degree_id` = `degrees`.`id`
WHERE `degrees`.`name` = "Corso di Laurea in Economia";


-- 2. Selezionare tutti i Corsi di Laurea Magistrale del Dipartimento di Neuroscienze
SELECT `degrees`.`name` AS `degree`, `departments`.`name` AS `department`
FROM `degrees`
INNER JOIN `departments`
ON `degrees`.`department_id` = `departments`.`id`
WHERE `departments`.`name` = "Dipartimento di Neuroscienze"
AND `level` = "magistrale";


-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT  `teachers`.`id`, `teachers`.`name`, `teachers`.`surname`, `courses`.`name` AS `course`
FROM `courses`
INNER JOIN `course_teacher`
ON `course_teacher`.`course_id` = `courses`.`id`
INNER JOIN `teachers`
ON `teacher_id` = `teachers`.`id`
WHERE `teachers`.`name` = "Fulvio"
AND `surname` = "Amato"

    
-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT  `students`.`name`, `students`.`surname`, `degrees`.`name` AS `degree`, `departments`.`name` AS `department`
FROM `students` 
INNER JOIN `degrees` 
ON `students`.`degree_id` = `degrees`.`id`
INNER JOIN `departments`
ON `degrees`.`department_id` = `departments`.`id`
ORDER BY `students`.`surname` ASC, `students`.`name` ASC;


-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT  `degrees`.`name` AS `degree`, `courses`.`name` AS `course`, `teachers`.`name` AS `teacher_name`, `teachers`.`surname` AS `teacher_surname`
FROM `degrees`
INNER JOIN `courses`
ON `degrees`.`id` = `courses`.`degree_id`
INNER JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`course_id`
INNER JOIN `teachers`
ON `course_teacher`.`teacher_id` = `teachers`.`id`;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT `teachers`.*, `departments`.`name` AS `department_name`
FROM `teachers`
INNER JOIN `course_teacher`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
INNER JOIN `courses`
ON `courses`.`id` = `course_teacher`.`course_id`
INNER JOIN `degrees`
ON `degrees`.`id` = `courses`.`degree_id`
INNER JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`
WHERE `departments`.`name` = "Dipartimento di Matematica";


-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami
SELECT COUNT(`exam_student`.`vote`) AS `attempts`, `students`.`surname` AS `surname`, `students`.`name` AS `name`
FROM `students`
INNER JOIN `exam_student` 
ON `students`.`id` = `exam_student`.`student_id`
INNER JOIN `exams` 
ON `exams`.`id` = `exam_student`.`exam_id`
INNER JOIN `courses` 
ON `courses`.`id` = `exams`.`course_id`
WHERE `exam_student`.`vote` < 18
GROUP BY `students`.`id`;