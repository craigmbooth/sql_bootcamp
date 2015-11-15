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
   ("AL", "Alabama", 4833722, 1675, 50744),
   ("AK", "Alaska", 735132, 91316, 567400),
   ("AZ", "Arizona", 6626624, 364, 113635),
   ("AR", "Arkansas", 2959373, 1110, 52068),
   ("CA", "California", 38332521, 7736, 155959),
   ("CO", "Colorado", 5268367, 376, 103718),
   ("CT", "Connecticut", 3596080, 699, 4845),
   ("DE", "Delaware", 925749, 536, 1954),
   ("FL", "Florida", 19552860, 11828, 53927),
   ("GA", "Georgia", 9992167, 1519, 57906),
   ("HI", "Hawaii", 1404054, 4508, 6423),
   ("ID", "Idaho", 1612136, 823, 82747),
   ("IL", "Illinois", 12882135, 2331, 55584),
   ("IN", "Indiana", 6570902, 551, 35867),
   ("IA", "Iowa", 3090416, 402, 55869),
   ("KS", "Kansas", 2893957, 462, 81815),
   ("KY", "Kentucky", 4395295, 681, 39728),
   ("LA", "Louisiana", 4625470, 8278, 43562),
   ("ME", "Maine", 1328302, 4523, 30862),
   ("MD", "Maryland", 5928814, 2633, 9774),
   ("MA", "Massachusetts", 6692824, 2715, 7840),
   ("MI", "Michigan", 9895622, 39881, 58110),
   ("MN", "Minnesota", 5420380, 7329, 79610),
   ("MS", "Mississippi", 2991207, 1523, 46907),
   ("MO", "Missouri", 6044171, 818, 68886),
   ("MT", "Montana", 1015165, 1490, 145552),
   ("NE", "Nebraska", 1868516, 481, 76872),
   ("NV", "Nevada", 2790136, 735, 109826),
   ("NH", "New Hampshire", 1323459, 382, 8968),
   ("NJ", "New Jersey", 8899339, 1304, 7417),
   ("NM", "New Mexico", 2085287, 234, 121356),
   ("NY", "New York", 19651127, 7342, 47214),
   ("NC", "North Carolina", 9848060, 5108, 48711),
   ("ND", "North Dakota", 723393, 1724, 68976),
   ("OH", "Ohio", 11570808, 3877, 40948),
   ("OK", "Oklahoma", 3850568, 1231, 68667),
   ("OR", "Oregon", 3930065, 2384, 95997),
   ("PA", "Pennsylvania", 12773801, 1239, 44817),
   ("RI", "Rhode Island", 1051511, 500, 1045),
   ("SC", "South Carolina", 4774839, 1911, 30109),
   ("SD", "South Dakota", 844877, 1232, 75885),
   ("TN", "Tennessee", 6495978, 926, 41217),
   ("TX", "Texas", 26448193, 6784, 261797),
   ("UT", "Utah", 2900872, 2755, 82144),
   ("VT", "Vermont", 626630, 365, 9250),
   ("VA", "Virginia", 8260405, 3180, 39594),
   ("WA", "Washington", 6971406, 4756, 66544),
   ("WV", "West Virginia", 1854304, 152, 24230),
   ("WI", "Wisconsin", 5742713, 11188, 54310),
   ("WY", "Wyoming", 582658, 713, 97105);
   

INSERT INTO presidents
   (id, first_name, last_name, took_office, left_office, party, home_state, birth, death, death_place)
