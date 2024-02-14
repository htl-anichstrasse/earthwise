from website import create_app
from flask_compress import Compress

app = create_app()
compress = Compress(app)

if __name__ == '__main__':
    app.run(debug=True)

