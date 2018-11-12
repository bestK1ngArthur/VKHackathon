#!/usr/bin/env python3
"""
Very simple HTTP server in python for logging requests
Usage::
    ./server.py [<port>]

create_event – создать событие
visit - посетить
visited - посетил
get_events – получить события
register – регистрация пользователя
get_info – получить информацию о пользователе
"""
from http.server import BaseHTTPRequestHandler, HTTPServer
import logging
import urllib.parse
import json
import sqlite3
import sys

class methodHandler:
    def __init__(self, data):
        self.req_dict = data
        self.response = "no response"

    def result(self):
        self.response = getattr(self, self.req_dict['method'])()
        return json.dumps(self.response)

    def create_event(self):
        #link, name, date, descr, place
        query = "SELECT * FROM events WHERE link=?;"
        connection = sqlite3.connect("events.db")
        cursor = connection.cursor()
        cursor.execute(query, [self.req_dict['link']])
        results = cursor.fetchall()
        print("len " + str(len(results)))
        if len(results) == 0:
            query = "INSERT INTO events(link, name,date, descr, stream, place, status, created, level) VALUES (?, ?,?, ?, ?, ?, ?, ?,?);"
            cursor.execute(query, [self.req_dict['link'],self.req_dict['name'],self.req_dict['date'],
                                   self.req_dict['descr'],self.req_dict['stream'],
                                   self.req_dict['place'],"","",self.req_dict['level']])
            results = cursor.fetchall()
            print(results)
        else:
            cursor.close()
            connection.close()
            print(results)
            return dict([('exist', results[0][0])])

        cursor.close()
        connection.commit()
        connection.close()
        return dict([('exist', -1)])

    def visit(self):
        connection = sqlite3.connect("events.db")
        cursor = connection.cursor()
        query = "INSERT INTO hist(user_id, event_id,visited, rating, comments) VALUES (?, ?, ?, ?, ?);"
        cursor.execute(query,
                       [self.req_dict['user_id'], self.req_dict['event_id'],"", 5, "Очень понравилось"])
        results = cursor.fetchall()
        print(results)
        cursor.close()
        connection.commit()
        connection.close()
        return dict([('text', "Good luck")])

    def visited(self):
        connection = sqlite3.connect("events.db")
        cursor = connection.cursor()
        query = "UPDATE hist SET visited = ? , rating = ? WHERE user_id = ? AND event_id = ? ;"
        print(self.req_dict)
        cursor.execute(query,
                       ["X", 4, self.req_dict['user_id'], self.req_dict['event_id']])
        results = cursor.fetchall()
        print(results)
        cursor.close()
        connection.commit()
        connection.close()
        return dict([('text', "Congratulations")])

    def get_events(self):
        connection = sqlite3.connect("events.db")
        cursor = connection.cursor()
        query = "SELECT * FROM events WHERE stream=?";
        cursor.execute(query,[self.req_dict['stream']])
        results = cursor.fetchall()
        res = list()
        for r in results:
            res.append(dict([('event_id', r[0]),
                             ('link', r[1]),
                             ('name', r[2]),
                             ('date', r[3]),
                             ('descr', r[4]),
                             ('steam', r[5]),
                             ('place', r[6]),
                             ('level',r[9])
                            ]))
        return res

    def get_personal_events(self):
        #user_id
        themes = {
            1: "Информационные технологии",
            2: "Математика",
            3: "Химия",
            4: "Биология",
            5: "Физика",
            6: "Проектная смена"
        }

        connection = sqlite3.connect("events.db")
        cursor = connection.cursor()
        query = "SELECT * FROM users WHERE id = ?"
        cursor.execute(query, [self.req_dict['user_id']])
        user = cursor.fetchall()[0]
        print(user)

        res = list()
        for key, value in themes.items():
            stream = value
            position = 4 + key*2
            low = int(user[position]) - 1
            high = int(user[position]) + 2
            print(stream, key, position,low,high)
            query = "SELECT * FROM events WHERE stream=? AND level >= ? AND level <= ?";
            cursor.execute(query, [stream, low, high])
            results = cursor.fetchall()

            for r in results:
                print(user[position - 1])
                res.append(dict([('event_id', r[0]),
                                 ('link', r[1]),
                                 ('name', r[2]),
                                 ('date', r[3]),
                                 ('descr', r[4]),
                                 ('stream', r[5]),
                                 ('place', r[6]),
                                 ('level',r[9]),
                                 ('native',user[position - 1])
                                ]))
        return res

    def register(self):
        connection = sqlite3.connect("events.db")
        cursor = connection.cursor()
        query = "SELECT * FROM users WHERE name=?"
        cursor.execute(query,[self.req_dict['name']])
        results = cursor.fetchall()
        if len(results) == 0:
            print(self.req_dict)
            query = """INSERT INTO users(name, pass, region,
                stream1,lvl1, stream2, lvl2, stream3, lvl3, stream4, lvl4, stream5, lvl5, stream6, lvl6) 
                VALUES (?, ?, ?, ?, ?, ?,?, ?, ?,?, ?, ?,?, ?, ?);"""

            cursor.execute(query, [self.req_dict['name'], "", self.req_dict['region'],
                                   self.req_dict['stream1'], self.req_dict['lvl1'],
                                   self.req_dict['stream2'], self.req_dict['lvl2'],
                                   self.req_dict['stream4'], self.req_dict['lvl3'],
                                   self.req_dict['stream4'], self.req_dict['lvl4'],
                                   self.req_dict['stream5'], self.req_dict['lvl5'],
                                   self.req_dict['stream6'], self.req_dict['lvl6']])

            query = "SELECT * FROM users WHERE name=?"
            cursor.execute(query, [self.req_dict['name']])
            results = cursor.fetchall()

            cursor.close()
            connection.commit()
            connection.close()
            return dict([('success', "X"),('user_id',results[0][0])])

        cursor.close()
        connection.close()
        return dict([('success', ""),('user_id',results[0][0])])

    def get_info(self):
        connection = sqlite3.connect("events.db")
        cursor = connection.cursor()
        query = "SELECT * FROM users WHERE id=?"
        cursor.execute(query, [self.req_dict['user_id']])
        results = cursor.fetchall()
        print(results[0])
        res = dict([('name', results[0][1]),
                            ('stream1', results[0][5]),
                            ('lvl1', results[0][6]),
                            ('stream2', results[0][7]),
                            ('lvl2', results[0][8]),
                            ('stream3', results[0][9]),
                            ('lvl3', results[0][10]),
                            ('stream4', results[0][11]),
                            ('lvl4', results[0][12]),
                            ('stream5', results[0][13]),
                            ('lvl5', results[0][14]),
                            ('stream6', results[0][15]),
                            ('lvl6', results[0][16]),
                            ('region', results[0][3])])

        events_list = list()
        query = "SELECT * FROM hist WHERE user_id=?;"
        cursor.execute(query, [self.req_dict['user_id']])
        results = cursor.fetchall()
        for r in results:
            query = "SELECT * FROM events WHERE events_id=?";
            cursor.execute(query, [r[1]])
            sub_results = cursor.fetchall()
            events_list.append(dict([('event_id', sub_results[0][0]),
                             ('link', sub_results[0][1]),
                             ('name', sub_results[0][2]),
                             ('date', sub_results[0][3]),
                             ('descr', sub_results[0][4]),
                             ('stream', sub_results[0][5]),
                             ('place', sub_results[0][6]),
                             ('visited', r[2])]))
        res['events'] = events_list
        return res


class S(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        logging.info("GET request,\nPath: %s\nHeaders:\n%s\n", str(self.path), str(self.headers))
        self._set_response()
        if "?" not in self.path:
            self.wfile.write("GET request for favicon".encode('utf-8'))
            return
        response_get = methodHandler(dict(urllib.parse.parse_qsl(self.path.split("?")[1], True)))
        self.wfile.write("GET request for {}".format(response_get.result()).encode('utf-8'))

    def do_POST(self):
        content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
        post_data = self.rfile.read(content_length) # <--- Gets the data itself
        logging.info("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                str(self.path), str(self.headers), post_data.decode('utf-8'))

        self._set_response()
        if not self.rfile:
            return
        response_get = methodHandler(dict(urllib.parse.parse_qs(self.rfile.read(int(self.headers['Content-Length'])))))
        self.wfile.write("POST request for {}".format(self.path).encode('utf-8'))

def run(server_class=HTTPServer, handler_class=S, port=8080):
    logging.basicConfig(level=logging.INFO)
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    logging.info('Starting httpd...\n')
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    logging.info('Stopping httpd...\n')

if __name__ == '__main__':
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()