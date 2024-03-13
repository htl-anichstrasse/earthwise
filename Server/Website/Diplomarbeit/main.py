from website import create_app
from flask_compress import Compress

# Create the Flask app using the create_app function from the website module
app = create_app()

# Enable compression for the app using Flask-Compress
compress = Compress(app)

# Run the app if the script is executed directly
if __name__ == '__main__':
    app.run(debug=True)
