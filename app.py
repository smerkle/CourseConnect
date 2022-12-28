# import the Flask framework
from flask import Flask, jsonify
from flaskext.mysql import MySQL
from src import create_app
from src import db

# create a flask object
app = Flask(__name__)

app = create_app()

# --------------------------------------------------------------------
# Create a function named hello world that
# returns a simple html string
# the @the_app.route("/") connects the hello_world function to
# the URL /

@app.route("/")
def hello_world():
    return '<h1>Hello! Use an app route to visit a certain page!</h1>'

@app.route("/admin", methods=["GET"])
def admin_info():
    cur = db.get_db().cursor()
    cur.execute('select prefix, officeLocation, firstName, lastName,  position, personalDescription from Administration')
    row_headers = [x[0] for x in cur.description]
    json_data = []
    theData = cur.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    return jsonify(json_data)

@app.route("/nurse", methods=["GET"])
def nurse_info():
    cur = db.get_db().cursor()
    cur.execute('select firstName, lastName, prefix, walkInHours, schoolEmail, RoomLocation from Nurse')
    row_headers = [x[0] for x in cur.description]
    json_data = []
    theData = cur.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    return jsonify(json_data)


# If this file is being run directly, then run the application
# via the the_app object.
# debug = True will provide helpful debugging information and
#   allow hot reloading of the source code as you make edits and
#   save the files.
if __name__ == '__main__':
    app.run(debug = True, host = '0.0.0.0', port = 4000)