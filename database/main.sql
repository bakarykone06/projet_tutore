--creation de la base de donnee
CREATE DATABASE yiriba_plateform;
USE yiriba_plateform;

-- Table utilisateur
/*
    Role : Cette table stocke les informations des personnes qui utilisent la plateforme.
    Utilité : l'authentification,la gestion des comptes,l'identification des auteurs des vidéos, commentaires et scores.
*/
CREATE TABLE utilisateur (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    mot_de_passe VARCHAR(255),
    photo_profil VARCHAR(255),
    role ENUM('utilisateur', 'administrateur') DEFAULT 'utilisateur',
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table categorie
/*
    Role : Cette table contient les différentes catégories de lois et devoirs.(Droits civiques,Droit du travail,Code de la route,Devoirs du citoyen)
    utilité : Elle permet de classer les vidéos afin de faciliter la recherche et la navigation.
*/
CREATE TABLE categorie (
    id_categorie INT AUTO_INCREMENT PRIMARY KEY,
    nom_categorie VARCHAR(100),
    description TEXT
);

-- Table video
/*
    Role : Cette table enregistre toutes les vidéos éducatives publiées sur la plateforme.
    utilité : Elle représente le contenu principal de l'application, similaire aux vidéos courtes de TikTok mais orientées vers les lois et devoirs.
*/
CREATE TABLE video (
    id_video INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255),
    description TEXT,
    url_video VARCHAR(255),
    date_publication TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nombre_vues INT DEFAULT 0,

    id_utilisateur INT,
    id_categorie INT,

    FOREIGN KEY (id_utilisateur)
    REFERENCES utilisateur(id_utilisateur),

    FOREIGN KEY (id_categorie)
    REFERENCES categorie(id_categorie)
);

-- table quiz
/*
    Role : Cette table stocke les quiz associés aux vidéos.
    utilité : Elle permet d'évaluer les connaissances acquises après le visionnage d'une vidéo.
*/
CREATE TABLE quiz (
    id_quiz INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255),
    niveau VARCHAR(50),
    score_total INT DEFAULT 0,

    id_video INT,

    FOREIGN KEY (id_video)
    REFERENCES video(id_video)
);

-- table question
/*
    Role : Cette table contient les questions appartenant à un quiz.
    utilité : Chaque quiz est composé de plusieurs questions permettant de tester la compréhension de l'utilisateur.
*/

CREATE TABLE question (
    id_question INT AUTO_INCREMENT PRIMARY KEY,
    texte_question TEXT,

    id_quiz INT,

    FOREIGN KEY (id_quiz)
    REFERENCES quiz(id_quiz)
);

-- table reponse
/*
    Role : Cette table contient les propositions de réponses liées aux questions.
    utilité : Elle permet la correction automatique du quiz et le calcul du score.
*/ 
CREATE TABLE reponse (
    id_reponse INT AUTO_INCREMENT PRIMARY KEY,
    contenu TEXT,
    est_correcte BOOLEAN,

    id_question INT,

    FOREIGN KEY (id_question)
    REFERENCES question(id_question)
);

-- table score
/*
    Role : Cette table enregistre les résultats obtenus par les utilisateurs aux quiz.
    utilité : Elle permet : le suivi des performances,l'affichage de l'historique,l'évaluation de la progression des utilisateurs.
*/
CREATE TABLE score (
    id_score INT AUTO_INCREMENT PRIMARY KEY,
    valeur INT,
    date_passage TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    id_utilisateur INT,
    id_quiz INT,

    FOREIGN KEY (id_utilisateur)
    REFERENCES utilisateur(id_utilisateur),

    FOREIGN KEY (id_quiz)
    REFERENCES quiz(id_quiz)
);

--table commentaire
/*
    Role : Cette table stocke les commentaires publiés sous les vidéos.
    utilité : Elle favorise les échanges entre les utilisateurs et permet de poser des questions ou partager des avis sur les vidéos.
*/
CREATE TABLE commentaire (
    id_commentaire INT AUTO_INCREMENT PRIMARY KEY,
    contenu TEXT,
    date_commentaire TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    id_utilisateur INT,
    id_video INT,

    FOREIGN KEY (id_utilisateur)
    REFERENCES utilisateur(id_utilisateur),

    FOREIGN KEY (id_video)
    REFERENCES video(id_video)
);

--table like_video
/*
    Role : Cette table enregistre les mentions « J'aime » attribuées aux vidéos.
    utilité : Elle permet de mesurer la popularité des vidéos et d'encourager l'interaction des utilisateurs.
*/
CREATE TABLE like_video (
    id_like INT AUTO_INCREMENT PRIMARY KEY,

    id_utilisateur INT,
    id_video INT,

    FOREIGN KEY (id_utilisateur)
    REFERENCES utilisateur(id_utilisateur),

    FOREIGN KEY (id_video)
    REFERENCES video(id_video)
);

