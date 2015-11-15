-- Create and use a sql_bootcamp database
CREATE DATABASE IF NOT EXISTS sql_bootcamp;
USE sql_bootcamp;

-- For convenience, delete each of the tables if it already
-- exists.  This allows us to run this script multiple times
-- without crashing
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS presidents;
DROP TABLE IF EXISTS states;

-- Create the states table
CREATE TABLE states (
   abbreviation CHAR(2) NOT NULL,
   full_name VARCHAR(255) NOT NULL,
   population INT NOT NULL,
   sq_mile_water INT NOT NULL,
   sq_mile_land INT NOT NULL,
   PRIMARY KEY(abbreviation)
);

-- Create the presidents table
CREATE TABLE presidents (
   id INT NOT NULL,
   last_name VARCHAR(255) NOT NULL,
   first_name VARCHAR(255) NOT NULL,
   took_office DATE NOT NULL,
   left_office DATE,
   party VARCHAR(255),
   home_state CHAR(2) NOT NULL,
   birth DATE NOT NULL,
   death DATE,
   death_place VARCHAR(255),
   FOREIGN KEY (home_state) REFERENCES states(abbreviation),
   PRIMARY KEY(id)
);

-- Create the books table
CREATE TABLE books (
   id INT NOT NULL AUTO_INCREMENT,
   title VARCHAR(255) NOT NULL,
   publisher VARCHAR(255) NOT NULL,
   published_year INT NOT NULL,
   isbn VARCHAR(32),
   author_id INT NOT NULL,
   PRIMARY KEY(id),
   FOREIGN KEY (author_id) REFERENCES presidents(id)
);

INSERT INTO states
   (abbreviation, full_name, population, sq_mile_water, sq_mile_land)
VALUES
   {% for state in states -%}
      {{ state }}{% if loop.last %};{% else %},{% endif %}
   {% endfor %}

INSERT INTO presidents
   (id, first_name, last_name, took_office, left_office, party, home_state, birth, death, death_place)
VALUES
   {% for president in presidents -%}
      {{ president }}{% if loop.last -%};{% else %},{% endif %}
   {% endfor %}

INSERT INTO books
   (title, publisher, published_year, isbn, author_id)
VALUES
   {% for book in books -%}
      {{ book }}{% if loop.last -%};{% else %},{% endif %}
   {% endfor %}
