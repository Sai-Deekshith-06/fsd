USE deeks;

CREATE TABLE USERS (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    city VARCHAR(255) NOT NULL,
    registration_date DATE NOT NULL 
);


INSERT INTO USERS(NAME, EMAIL, CITY, REGISTRATION_DATE)
    VALUE('Alice Johnson', 'alice@example.com', 'New York', '2024-12-01');
INSERT INTO USERS(NAME, EMAIL, CITY, REGISTRATION_DATE)
    VALUE('Bob Smith', 'bob@example.com', 'Los Angeles', '2024-12-05' );
INSERT INTO USERS(NAME, EMAIL, CITY, REGISTRATION_DATE)
    VALUE('Charlie Lee', 'charlie@example.com', 'Chicago', '2024-12-10');
INSERT INTO USERS(NAME, EMAIL, CITY, REGISTRATION_DATE)
    VALUE('Diana King', 'diana@example.com', 'New York', '2025-01-15');
INSERT INTO USERS(NAME, EMAIL, CITY, REGISTRATION_DATE)
    VALUE('Ethan Hunt', 'ethan@example.com', 'Los Angeles', '2025-02-01');


CREATE TABLE EVENTS(
    ID INT PRIMARY KEY AUTO_INCREMENT,
    TITLE VARCHAR(200) NOT NULL,
    DESCRIPTION TEXT,
    CITY VARCHAR(100),
    START_DATE DATETIME NOT NULL,
    END_DATE DATETIME NOT NULL,
    STATUS ENUM('upcoming', 'completed', 'cancelled') DEFAULT 'upcoming',
    ORGANIZER_ID INT,
    CONSTRAINT fk_event_organizer FOREIGN KEY (ORGANIZER_ID) REFERENCES USERS(ID)
);


INSERT INTO EVENTS(TITLE, DESCRIPTION, CITY, START_DATE, END_DATE, STATUS, ORGANIZER_ID)
    VALUE('Tech Innovators Meetup', 'A meetup for tech enthusiasts.', 'New York', '2025-06-10 10:00:00', '2025-06-10 16:00:00','upcoming', 1);
INSERT INTO EVENTS(TITLE, DESCRIPTION, CITY, START_DATE, END_DATE, STATUS, ORGANIZER_ID)
    VALUE('AI & ML Conference', 'Conference on AI and ML advancements.', 'Chicago', '2025-05-15 09:00:00', '2025-05-15 17:00:00','completed', 3);
INSERT INTO EVENTS(TITLE, DESCRIPTION, CITY, START_DATE, END_DATE, STATUS, ORGANIZER_ID)
    VALUE('Frontend Development Bootcamp', 'Hands-on training on frontend tech.', 'Los Angeles', '2025-07-01 10:00:00', '2025-07-03 16:00:00','upcoming', 2);


CREATE TABLE SESSIONS(
    ID INT PRIMARY KEY AUTO_INCREMENT,
    EVENT_ID INT,
    TITLE VARCHAR(200) NOT NULL,
    SPEAKER VARCHAR(100) NOT NULL,
    START_DATE DATETIME NOT NULL,
    END_DATE DATETIME NOT NULL,
    CONSTRAINT fk_session_event FOREIGN key (EVENT_ID) REFERENCES EVENTS(ID)
);


INSERT INTO SESSIONS(EVENT_ID, TITLE, SPEAKER, START_DATE, END_DATE) VALUES
(1, 'Opening Keynote', 'Dr. Tech', '2025-06-10 10:00:00', '2025-06-10 11:00:00'),
(1, 'Future of Web Dev', 'Alice Johnson', '2025-06-10 11:15:00', '2025-06-10 12:30:00'),
(2, 'AI in Healthcare', 'Charlie Lee', '2025-05-15 09:30:00', '2025-05-15 11:00:00'),
(3, 'Intro to HTML5', 'Bob Smith', '2025-07-01 10:00:00', '2025-07-01 12:00:00');


CREATE TABLE REGISTRATIONS(
    ID INT PRIMARY KEY AUTO_INCREMENT,
    USER_ID INT,
    EVENT_ID INT,
    REGISTRATION_DATE DATE NOT NULL,
    CONSTRAINT fk_registration_user FOREIGN key (USER_ID) REFERENCES USERS(ID),
    CONSTRAINT fk_registration_event FOREIGN key (EVENT_ID) REFERENCES EVENTS(ID)
);


