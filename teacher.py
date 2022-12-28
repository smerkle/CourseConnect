from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db

teacher = Blueprint('teacher', __name__)

@teacher.route("/home", methods = ["GET"])
def teacher_home():
    cur = db.get_db().cursor()
    cur.execute('select firstName, lastName, prefix, schoolEmail, facultyID from Teacher')
    row_headers = [x[0] for x in cur.description]
    json_data = []
    theData = cur.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    return jsonify(json_data)


@teacher.route("/info", methods = ["GET"])
def teacher_info():
    cur = db.get_db().cursor()
    cur.execute('select personalDescription, officeHours, degrees, facultyID, lastName from Teacher')
    row_headers = [x[0] for x in cur.description]
    json_data = []
    theData = cur.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    return jsonify(json_data)


@teacher.route("/grades", methods=["POST"])
def grade_input():
    current_app.logger.info(request.form)
    cursor = db.get_db().cursor()
    assignmentName = request.form['assignmentName']
    courseID = request.form['courseID']
    courseID = int(courseID)
    grade = request.form['grade']
    grade = int(grade)
    comment = request.form['comment']
    weight = request.form['weight']
    weight = int(weight)
    query = f'INSERT INTO Assignment(name, grade, comment, weight, courseID) VALUES(\"{assignmentName}\", \"{grade}\", \"{comment}\", \"{weight}\", \"{courseID}\" )'
    cursor.execute(query)
    db.get_db().commit()
    return "Success!"

@teacher.route("/grades/proof")
def grades_proof():
    cur = db.get_db().cursor()
    cur.execute('select * from Assignment')
    row_headers = [x[0] for x in cur.description]
    json_data = []
    theData = cur.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    return jsonify(json_data)


