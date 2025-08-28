CREATE DATABASE WebThuePhong
go
USE WebThuePhong
go
CREATE TABLE Admin (
    Account INT PRIMARY KEY,
    Userame VARCHAR(50) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    
);
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20)
    
);
CREATE TABLE Locations (
    LocationID INT PRIMARY KEY,
    LocationName VARCHAR(100) NOT NULL
    
);
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
    
);
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY,
    RoomName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    LocationID INT,
    CategoryID INT,
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
    
);
CREATE TABLE Posts (
    PostID INT PRIMARY KEY,
    UserID INT,
    RoomID INT,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
    
);
CREATE TABLE Comments (
    CommentID INT PRIMARY KEY,
    UserID INT,
    RoomID INT,
    Comment TEXT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
    
);
CREATE TABLE Images (
    ImageID INT PRIMARY KEY,
    RoomID INT,
    ImageURL VARCHAR(255) NOT NULL,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
    
);
CREATE TABLE Amenities (
    AmenityID INT PRIMARY KEY,
    AmenityName VARCHAR(50) NOT NULL
    
);
CREATE TABLE RoomsAmenities (
    RoomID INT,
    AmenityID INT,
    PRIMARY KEY (RoomID, AmenityID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (AmenityID) REFERENCES Amenities(AmenityID)

);
