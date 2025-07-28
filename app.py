from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "message": "Welcome to WoodenGhost!",
        "status": "running",
        "environment": os.getenv('ENV', 'production')
    })

@app.route('/health')
def health_check():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    port = int(os.getenv('PORT', 8000))
    debug = os.getenv('ENV') == 'development'
    app.run(host='0.0.0.0', port=port, debug=debug) 