INSERT INTO REGISTRATIONS(USER_ID, EVENT_ID, REGISTRATION_DATE) VALUES
(1, 1, '2025-05-01'),
(2, 1, '2025-05-02'),
(3, 2, '2025-04-30'),
(4, 2, '2025-04-28'),
(5, 3, '2025-06-15');


CREATE TABLE FEEDBACK(
    ID INT PRIMARY KEY AUTO_INCREMENT,
    USER_ID INT,
    EVENT_ID INT,
    RATING INT,
    COMMENTS TEXT,
    DATE DATE NOT NULL,
    CONSTRAINT chk_feedback_rating CHECK (RATING BETWEEN 1 AND 5),
    CONSTRAINT fk_feedback_user FOREIGN key (USER_ID) REFERENCES USERS(ID),
    CONSTRAINT fk_feedback_event FOREIGN key (EVENT_ID) REFERENCES EVENTS(ID)
);


INSERT INTO FEEDBACK(USER_ID, EVENT_ID, RATING, COMMENTS, DATE) VALUES
(3, 2, 4, 'Great insights!', '2025-05-16'),
(4, 2, 5, 'Very informative.', '2025-05-16'),
(2, 1, 3, 'Could be better.', '2025-06-11');


CREATE TABLE RESOURCES(
    ID INT PRIMARY KEY AUTO_INCREMENT,
    EVENT_ID INT,
    TYPE ENUM('pdf','image','link'),
    URL VARCHAR(255) NOT NULL,
    UPLOADED_AT DATETIME NOT NULL,
    CONSTRAINT fk_resource_event FOREIGN key (EVENT_ID) REFERENCES EVENTS(ID)
);


INSERT INTO RESOURCES(EVENT_ID, TYPE, URL, UPLOADED_AT) VALUES
(1, 'pdf', 'https://portal.com/resources/tech_meetup_agenda.pdf', '2025-05-01 10:00:00'),
(2, 'image', 'https://portal.com/resources/ai_poster.jpg', '2025-04-20 09:00:00'),
(3, 'link', 'https://portal.com/resources/html5_docs', '2025-06-25 15:00:00');

-- 1. User Upcoming Events 
-- Show a list of all upcoming events a user is registered for in their city, sorted by date. 
SELECT 
u.*, e.*, r.REGISTRATION_DATE
FROM USERS u JOIN EVENTS e JOIN REGISTRATIONS r
ON r.EVENT_ID=e.id AND u.id=r.USER_ID
WHERE e.status='upcoming' AND u.CITY=e.CITY ORDER BY e.START_DATE;

-- 2. Top Rated Events 
-- Identify events with the highest average rating, considering only those that have received atleast 1 feedback submissions.
SELECT 
    e.*, AVG(RATING) AS AVG_RATING
FROM EVENTS e JOIN FEEDBACK f ON e.ID=f.EVENT_ID
GROUP BY e.ID
HAVING COUNT(f.ID) >= 1
ORDER BY AVG_RATING DESC;

-- 3. Inactive Users 
-- Retrieve users who have not registered for any events in the last 13 months. 
SELECT u.* FROM REGISTRATIONS r
    WHERE r.USER_ID=u.ID AND r.REGISTRATION_DATE > DATE_SUB(CURDATE(), INTERVAL 13 MONTH);

-- 4. Peak Session Hours 
-- Count how many sessions are scheduled between 10 AM to 12 PM for each event.
SELECT e.ID, e.TITLE, COUNT(*) AS NUMBER_OF_SESSIONS
FROM EVENTS e JOIN SESSIONS s ON e.ID=s.EVENT_ID WHERE TIME(s.END_DATE) BETWEEN '10:00:00' AND '12:00:00' GROUP BY e.ID;

-- 5. Most Active Cities 
-- List the top 5 cities with the highest number of distinct user registrations.
SELECT u.CITY, COUNT(*) AS NUMBER_OF_UNQ_USER_REGISTRATIONS
FROM USERS u
WHERE u.ID IN (SELECT DISTINCT USER_ID FROM REGISTRATIONS)
GROUP BY u.CITY;

-- 6. Event Resource Summary 
-- Generate a report showing the number of resources (PDFs, images, links) uploaded for each event.
SELECT EVENT_ID, TYPE, COUNT(*) AS NO_OF_RESOURCES 
FROM RESOURCES GROUP BY EVENT_ID, TYPE;

