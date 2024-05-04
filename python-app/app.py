from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    """
    Render the home template. Con un cambio"
    
    This route renders a template named 'home.html' and passes the 'posts' list to it.
    """
    return render_template('home.html')

@app.route('/ping')
def ping():
    """
    Respond with a 'pong modified' string.
    """
    return "pong 2"
 
if __name__ == '__main__':
    app.run(port=5000)