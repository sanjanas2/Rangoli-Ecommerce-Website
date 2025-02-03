from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
import datetime

app = Flask(__name__)

# MySQL connection setup
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="12345",
    database="fashion"
)
mycursor = mydb.cursor()

# Define routes for different functionalities
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/merlin')
def merlin():
    return render_template('merlin.html')

@app.route('/products')
def products():
    return render_template('products.html')

@app.route('/categories')
def categories():
    return render_template('categories.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/static/<path:path>')
def static_file(path):
    return app.send_static_file(path)

if __name__ == '__main__':
    app.run(debug=True)