VALUES
   (0, "George", "Washington", "1789-04-30", "1797-04-03", "Independent", "VA", "1732-02-22", "1799-12-14", "Mount Vernon, Va."),
   (1, "Thomas", "Jefferson", "1801-04-03", "1809-04-03", "Democratic-Republican", "VA", "1743-04-13", "1826-07-04", "Albemarle Co., Va."),
   (2, "James", "Madison", "1809-04-03", "1817-04-03", "Democratic-Republican", "VA", "1751-03-16", "1836-06-28", "Orange Co., Va."),
   (3, "James", "Monroe", "1817-04-03", "1825-04-03", "Democratic-Republican", "VA", "1758-04-28", "1831-07-04", "New York, New York"),
   (4, "John", "Tyler", "1841-04-04", "1845-04-03", "Whig", "VA", "1790-03-29", "1862-01-18", "Richmond, Va."),
   (5, "John", "Adams", "1797-04-03", "1801-04-03", "Federalist", "MA", "1735-10-30", "1826-07-04", "Quincy, Mass."),
   (6, "John Quincy", "Adams", "1825-04-03", "1829-04-03", "Democratic-Republican/National Republican", "MA", "1767-07-11", "1848-02-23", "Washington, D.C."),
   (7, "Calvin", "Coolidge", "1923-02-08", "1929-04-03", "Republican", "MA", "1872-07-04", "1933-01-05", "Northampton, Mass."),
   (8, "John F.", "Kennedy", "1961-01-20", "1963-11-22", "Democratic", "MA", "1917-05-29", "1963-11-22", "Dallas, Texas"),
   (9, "Andrew", "Jackson", "1829-04-03", "1837-04-03", "Democratic", "TN", "1767-03-15", "1845-06-08", "Nashville, Tennessee"),
   (10, "James K.", "Polk", "1845-04-03", "1849-04-03", "Democratic", "TN", "1795-11-02", "1849-06-15", "Nashville, Tennessee"),
   (11, "Andrew", "Johnson", "1865-04-15", "1869-04-03", "Democratic/National Union", "TN", "1808-12-29", "1875-07-31", "Elizabethton, Tenn."),
   (12, "Martin", "Van Buren", "1837-04-03", "1841-04-03", "Democratic", "NY", "1782-12-05", "1862-07-24", "Kinderhook, New York"),
   (13, "Millard", "Fillmore", "1850-09-07", "1853-04-03", "Whig", "NY", "1800-01-07", "1874-03-08", "Buffalo, New York"),
   (14, "Chester A.", "Arthur", "1881-09-19", "1885-04-03", "Republican", "NY", "1829-10-05", "1886-11-18", "New York, New York"),
   (15, "Grover", "Cleveland", "1885-04-03", "1889-04-03", "Democratic", "NY", "1837-03-18", "1908-06-24", "Princeton, New Jersey"),
   (16, "Grover", "Cleveland", "1893-04-03", "1897-04-03", "Democratic", "NY", "1837-03-18", "1908-06-24", "Princeton, New Jersey"),
   (17, "Theodore", "Roosevelt", "1901-09-14", "1909-04-03", "Republican", "NY", "1858-10-27", "1919-01-06", "Oyster Bay, New York"),
   (18, "Franklin D.", "Roosevelt", "1933-04-03", "1945-12-04", "Democratic", "NY", "1882-01-30", "1945-04-12", "Warm Springs, Georgia"),
   (19, "William H.", "Harrison", "1841-04-03", "1841-04-04", "Whig", "OH", "1773-02-09", "1841-04-04", "Washington, D.C."),
   (20, "Ulysses S.", "Grant", "1869-04-03", "1877-04-03", "Republican", "OH", "1822-04-27", "1885-07-23", "Wilton, New York"),
   (21, "Rutherford B.", "Hayes", "1877-04-03", "1881-04-03", "Republican", "OH", "1822-10-04", "1893-01-17", "Fremont, Ohio"),
   (22, "James A.", "Garfield", "1881-04-03", "1881-09-19", "Republican", "OH", "1831-11-19", "1881-09-19", "Elberon, New Jersey"),
   (23, "William", "McKinley", "1897-04-03", "1901-09-14", "Republican", "OH", "1843-01-29", "1901-09-14", "Buffalo, New York"),
   (24, "William H.", "Taft", "1909-04-03", "1913-04-03", "Republican", "OH", "1857-09-15", "1930-03-08", "Washington, D.C."),
   (25, "Warren G.", "Harding", "1921-04-03", "1923-02-08", "Republican", "OH", "1865-11-02", "1923-08-02", "San Francisco, Cal."),
   (26, "Zachary", "Taylor", "1849-04-03", "1850-09-07", "Whig", "LA", "1784-11-24", "1850-07-09", "Washington, D.C"),
   (27, "Franklin", "Pierce", "1853-04-03", "1857-04-03", "Democratic", "NH", "1804-11-23", "1869-10-08", "Concord, New Hamp."),
   (28, "James", "Buchanan", "1857-04-03", "1861-04-03", "Democratic", "PA", "1791-04-23", "1868-06-01", "Lancaster, Pa."),
   (29, "Abraham", "Lincoln", "1861-04-03", "1865-04-15", "Republican/National Union", "IL", "1809-02-12", "1865-04-15", "Washington, D.C."),
   (30, "Barack", "Obama", "2009-01-20", NULL, "Democratic", "IL", "1961-08-04", NULL, NULL),
   (31, "Benjamin", "Harrison", "1889-04-03", "1893-04-03", "Republican", "IN", "1833-08-20", "1901-03-13", "Indianapolis, Indiana"),
   (32, "Woodrow", "Wilson", "1913-04-03", "1921-04-03", "Democratic", "NJ", "1856-12-28", "1924-02-03", "Washington, D.C."),
   (33, "Herbert", "Hoover", "1929-04-03", "1933-04-03", "Republican", "IA", "1874-08-10", "1964-10-20", "New York, New York"),
   (34, "Harry S.", "Truman", "1945-12-04", "1953-01-20", "Democratic", "MO", "1884-05-08", "1972-12-26", "Kansas City, Missouri"),
   (35, "Dwight D.", "Eisenhower", "1953-01-20", "1961-01-20", "Republican", "TX", "1890-10-14", "1969-03-28", "Washington, D.C."),
   (36, "Lyndon B.", "Johnson", "1963-11-22", "1969-01-20", "Democratic", "TX", "1908-08-27", "1973-01-22", "Gillespie Co., Texas"),
   (37, "George H. W.", "Bush", "1989-01-20", "1993-01-20", "Republican", "TX", "1924-06-12", NULL, NULL),
   (38, "George W.", "Bush", "2001-01-20", "2009-01-20", "Republican", "TX", "1946-07-06", NULL, NULL),
   (39, "Richard", "Nixon", "1969-01-20", "1974-09-08", "Republican", "CA", "1913-01-09", "1994-04-22", "New York, New York"),
   (40, "Ronald", "Reagan", "1981-01-20", "1989-01-20", "Republican", "CA", "1911-02-06", "2004-06-05", "Los Angeles, Cal."),
   (41, "Gerald", "Ford", "1974-09-08", "1977-01-20", "Republican", "MI", "1913-07-14", "2006-12-26", "Rancho Mirage, Cal."),
   (42, "Jimmy", "Carter", "1977-01-20", "1981-01-20", "Democratic", "GA", "1924-10-01", NULL, NULL),
   (43, "Bill", "Clinton", "1993-01-20", "2001-01-20", "Democratic", "AR", "1946-08-19", NULL, NULL);
   