SELECT EVENT_ID,
SUM(TYPE='pdf') AS PDF,
SUM(TYPE='image') AS IMAGE,
SUM(TYPE='link') AS LINK
FROM RESOURCES GROUP BY EVENT_ID;

-- 7. Low Feedback Alerts 
-- List all users who gave feedback with a rating less than 3, along with their comments and associated event names.
SELECT f.*, e.TITLE
FROM FEEDBACK f JOIN EVENTS e ON f.USER_ID=e.ID
WHERE f.RATING<=3;

-- 8. Sessions per Upcoming Event 
-- Display all upcoming events with the count of sessions scheduled for them. 
SELECT e.*, COUNT(*) AS NO_SESSIONS
FROM EVENTS e JOIN SESSIONS s ON e.ID=s.EVENT_ID
WHERE e.STATUS='upcoming' GROUP BY s.EVENT_ID;

-- 9. Organizer Event Summary 
-- For each event organizer, show the number of events created and their current status (upcoming, completed, cancelled).
SELECT u.NAME, STATUS, COUNT(*) AS NO_OF_EVENTS
FROM EVENTS e JOIN USERS u ON u.ID=e.ORGANIZER_ID
GROUP BY e.ID, STATUS;

-- 10. Feedback Gap - Identify events that had registrations but received no feedback at all. 
SELECT EVENT_ID FROM REGISTRATIONS EXCEPT SELECT EVENT_ID FROM FEEDBACK;

-- 11. Daily New User Count - Find the number of users who registered each day in the last 7 days.
SELECT REGISTRATION_DATE, COUNT(*) AS NO_OF_USERS
FROM USERS WHERE REGISTRATION_DATE BETWEEN DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND CURDATE() GROUP BY REGISTRATION_DATE ORDER BY REGISTRATION_DATE ;

-- 12. Event with Maximum Sessions - List the event(s) with the highest number of sessions. 
SELECT EVENT_ID, COUNT(*) AS NO_OF_SESSIONS
FROM SESSIONS s GROUP BY s.EVENT_ID ORDER BY NO_OF_SESSIONS DESC;

-- 13. Average Rating per City - Calculate the average feedback rating of events conducted in each city. 
SELECT u.CITY, AVG(f.RATING)
FROM USERS u JOIN FEEDBACK f ON u.ID=f.USER_ID
GROUP BY u.CITY;

-- 14. Most Registered Events - List top 3 events based on the total number of user registrations. 
SELECT e.ID, COUNT(*) AS NO_OF_REGISTRATIONS
FROM EVENTS e JOIN REGISTRATIONS r ON e.ID=r.EVENT_ID
GROUP BY r.EVENT_ID LIMIT 3;

-- 15. Event Session Time Conflict - Identify overlapping sessions within the same event (i.e., session start and end times that 
-- conflict).
INSERT INTO SESSIONS
(ID, EVENT_ID, TITLE, SPEAKER, START_DATE, END_DATE)
VALUES (5, 1, 'Cloud Computing', 'Jane Doe', '2025-06-10 10:30:00', '2025-06-10 11:30:00');

SELECT s.ID, S.TITLE, s1.ID, s1.TITLE
FROM SESSIONS s JOIN SESSIONS s1 
ON ((s.START_DATE<=s1.START_DATE AND s1.START_DATE<=s.END_DATE) OR (s1.START_DATE<=s.START_DATE AND s.START_DATE<=s1.END_DATE)) AND s.ID<s1.ID; 

-- 16. Unregistered Active Users - Find users who created an account in the last 30 days but haven’t registered for any events. 
SELECT * 
FROM USERS u LEFT JOIN REGISTRATIONS r 
ON u.ID=r.USER_ID 
WHERE u.REGISTRATION_DATE BETWEEN DATE_SUB(CURDATE(), INTERVAL 17 MONTH) AND DATE_SUB(CURDATE(), INTERVAL 16 MONTH) AND r.USER_ID IS NULL;

-- 17. Multi-Session Speakers - Identify speakers who are handling more than one session across all events. 
SELECT s.SPEAKER, COUNT(*) AS NUMBER_OF_SESSIONS
FROM SESSIONS s GROUP BY SPEAKER;

-- 18. Resource Availability Check - List all events that do not have any resources uploaded. 


-- 19. Completed Events with Feedback Summary - For completed events, show total registrations and average feedback rating. 


-- 20. User Engagement Index - For each user, calculate how many events they attended and how many feedbacks they 
-- submitted. 