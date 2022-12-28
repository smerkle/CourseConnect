from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db
from src import get_something


student = Blueprint('student', __name__)

# Get all student from the DB
@student.route("/home", methods=["GET"])
def student_home():
    return get_something('select * from Student')

@student.route("/info", methods=["GET"])
def get_info():
    cur = db.get_db().cursor()
    cur.execute('select firstName, lastName, stu_id, stuEmail, gradYear, birthDate from Student')
    row_headers = [x[0] for x in cur.description]
    json_data = []
    theData = cur.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    return jsonify(json_data)

@student.route("/courses", methods=["GET"])
def student_courses():
    cur = db.get_db().cursor()
    cur.execute('select courseID, difficultyLevel, description, name from Course')
    row_headers = [x[0] for x in cur.description]
    json_data = []
    theData = cur.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    return jsonify(json_data)

@student.route("/courses/wishlist", methods=["POST"])
def course_wishlist():

    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    courseid = request.form['courseid']
    stu_id = request.form['stu_id']
    query = f'INSERT INTO Course_wishlist(courseid, stu_id) VALUES(\"{courseid}\", \"{stu_id}\")'
    cursor.execute(query)
    db.get_db().commit()

@student.route("/wishlist", methods=["GET"])
def show_wishlist():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Course_wishlist')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    return jsonify(json_data)

@student.route("/transcript", methods=["GET"])
def stu_transcript():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Transcript')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    return jsonify(json_data)