INSERT INTO books
   (title, publisher, published_year, isbn, author_id)
VALUES
   ("Autobiography of Martin Van Buren", "U.S. Government Printing Office", 1920, NULL, 12),
   ("Mr. Buchanan's Administration on the Eve of Rebellion", "D. Appleton and Company", 1866, NULL, 28),
   ("Theodore Roosevelt: An Autobiography", "Macmillan", 1913, NULL, 17),
   ("Rough Riders", "Charles Scribner's Sons", 1899, NULL, 17),
   ("Autobiography of Calvin Coolidge", "Cosmopolitan Book Corporation", 1929, NULL, 7),
   ("Memoirs of Herbert Hoover", "Macmillan", 1951, NULL, 33),
   ("Memoirs: Year of Decisions", "Doubleday", 1955, NULL, 34),
   ("Memoirs: Years of Trial and Hope", "Doubleday", 1956, NULL, 34),
   ("Autobiography of Harry S Truman", "Colorado Associated University Press", 1980, "978-0870-81090-9", 34),
   ("At Ease: Stories I Tell to Friends", "Doubleday", 1969, NULL, 35),
   ("Crusade in Europe", "Doubleday", 1948, NULL, 35),
   ("Vantage Point", "Holt, Rinehart and Winston", 1971, "978-0030-84492-8", 36),
   ("RN - The Memoirs of Richard Nixon", "Grosset & Dunlap", 1978, "978-0448-14374-3", 39),
   ("In the Arena: A Memoir of Victory, Defeat, and Renewal", "Simon & Schuster", 1990, "978-0671-70096-6", 39),
   ("Six Crises", "Doubleday", 1962, "0-385-00125-8", 39),
   ("A Time To Heal", "Harper & Row", 1979, "978-0060-11297-4", 41),
   ("Keeping Faith: Memoirs of a President", "Bantam Books", 1982, "978-0553-05023-3", 42),
   ("Why Not the Best?: The First Fifty Years", "Broadman Press", 1975, "0-8054-5582-5", 42),
   ("Turning Point: A Candidate, a State, and a Nation Come of Age", "Three Rivers Press", 1993, "0-8129-2299-9", 42),
   ("An Hour Before Daylight: Memories of a Rural Boyhood", "Simon & Schuster", 2001, "0-7432-1199-5", 42),
   ("Full Life: Reflections at 90", "Simon & Schuster", 2015, "978-1-5011-1563-9", 42),
   ("An American Life", "Simon & Schuster", 1990, "0-7434-0025-9", 40),
   ("Where's the Rest of Me?", "Duell, Sloan and Pearce", 1965, "978-0918-29416-6", 40),
   ("My Life", "Knopf Publishing Group", 2004, "978-0-375-41457-2", 43),
   ("Decision Points", "Crown Publishers", 2010, "978-0-307-59061-9", 38),
   ("A Charge to Keep", "William Morrow & Company", 1999, "0-688-17441-8", 38),
   ("Personal Memoirs of Ulysses S. Grant", "Charles L. Webster & Company", 1885, NULL, 20),
   ("Looking Forward", "Doubleday", 1987, "0-3851-4181-5", 37),
   ("Dreams from My Father", "Times Books", 1995, "1-4000-8277-3", 30),
   ("Audacity of Hope", "Crown/Three Rivers Press", 2006, "0-307-23769-9", 30);
   