-- table notification 
/*
    Role : Cette table stocke les notifications destinées aux utilisateurs.
    utilité : Elle informe les utilisateurs des nouveautés et activités importantes de la plateforme.
*/
CREATE TABLE notification (
    id_notification INT AUTO_INCREMENT PRIMARY KEY,
    message TEXT,
    statut BOOLEAN DEFAULT FALSE,
    date_notification TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    id_utilisateur INT,

    FOREIGN KEY (id_utilisateur)
    REFERENCES utilisateur(id_utilisateur)
);

-- qlq insertions de test dans la base de donnée
--1) Insertion des utilisateurs
INSERT INTO utilisateur (nom, email, mot_de_passe, role)
VALUES
('Bakary KONE', 'bakarykone.secu@gmail.com', '12345', 'administrateur'),
('Yacouba KONE', '', '123456', 'administrateur'),
('Aboubacar Oumar Thiocary', '', '1234567', 'administrateur'),
('Amadou LANDOURE', '', '12345678', 'administrateur'),
('Gassire Baba SANGARE', '', '12345678', 'administrateur'),
('Fatou Diallo', 'fatou@gmail.com', '12345', 'utilisateur'),
('Moussa COULIBALY', 'moussa@gmail.com', '123', 'utilisateur');

--2) Insertion des categories
INSERT INTO categorie (nom_categorie, description)
VALUES
('Droits civiques', 'Les droits fondamentaux du citoyen'),
('Devoirs du citoyen', 'Les obligations du citoyen envers la société'),
('Code de la route', 'Les règles de circulation routière');

--3) Insertion des vidéos
INSERT INTO video
(titre, description, url_video, id_utilisateur, id_categorie)
VALUES
(
    'Les droits fondamentaux',
    'Présentation des droits fondamentaux du citoyen',
    'videos/droits.mp4',
    1,
    1
),
(
    'Les devoirs du citoyen',
    'Comprendre ses responsabilités dans la société',
    'videos/devoirs.mp4',
    1,
    2
),
(
    'Respect du code de la route',
    'Les règles essentielles de circulation',
    'videos/route.mp4',
    1,
    3
);

--4) Insertion des quiz
INSERT INTO quiz
(titre, niveau, score_total, id_video)
VALUES
('Quiz Droits Civiques', 'Facile', 10, 1),
('Quiz Devoirs', 'Moyen', 10, 2),
('Quiz Code Route', 'Facile', 10, 3);

--5) Insertion de questions 
INSERT INTO question
(texte_question, id_quiz)
VALUES
('Tout citoyen a-t-il droit à la liberté expression ?', 1),
('Le paiement des impôts est-il un devoir du citoyen ?', 2),
('Le port de la ceinture est-il obligatoire ?', 3);

--6) Insertion de reponse
--Pour questions 1
INSERT INTO reponse
(contenu, est_correcte, id_question)
VALUES
('Oui', TRUE, 1),
('Non', FALSE, 1),
('Parfois', FALSE, 1),
('Je ne sais pas', FALSE, 1);
--Pour la question 2
INSERT INTO reponse
(contenu, est_correcte, id_question)
VALUES
('Oui', TRUE, 2),
('Non', FALSE, 2),
('Seulement les fonctionnaires', FALSE, 2),
('Uniquement les entreprises', FALSE, 2); 
-- Pour la question 3
INSERT INTO reponse
(contenu, est_correcte, id_question)
VALUES
('Oui', TRUE, 3),
('Non', FALSE, 3),
('Seulement en ville', FALSE, 3),
('Seulement la nuit', FALSE, 3);

--7) Insertion des scores 
INSERT INTO score
(valeur, id_utilisateur, id_quiz)
VALUES
(8, 1, 1),
(10, 2, 1),
(7, 1, 2),
(9, 2, 3);

--8) Insertions des commentaires 
INSERT INTO commentaire
(contenu, id_utilisateur, id_video)
VALUES
('Très bonne explication.', 1, 1),
('Vidéo très instructive.', 2, 1),
('J''ai beaucoup appris.', 1, 2);

--9) Insertions des likes 
INSERT INTO like_video
(id_utilisateur, id_video)
VALUES
(1, 1),
(2, 1),
(1, 2),
(2, 3);

--10) Insertions des notifications 
INSERT INTO notification
(message, id_utilisateur)
VALUES
('Une nouvelle vidéo a été publiée.', 1),
('Un nouveau quiz est disponible.', 2),
('Votre commentaire a reçu une réponse.', 1);