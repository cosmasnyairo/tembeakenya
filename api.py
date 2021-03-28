import csv

from flask import Flask, jsonify, request, render_template

app = Flask(__name__)


filenames = ['art_and_culture', 'beaches',
             'kid_friendly', 'museums', 'outdoors']


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


@app.route('/policy', methods=['GET'])
def policy():
    
    return render_template('policy.html')


@app.route('/categories', methods=['GET'])
def categories():
    """
    Fetch Destination categories
    """
    categories = []

    for file in filenames:
        with open('data/{}.csv'.format(file), newline='', encoding='utf-8') as f:
            reader = csv.reader(f)
            next(reader)
            row_count = sum(1 for row in reader)
            categories.append({'categories': file, 'length': row_count})

    return jsonify(categories), 200


@app.route('/searchdestination', methods=['POST'])
def searchdestination():
    """
    Search a destination from the files.

    ...
    """

    values = request.get_json()
    if not values:
        response = {'message': 'No data found!'}
        return jsonify(response), 400
    required_fields = ['query']
    if not all(f in values for f in required_fields):
        response = {'message': 'Required data missing!'}
        return jsonify(response), 400

    query = values['query']
    results=[]
    destinations=[]
    for file in filenames:
        with open('data/{}.csv'.format(file), newline='', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            results.append([row for row in reader if query.lower() in row['title'].lower()])
    
    for r in results:
        [destinations.append(row) for row in r if row not in destinations and row!=[]]
    return jsonify(destinations), 200


@app.route('/art_and_culture', methods=['POST'])
def art_and_culture():
    """
    Fetch Art and Culture Destinations:
    """
    return fetch_values('art_and_culture')


@app.route('/beaches', methods=['POST'])
def beaches():
    """
    Fetch Beach Destinations:
    """
    return fetch_values('beaches')


@app.route('/kid_friendly', methods=['POST'])
def kid_friendly():
    """
    Fetch Kid friendly Destinations:
    """
    return fetch_values('kid_friendly')


@app.route('/museums', methods=['POST'])
def museums():
    """
    Fetch Museum Destinations:
    """
    return fetch_values('museums')


@app.route('/outdoors', methods=['POST'])
def outdoors():
    """
    Fetch Outdoors Destinations:
    """
    return fetch_values('outdoors')


if __name__ == '__main__':
    app.run()
