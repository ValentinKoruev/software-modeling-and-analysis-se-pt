DROP DATABASE IF EXISTS GithubDummy;
GO

CREATE DATABASE GithubDummy;
GO
USE GithubDummy;
GO

DROP TABLE IF EXISTS IssueComment;
DROP TABLE IF EXISTS [Issue];
DROP TABLE IF EXISTS PullRequestReviewer;
DROP TABLE IF EXISTS PullRequestAssignee;
DROP TABLE IF EXISTS PullRequestAction;
DROP TABLE IF EXISTS PullRequest;
DROP TABLE IF EXISTS CommitChanges;
DROP TABLE IF EXISTS [Commit];
DROP TABLE IF EXISTS [File];
DROP TABLE IF EXISTS Contributor;
DROP TABLE IF EXISTS Repository;
DROP TABLE IF EXISTS [User];
GO

CREATE TABLE [User] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(320) NOT NULL UNIQUE,
    description NVARCHAR(MAX)
);

CREATE TABLE Repository (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    ownerId INT NOT NULL,
    FOREIGN KEY(ownerId) REFERENCES [User](id)
);

CREATE TABLE Contributor (
    userId INT NOT NULL,
    repositoryId INT NOT NULL,
    PRIMARY KEY (userId, repositoryId),
    FOREIGN KEY (userId) REFERENCES [User](id),
    FOREIGN KEY (repositoryId) REFERENCES Repository(id)
);

CREATE TABLE [File] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    extension NVARCHAR(31),
    content NVARCHAR(MAX),
    pathDir NVARCHAR(255),
    repositoryId INT NOT NULL,
    FOREIGN KEY (repositoryId) REFERENCES Repository(id)
);

CREATE TABLE [Commit] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    createdAt DATETIME NOT NULL DEFAULT(GETDATE()),
    repositoryId INT NOT NULL,
    FOREIGN KEY (repositoryId) REFERENCES Repository(id)
);

CREATE TABLE CommitChanges (
    id INT IDENTITY(1,1) PRIMARY KEY,
    commitId INT NOT NULL,
    fileId INT NOT NULL,
    oldContent NVARCHAR(MAX),
    newContent NVARCHAR(MAX),
    FOREIGN KEY (commitId) REFERENCES [Commit](id),
    FOREIGN KEY (fileId) REFERENCES [File](id)
);

CREATE TABLE PullRequest (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    isOpen BIT NOT NULL DEFAULT 1,
    createdAt DATETIME NOT NULL DEFAULT(GETDATE()),
    creatorId INT NOT NULL,
    repositoryId INT NOT NULL,
    FOREIGN KEY (creatorId) REFERENCES [User](id),
    FOREIGN KEY (repositoryId) REFERENCES Repository(id)
);

CREATE TABLE PullRequestAction (
    id INT IDENTITY(1,1) PRIMARY KEY,
    type NVARCHAR(255),
    content NVARCHAR(MAX),
    createdAt DATETIME NOT NULL DEFAULT(GETDATE()),
    creatorId INT NOT NULL,
    pullRequestId INT NOT NULL,
    FOREIGN KEY (creatorId) REFERENCES [User](id),
    FOREIGN KEY (pullRequestId) REFERENCES PullRequest(id)
);

CREATE TABLE PullRequestAssignee (
    pullRequestId INT NOT NULL,
    userId INT NOT NULL,
    PRIMARY KEY (pullRequestId, userId),
    FOREIGN KEY (pullRequestId) REFERENCES PullRequest(id),
    FOREIGN KEY (userId) REFERENCES [User](id)
);

CREATE TABLE PullRequestReviewer (
    pullRequestId INT NOT NULL,
    userId INT NOT NULL,
    PRIMARY KEY (pullRequestId, userId),
    FOREIGN KEY (pullRequestId) REFERENCES PullRequest(id),
    FOREIGN KEY (userId) REFERENCES [User](id)
);

CREATE TABLE [Issue] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    isOpen BIT NOT NULL DEFAULT 1,
    createdAt DATETIME NOT NULL DEFAULT(GETDATE()),
    creatorId INT NOT NULL,
    repositoryId INT NOT NULL,
    FOREIGN KEY (creatorId) REFERENCES [User](id),
    FOREIGN KEY (repositoryId) REFERENCES Repository(id)
);

CREATE TABLE IssueComment (
    id INT IDENTITY(1,1) PRIMARY KEY,
    content NVARCHAR(MAX),
    createdAt DATETIME NOT NULL DEFAULT(GETDATE()),
    creatorId INT NOT NULL,
    issueId INT NOT NULL,
    FOREIGN KEY (creatorId) REFERENCES [User](id),
    FOREIGN KEY (issueId) REFERENCES [Issue](id)
);


