# Some set up for the application
from flaskext.mysql import MySQL
from flask import Flask, jsonify, make_response


# create a MySQL object that we will use in other parts of the API
db = MySQL()

def create_app():
    app = Flask(__name__)
    
    # secret key that will be used for securely signing the session 
    # cookie and can be used for any other security related needs by 
    # extensions or your application
    app.config['SECRET_KEY'] = 'someCrazyS3cR3T!Key.!'

    # these are for the DB object to be able to connect to MySQL. 
    app.config['MYSQL_DATABASE_USER'] = 'webapp'
    app.config['MYSQL_DATABASE_PASSWORD'] = open('/secrets/db_password.txt').readline()
    app.config['MYSQL_DATABASE_HOST'] = 'db'
    app.config['MYSQL_DATABASE_PORT'] = 3306
    app.config['MYSQL_DATABASE_DB'] = 'course_connect'  # Change this to your DB name

    # Initialize the database object with the settings above. 
    db.init_app(app)
    
    # Import the various routes
    from src.student.student import student
    from src.guardian.guardian import guardian
    from src.teacher.teacher import teacher

    # Register the routes that we just imported so they can be properly handled
    app.register_blueprint(guardian, url_prefix='/guard')
    app.register_blueprint(student, url_prefix='/stu')
    app.register_blueprint(teacher, url_prefix='/teach')

    return app

def get_something(query):
    cursor = db.get_db().cursor()
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    the_data = cursor.fetchall()
    for row in the_data:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response