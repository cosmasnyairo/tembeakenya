import csv
from flask import Flask, jsonify, request

app = Flask(__name__)


def fetch_values(filename):
    """
    Fetch Destination details from files.

    ...

    Parameters:
    ----------
    filename: file to fetch values from
    limit: limit the number of rows we fetch \n
    offset: rows we skip
    """
    fetched_rows = []
    with open('data/{}.csv'.format(filename), newline='', encoding='utf-8') as f:
        values = request.get_json()
        if not values:
            response = {'message': 'No data found!'}
            return jsonify(response), 400
        required_fields = ['limit', 'offset']
        if not all(f in values for f in required_fields):
            response = {'message': 'Required data missing!'}
            return jsonify(response), 400

        limit = values['limit']
        offset = values['offset']
        reader = csv.DictReader(f)

        for i in range(offset):
            try:
                next(reader)
            except StopIteration:
                return jsonify({'response': 'No more records'}), 400

        for index, row in enumerate(reader):
            fetched_rows.append(row)
            if index >= limit:
                break
        response = [row for row in fetched_rows]
        return jsonify(response), 200


@app.route('/', methods=['GET'])
def index():
    """
    Index page
    """
    return 'Welcome to the index page!'


@app.route('/categories', methods=['GET'])
def categories():
    """
    Fetch Destination categories
    """
    categories = []
    filenames = ['art_and_culture', 'beaches',
                 'kid_friendly', 'museums', 'outdoors']

    for file in filenames:
        with open('data/{}.csv'.format(file), newline='', encoding='utf-8') as f:
            row_count = sum(1 for row in csv.reader(f))
            categories.append({'categories': file, 'length': row_count})

    return jsonify({"categories": categories}), 200


@app.route('/art_and_culture', methods=['GET'])
def art_and_culture():
    """
    Fetch Art and Culture Destinations:
    """
    return fetch_values('art_and_culture')


@app.route('/beaches', methods=['GET'])
def beaches():
    """
    Fetch Beach Destinations:
    """
    return fetch_values('beaches')


@app.route('/kid_friendly', methods=['GET'])
def kid_friendly():
    """
    Fetch Kid friendly Destinations:
    """
    return fetch_values('kid_friendly')


@app.route('/museums', methods=['GET'])
def museums():
    """
    Fetch Museum Destinations:
    """
    return fetch_values('museums')


@app.route('/outdoors', methods=['GET'])
def outdoors():
    """
    Fetch Outdoors Destinations:
    """
    return fetch_values('outdoors')


if __name__ == '__main__':
    app.run()