-- Sample Data

INSERT INTO [User] (name, password, email, description) VALUES
('alice', 'pass123', 'alice@example.com', 'Full-stack developer'),
('bob', 'pass123', 'bob@example.com', 'Backend engineer'),
('charlie', 'pass123', 'charlie@example.com', 'UI/UX designer'),
('diana', 'pass123', 'diana@example.com', 'DevOps specialist'),
('eric', 'pass123', 'eric@example.com', 'Game programmer'),
('frank', 'pass123', 'frank@example.com', 'Data engineer'),
('grace', 'pass123', 'grace@example.com', 'Machine Learning researcher'),
('henry', 'pass123', 'henry@example.com', 'Software architect'),
('ivan', 'pass123', 'ivan@example.com', 'Mobile app developer'),
('julia', 'pass123', 'julia@example.com', 'Frontend engineer'),
('kevin', 'pass123', 'kevin@example.com', 'Product manager'),
('lisa', 'pass123', 'lisa@example.com', 'QA automation engineer'),
('michael', 'pass123', 'michael@example.com', 'Security analyst'),
('nina', 'pass123', 'nina@example.com', 'Cloud systems engineer'),
('oscar', 'pass123', 'oscar@example.com', 'Embedded systems developer');

INSERT INTO Repository (name, description, ownerId) VALUES
('PortfolioSite', 'Personal portfolio built with React and NodeJS.', 1),
('GameEngineX', '2D experimental game engine.', 5),
('InfraTools', 'Internal DevOps toolchain scripts.', 4),
('MobileChatApp', 'Cross-platform chat application.', 9),
('ML-Toolkit', 'Reusable ML dataset + model utilities.', 7),
('UI-Library', 'Internal component library used across products.', 3),
('SecureAuth', 'Authentication middleware with RBAC support.', 13),
('WeatherAPI', 'REST Weather provider service.', 2),
('DataPipeline', 'ETL + Data Lake processing framework.', 6),
('TaskManager', 'Simple open-source task board app.', 10),
('HomeAutomation', 'IoT automation controller.', 15),
('FinanceCalc', 'Personal finance + budgeting calculator.', 8),
('InternOnboarding', 'Documentation + scripts for new hires.', 11),
('CodeReviewAssistant', 'PR linting and suggestion tool.', 12),
('EmbeddedSensorSuite', 'Firmware & analytics for sensor networks.', 14);

INSERT INTO Contributor (userId, repositoryId) VALUES
(2,1),(3,1),
(1,2),(6,2),(5,2),(10,2),
(4,3),
(9,4),(1,4),(7,4),
(7,5),(10,5),(14,5),
(3,6),(1,6),
(13,7),(2,7),(4,7),(15,7),(6,7),
(2,8),
(6,9),(7,9),(3,9),(8,9),(12,9),(11,9),
(10,10),(9,10),(5,10);

INSERT INTO [File] (name, extension, content, pathDir, repositoryId) VALUES
('index', '.js', 'console.log("Hello World");', '/src', 1),
('main', '.cpp', '// game engine main loop', '/engine', 2),
('deploy', '.sh', '# deployment script', '/scripts', 3),
('chat', '.dart', '// flutter chat screen', '/lib/screens', 4),
('model_utils', '.py', '# ML helpers', '/src/ml', 5),
('button', '.tsx', '// UI component', '/components', 6),
('auth', '.go', '// auth service', '/internal', 7),
('weather', '.js', '// API endpoint', '/routes', 8),
('etl', '.py', '# pipeline step', '/pipeline', 9),
('board', '.vue', '// task board UI', '/src', 10);

INSERT INTO [Commit] (name, description, createdAt, repositoryId) VALUES
('Initial commit', 'Project skeleton created.', GETDATE(), 1),
('Add redux toolkit', 'Integrated redux toolkit.', GETDATE(), 1),
('Add scss', 'Added scss to project.', GETDATE(), 1),
('Header component', 'Header component added.', GETDATE(), 1),
('Add render loop', 'Engine core rendering added.', GETDATE(), 2),
('fix render loop', 'Engine core rendering added.', GETDATE(), 2),
('fix render loop again', 'Engine core rendering added.', GETDATE(), 2),
('remove render loop', 'Engine core rendering added.', GETDATE(), 2),
('Add render loop back', 'Engine core rendering added.', GETDATE(), 2),
('Add deployment script', 'Added CI/CD shell script.', GETDATE(), 3),
('Add deployment script 2', 'Added CI/CD shell script.', GETDATE(), 3),
('Chat UI base', 'First chat screen.', GETDATE(), 4),
('Model loader update', 'Better serialization.', GETDATE(), 5),
('New UI Buttons', 'Shared component library expanded.', GETDATE(), 6),
('JWT Support', 'Added JWT verification.', GETDATE(), 7),
('Weather endpoint v1', 'API working.', GETDATE(), 8),
('Weather endpoint v2', 'API working.', GETDATE(), 8),
('Weather endpoint v3', 'API working.', GETDATE(), 8),
('ETL refactor', 'Pipeline now uses batches.', GETDATE(), 9),
('Task board UI polish', 'Improved layout.', GETDATE(), 10);

