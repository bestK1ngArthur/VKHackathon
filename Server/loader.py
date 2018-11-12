import sqlite3
import csv
import pandas as pd

db_name = "events.db"

connection = sqlite3.connect(db_name)
cursor = connection.cursor()

query_events = """
    CREATE TABLE events
    (
          events_id INTEGER PRIMARY KEY,
          link text,
          name text,
          date date,
          descr text,
          stream text,
          place text,
          status bigint,
          created bigint,
          level INTEGER
    );
"""

query_users = """
    CREATE TABLE users
    (
      id bigint NOT NULL AUTO_INCREMENT,
      name text,
      pass text,
      region text,
      status bigint,
      stream1 text,
      lvl1 bigint DEFAULT 0,
      stream2 text,
      lvl2 bigint DEFAULT 0,
      stream3 text,
      lvl3 bigint DEFAULT 0,
      stream4 text,
      lvl4 bigint DEFAULT 0,
      stream5 text,
      lvl5 bigint DEFAULT 0,
      stream6 text,
      lvl6 bigint DEFAULT 0,
      CONSTRAINT id PRIMARY KEY (id)
    );
"""

query_hist = """
    CREATE TABLE hist
    (
      user_id bigint,
      event_id bigint,
      visited bigint,
      rating bigint,
      comments text
    );
"""

"""
cursor.execute(query_events)
cursor.execute(query_users)
cursor.execute(query_hist)
"""

# load data for users
df = pd.read_csv('users.csv', encoding = "cp1251", header=0, index_col=False, sep =';')
df.columns = df.columns.str.strip()
df.to_sql("users", connection, if_exists='append', index=False)

# load data for events
df = pd.read_csv('events.csv' , encoding = "cp1251", header=0, index_col=False, sep =';')
df.columns = df.columns.str.strip()
df.to_sql("events", connection, if_exists='append',index=False)

# load data for hist
df = pd.read_csv('hist.csv' , encoding = "cp1251",header=0, index_col=False, sep =';')
df.columns = df.columns.str.strip()
df.to_sql("hist", connection, if_exists='append', index=False)

cursor.close()
connection.commit()
connection.close()


