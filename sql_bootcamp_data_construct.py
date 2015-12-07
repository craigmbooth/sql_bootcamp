"""This code reads a few CSVs from `data/`, normalizes them, and writes out a
SQL file that imports them into a MySQL database
"""
import os
import random
import string

import dateutil
import jinja2
import pandas

PATH = os.path.dirname(os.path.abspath(__file__))
TEMPLATE_ENVIRONMENT = jinja2.Environment(
    autoescape=False,
    loader=jinja2.FileSystemLoader(os.path.join(PATH, 'templates')),
    trim_blocks=False)


def render_template(template_filename, context):
    """Given a filename to write to and a conect, render out the Jinja template

    :return: The Jinja2 environment
    :rtype: :py:class:`jinja2.Environment`
    """
    return TEMPLATE_ENVIRONMENT.get_template(template_filename).render(context)


def get_states():
    """Read a number of CSVs and combine them into a single pandas dataframe
    where each row represents a single state

    :return: Information on states
    :rtype: :py:class:`pandas.DataFrame`
    """
    states = pandas.read_csv("data/StateDemographics.csv")
    regions = pandas.read_csv("data/StateRegions.csv")
    populations = pandas.read_csv("data/StatePopulations.csv")
    populations.drop('number', axis=1, inplace=True)

    water_area = pandas.read_csv("data/StatesWaterArea.csv")
    water_area = water_area[water_area["state"] != "United States"]
    water_area.drop(['number', "sq_km_water", "water_pct"], axis=1,
                    inplace=True)

    land_area = pandas.read_csv("data/StatesLandArea.csv")
    land_area = land_area[land_area["state"] != "United States"]
    land_area.drop(['number', "sq_km_land"], axis=1, inplace=True)

    states = states.merge(populations, on="state")
    states = states.merge(water_area, on="state")
    states = states.merge(land_area, on="state")
    states = states.merge(regions, on="state", how="inner")

    # Changes strings with commas in numbers into actual numbers
    for col in ["population", "sq_mile_water", "sq_mile_land"]:
        states[col] = states[col].apply(lambda x: int(x.replace(",", "")))

    return states


def get_presidents():
    """Read a number of CSVs and combine them into a single pandas dataframe
    where each row represents a single president

    :return: Information on presidents
    :rtype: :py:class:`pandas.DataFrame`
    """
    presidents = pandas.read_csv("data/PresidentsWikipedia.csv")
    birth_death = pandas.read_csv("data/PresidentBirthDeath.csv")
    states = pandas.read_csv("data/StateDemographics.csv")

    presidents = presidents.merge(states, left_on="home_state", right_on="state")
    presidents.drop(["wikipedia", "home_state", "state", "number"],
                    axis=1, inplace=True)
    presidents = presidents.merge(birth_death, how="outer",
                                  on=["first_name", "last_name"])

    presidents = presidents.reset_index()
    presidents = presidents.rename(columns={"abbreviation": "home_state",
                                            "index": "id"})
    return presidents


def get_books(presidents):
    """Read a number of CSVs and combine them into a single pandas dataframe
    where each row represents a single presidential autobiography

    :param presidents: A frame containing information on presidents
    :type presidents: :py:class: `pandas.DataFrame`

    :return: Information on presidential autobiographies
    :rtype: :py:class:`pandas.DataFrame`
    """
    books = pandas.read_csv("data/books.csv")
    books = books.merge(presidents, on=["first_name", "last_name"])
    books.drop(["first_name", "last_name", "birth", "birth_place",
                "death", "death_place", "left_office", "party", "home_state",
                "took_office"], axis=1, inplace=True)

    books = books.rename(columns={"id": "author_id"})

    return books

def to_sql_string(inp):
    """Given an input, if it is null then return the string NULL, else format
    a string containing a date that MySQL can understand and return that

    :param inp: The input to format
    :type inp: `str` or `NoneType`

    :returns: The string NULL or a datetime
    :rtype: `str`
    """
    #n.b. cannot use strptime because it only works for years > 1900
    if pandas.isnull(inp):
        return "NULL"
    return '"{}"'.format(dateutil.parser.parse(inp).isoformat(" ").split()[0])

def string_or_none(inp):
    """Given an input, if it is null then return the string NULL, else return
    a string wrapped in quotes


    :param inp: The input to format
    :type inp: `str` or `NoneType`

    :returns: The string NULL or a string wrapped in quotes
    :rtype: `str`
    """
    if pandas.isnull(inp):
        return "NULL"
    else:
        return '"{}"'.format(inp)

def dump_sql(states, presidents, books):
    """Given the dataframes that represent states, presidents and books,
    return a list of strings containing the SQL statements needed to add
    them to some SQL code

    :param states: A frame describing states
    :type states: :py:class:`pandas.DataFrame`
    :param presidents: A frame describing presidents
    :type presidents: :py:class:`pandas.DataFrame`
    :param books: A frame describing books
    :type books: :py:class:`pandas.DataFrame`

    :returns: The SQL statements needed to insert each row of the frames
        into a SQL database
    :rtype: A `tuple` of three `lists`s of `str`
    """
    president_rows = []
    state_rows = []
    book_rows = []

    for _, row in presidents.iterrows():
        president_rows.append(
            '({}, "{}", "{}", {}, {}, "{}", "{}", {}, {}, {})'.format(
                row["id"],
                row["first_name"],
                row["last_name"],
                to_sql_string(row["took_office"]),
                to_sql_string(row["left_office"]),
                row["party"],
                row["home_state"],
                to_sql_string(row["birth"]),
                to_sql_string(row["death"]),
                string_or_none(row["death_place"])
            )
        )

    for _, row in states.iterrows():
        state_rows.append(
            '("{}", "{}", {}, {}, {}, "{}")'.format(
                row["abbreviation"],
                row["state"],
                row["population"],
                row["sq_mile_water"],
                row["sq_mile_land"],
                row["region"]
            )
        )

    for _, row in books.iterrows():
        book_rows.append(
            '("{}", "{}", {}, {}, {})'.format(
                row["title"],
                row["publisher"],
                row["year"],
                string_or_none(row["isbn"]),
                row["author_id"]
            )
        )

    return president_rows, state_rows, book_rows


def dump_big_sql(nrows=512000):
    """Script generates a bunch of random rows of data for demonstrating how
    indexes help us query quickly.

    :param nrows: The number of rows to generate
    :type nrows: `int`

    :returns: A list of SQL statements that are to be inserted in a table
    :rtype: `list` of `str`
    """
    random_rows = []
    for _ in range(nrows):
        random_string = ''.join(random.choice(string.ascii_uppercase +
                                              string.digits) for _ in range(32))
        random_rows.append('INSERT INTO big_dataset VALUES ("{}", {});'.format(
            random_string, random.randint(1, 100000)))
    return random_rows


def main():
    """Executed if you run the script from the command line"""

    states = get_states()
    presidents = get_presidents()
    books = get_books(presidents)

    # Write the sql_bootcamp dataset
    president_rows, state_rows, book_rows = dump_sql(states, presidents, books)
    context = {'presidents': president_rows, 'states': state_rows,
               "books": book_rows}
    sql = render_template('load_data.sql', context)
    with open("load_data.sql", "w") as file_handle:
        file_handle.write(sql)

    # Write the big, random dataet to demonstrate indexes
    random_rows = dump_big_sql()
    context = {'random_data': random_rows}
    sql = render_template('big_dataset.sql', context)
    with open("big_dataset.sql", "w") as file_handle:
        file_handle.write(sql)


if __name__ == "__main__":
    main()
