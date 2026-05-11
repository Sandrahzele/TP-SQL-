
CREATE DATABASE IF NOT EXISTS GestionNotes_TP;
USE GestionNotes_TP;


CREATE TABLE ETUDIANT (
    NEtudiant INT PRIMARY KEY,
    Nom VARCHAR(50) NOT NULL,
    Prenom VARCHAR(50) NOT NULL
);

CREATE TABLE MATIERE (
    CodeMat VARCHAR(10) PRIMARY KEY,
    LibelleMat VARCHAR(100) NOT NULL,
    CoeffMat FLOAT NOT NULL
);

CREATE TABLE EVALUER (
    NEtudiant INT,
    CodeMat VARCHAR(10),
    Date DATE,
    Note FLOAT,
    PRIMARY KEY (NEtudiant, CodeMat, Date),
    FOREIGN KEY (NEtudiant) REFERENCES ETUDIANT(NEtudiant),
    FOREIGN KEY (CodeMat) REFERENCES MATIERE(CodeMat)
);


INSERT INTO ETUDIANT VALUES (1, 'Durand', 'Marie'), (2, 'Lefebvre', 'Thomas'), (3, 'Petit', 'Julie');
INSERT INTO MATIERE VALUES ('MAT01', 'Mathématiques', 4), ('INF01', 'Informatique', 3), ('ANG01', 'Anglais', 2);
INSERT INTO EVALUER (NEtudiant, CodeMat, Date, Note) VALUES 
(1, 'MAT01', '2026-04-10', 15), (1, 'INF01', '2026-04-12', 14),
(2, 'MAT01', '2026-04-10', 10), (2, 'INF01', '2026-04-12', 18),
(3, 'MAT01', '2026-04-10', 08), (3, 'INF01', '2026-04-12', 12);


-- Q1: Quel est le nombre total d'étudiants ?
SELECT COUNT(*) AS Nombre_Total_Etudiants 
FROM ETUDIANT;

-- Q2: Note la plus haute et la plus basse parmi l'ensemble des notes
SELECT MAX(Note) AS Note_La_Plus_Haute, MIN(Note) AS Note_La_Plus_Basse 
FROM EVALUER;

-- Q3: Moyennes de chaque étudiant dans chacune des matières (Création de la vue MGETU)
CREATE OR REPLACE VIEW MGETU AS
SELECT NEtudiant, CodeMat, AVG(Note) AS MOYETUMAT
FROM EVALUER
GROUP BY NEtudiant, CodeMat;

SELECT * FROM MGETU;

-- Q4: Quelles sont les moyennes par matière ? (En utilisant la vue MGETU)
SELECT CodeMat, AVG(MOYETUMAT) AS Moyenne_Par_Matiere
FROM MGETU
GROUP BY CodeMat;

-- Q5: Quelle est la moyenne générale de chaque étudiant ? (Création de la vue MOYETUMAT)
CREATE OR REPLACE VIEW MOY_GENERALE_ETUDIANT AS
SELECT NEtudiant, AVG(MOYETUMAT) AS Moyenne_Generale
FROM MGETU
GROUP BY NEtudiant;

SELECT * FROM MOY_GENERALE_ETUDIANT;

-- Q6: Quelle est la moyenne générale de la promotion ?
SELECT AVG(Moyenne_Generale) AS Moyenne_Promotion
FROM MOY_GENERALE_ETUDIANT;

-- Q7: Quels sont les étudiants qui ont une moyenne générale >= à la moyenne de la promotion ?
SELECT E.Nom, E.Prenom, M.Moyenne_Generale
FROM MOY_GENERALE_ETUDIANT M
JOIN ETUDIANT E ON M.NEtudiant = E.NEtudiant
WHERE M.Moyenne_Generale >= (SELECT AVG(Moyenne_Generale) FROM MOY_GENERALE_ETUDIANT);
