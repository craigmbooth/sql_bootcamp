import os
import pandas
import dateutil
from jinja2 import Environment, FileSystemLoader

PATH = os.path.dirname(os.path.abspath(__file__))
TEMPLATE_ENVIRONMENT = Environment(
        autoescape=False,
    loader=FileSystemLoader(os.path.join(PATH, 'templates')),
    trim_blocks=False)


def render_template(template_filename, context):
    """
    XXXXXX

    :return: The Jinja2 environment
    :rtype: :py:class:`jinja2.Environment`
    """
    return TEMPLATE_ENVIRONMENT.get_template(template_filename).render(context)


def get_states():
    states = pandas.read_csv("data/state.csv")
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

    # Changes strings with commas in numbers into actual numbers
    for col in ["population", "sq_mile_water", "sq_mile_land"]:
        states[col] = states[col].apply(lambda x: int(x.replace(",","")))

    return states


def get_presidents():
    presidents = pandas.read_csv("data/PresidentsWikipedia.csv")
    birth_death = pandas.read_csv("data/PresidentBirthDeath.csv")
    states = pandas.read_csv("data/state.csv")

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
    books = pandas.read_csv("data/books.csv")
    books = books.merge(presidents, on=["first_name", "last_name"])
    books.drop(["first_name", "last_name", "birth", "birth_place",
                "death", "death_place", "left_office", "party", "home_state",
                "took_office"], axis=1, inplace=True)

    books = books.rename(columns={"id": "author_id"})

    return books

def to_sql_string(inp):
    #n.b. cannot use strptime because it only works for years > 1900
    if pandas.isnull(inp):
        return "NULL"
    return '"{}"'.format(dateutil.parser.parse(inp).isoformat(" ").split()[0])

def string_or_none(inp):

    if pandas.isnull(inp):
        return "NULL"
    else:
        return '"{}"'.format(inp)

def dump_sql(states, presidents, books):

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
        ))

    for _, row in states.iterrows():
        state_rows.append(
            '("{}", "{}", {}, {}, {})'.format(
                row["abbreviation"],
                row["state"],
                row["population"],
                row["sq_mile_water"],
                row["sq_mile_land"]
        ))

    for _, row in books.iterrows():
        book_rows.append(
            '("{}", "{}", {}, {}, {})'.format(
                row["title"],
                row["publisher"],
                row["year"],
                string_or_none(row["isbn"]),
                row["author_id"]
        ))

    return president_rows, state_rows, book_rows

if __name__ == "__main__":
    states = get_states()
    presidents = get_presidents()
    books = get_books(presidents)

    president_rows, state_rows, book_rows = dump_sql(states, presidents, books)

    context = {'presidents': president_rows, 'states': state_rows,
               "books": book_rows}

    sql = render_template('load_data.sql', context)
    with open("load_data.sql", "w") as f:
        f.write(sql)
