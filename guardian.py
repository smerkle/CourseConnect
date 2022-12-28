from flask import Blueprint, request, jsonify, make_response
import json
from src import db


guardian = Blueprint('guardian', __name__)

# Get all the guardian from the database
@guardian.route('/home', methods=["GET"])
def guardian_home():
   cur = db.get_db().cursor()
   cur.execute('select * from Guardian')
   row_headers = [x[0] for x in cur.description]
   json_data = []
   theData = cur.fetchall()
   for row in theData:
       json_data.append(dict(zip(row_headers, row)))
   return jsonify(json_data)

@guardian.route("/info", methods=["GET"])
def guard_info():
    cur = db.get_db().cursor()
    cur.execute('select * from Guardian g')
    row_headers = [x[0] for x in cur.description]
    json_data = []
    theData = cur.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    return jsonify(json_data)