INSERT INTO CommitChanges (commitId, fileId, oldContent, newContent) VALUES
(1,1,'','console.log("Hello World");'),
(2,2,'// old loop','// new rendering loop'),
(3,3,'','#!/bin/bash deploy update'),
(4,4,'// todo UI','// basic chat'),
(5,5,'','improved model loader'),
(6,6,'','added variants'),
(7,7,'','jwt support'),
(8,8,'','working api'),
(9,9,'','batch enabled'),
(10,10,'//old','//polished');

INSERT INTO PullRequest (name, isOpen, createdAt, creatorId, repositoryId) VALUES
('Improve UI Theme', 1, GETDATE(), 3, 6),
('Add OAuth', 0, GETDATE(), 13, 7),
('Refactor ETL step', 1, GETDATE(), 6, 9);

INSERT INTO PullRequestAction (pullRequestId, type, content, createdAt, creatorId) VALUES
(1, 'comment', 'Looks great overall.', GETDATE(), 1),
(1, 'review', 'Requested minor color changes.', GETDATE(), 10),
(2, 'comment', 'Merged successfully.', GETDATE(), 4),
(3, 'comment', 'Need unit tests.', GETDATE(), 7);

INSERT INTO PullRequestAssignee  (pullRequestId, userId) VALUES
(1,3),(1,10),
(2,13),(2,4),
(3,6),(3,7);

INSERT INTO PullRequestReviewer (pullRequestId, userId) VALUES
(1,1),(1,2),(1,10),
(2,4),(2,8),
(3,6),(3,12);

INSERT INTO Issue (name, isOpen, createdAt, creatorId, repositoryId) VALUES
('Login form bug', 1, GETDATE(), 10, 10),
('Rendering slowdown', 1, GETDATE(), 5, 2),
('Missing documentation', 0, GETDATE(), 11, 3);

INSERT INTO IssueComment (issueId, content, createdAt, creatorId) VALUES
(1, 'Can reproduce, looking into it.', GETDATE(), 1),
(1, 'Likely API response format mismatch.', GETDATE(), 6),
(2, 'Need profiling details.', GETDATE(), 8),
(3, 'Docs added already.', GETDATE(), 11);

-- Procedures
CREATE PROCEDURE GetRepositoryFiles
    @RepositoryId INT
AS
BEGIN
    SELECT f.id, f.name, f.extension, f.pathDir
    FROM [File] f
    WHERE f.repositoryId = @RepositoryId;
END;
GO

CREATE PROCEDURE GetRepositoryContributors
    @RepositoryId INT
AS
BEGIN
    SELECT u.id AS UserId, u.name AS UserName, u.email
    FROM Contributors c
    JOIN Users u ON u.id = c.userId
    WHERE c.repositoryId = @RepositoryId;
END;
GO

-- Functions 
CREATE FUNCTION GetCommitCount (@RepositoryId INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM [Commit]
    WHERE repositoryId = @RepositoryId;

    RETURN @Count;
END;
GO

CREATE FUNCTION GetOpenIssueCount (@RepositoryId INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM Issue
    WHERE repositoryId = @RepositoryId AND isOpen = 1;

    RETURN @Count;
END;
GO

-- Triggers
CREATE TRIGGER PreventOwnerRemoval
ON Contributor
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN Repository r ON r.id = d.repositoryId
        WHERE r.ownerId = d.userId
    )
    BEGIN
        RAISERROR('Cannot remove the repository owner from contributors list.', 16, 1);
        RETURN;
    END;

    DELETE FROM Contributor
    WHERE userId IN (SELECT userId FROM deleted)
      AND repositoryId IN (SELECT repositoryId FROM deleted);
END;
GO

CREATE TRIGGER AddOwnerAsContributor
ON Repository
AFTER INSERT
AS
BEGIN
    INSERT INTO Contributor (userId, repositoryId)
    SELECT i.ownerId, i.id
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1
        FROM Contributor c
        WHERE c.userId = i.ownerId AND c.repositoryId = i.id
    );
END;
GO
