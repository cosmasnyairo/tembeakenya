import csv
import requests
from bs4 import BeautifulSoup
import wikipedia

categories_url = {
    'kid_friendly': 'https://www.google.com/travel/things-to-do/see-all?g2lb=2502548%2C4258168%2C4260007%2C4270442%2C4274032%2C4291318%2C4305595%2C4306835%2C4308216%2C4308226%2C4317915%2C4326765%2C4328159%2C4329288%2C4330113%2C4333265%2C4356223%2C4357967%2C4363568%2C4364231%2C4366684%2C4366858%2C4369397%2C4371630%2C4270859%2C4284970%2C4291517%2C4316256%2C4356900&hl=en&gl=ke&un=1&otf=1&dest_mid=%2Fm%2F019rg5&dest_state_type=sattd&tcfs=EgsKCS9tLzAxOXJnNQ&sa=X&utm_campaign=sharing&utm_medium=link&utm_source=htls#ttdm=-1.411292_35.508286_7&ttdmf=%25252Fm%25252F09m90j',
    'outdoors': 'https://www.google.com/travel/things-to-do/see-all?g2lb=2502548%2C4258168%2C4260007%2C4270442%2C4274032%2C4291318%2C4305595%2C4306835%2C4308216%2C4308226%2C4317915%2C4326765%2C4328159%2C4329288%2C4330113%2C4333265%2C4356223%2C4357967%2C4363568%2C4364231%2C4366684%2C4366858%2C4369397%2C4371630%2C4270859%2C4284970%2C4291517%2C4316256%2C4356900&hl=en&gl=ke&un=1&otf=1&dest_mid=%2Fm%2F019rg5&dest_state_type=sattd&tcfs=EgsKCS9tLzAxOXJnNQ&sa=X&utm_campaign=sharing&utm_medium=link&utm_source=htls&rf=EhgKCi9tLzA1YjBuN2sSCE91dGRvb3JzKAE#ttdm=-1.036810_35.710672_7&ttdmf=%2525252Fm%2525252F09m90j',
    'art_and_culture': 'https://www.google.com/travel/things-to-do/see-all?g2lb=2502548%2C4258168%2C4260007%2C4270442%2C4274032%2C4291318%2C4305595%2C4306835%2C4308216%2C4308226%2C4317915%2C4326765%2C4328159%2C4329288%2C4330113%2C4333265%2C4356223%2C4357967%2C4363568%2C4364231%2C4366684%2C4366858%2C4369397%2C4371630%2C4270859%2C4284970%2C4291517%2C4316256%2C4356900&hl=en&gl=ke&un=1&otf=1&dest_mid=%2Fm%2F019rg5&dest_state_type=sattd&tcfs=EgsKCS9tLzAxOXJnNQ&sa=X&utm_campaign=sharing&utm_medium=link&utm_source=htls&rf=EhoKBy9tLzBqancSDUFydCAmIEN1bHR1cmUoAQ#ttdm=-1.543152_35.864969_7&ttdmf=%252525252Fm%252525252F09m90j',
    'museums': 'https://www.google.com/travel/things-to-do/see-all?g2lb=2502548%2C4258168%2C4260007%2C4270442%2C4274032%2C4291318%2C4305595%2C4306835%2C4308216%2C4308226%2C4317915%2C4326765%2C4328159%2C4329288%2C4330113%2C4333265%2C4356223%2C4357967%2C4363568%2C4364231%2C4366684%2C4366858%2C4369397%2C4371630%2C4270859%2C4284970%2C4291517%2C4316256%2C4356900&hl=en&gl=ke&un=1&otf=1&dest_mid=%2Fm%2F019rg5&dest_state_type=sattd&tcfs=EgsKCS9tLzAxOXJnNQ&sa=X&utm_campaign=sharing&utm_medium=link&utm_source=htls&rf=EhUKCC9tLzA5Y21xEgdNdXNldW1zKAE#ttdm=-1.684983_36.697686_7&ttdmf=%25252525252Fm%25252525252F09m90j',
    'beaches': 'https://www.google.com/travel/things-to-do/see-all?g2lb=2502548%2C4258168%2C4260007%2C4270442%2C4274032%2C4291318%2C4305595%2C4306835%2C4308216%2C4308226%2C4317915%2C4326765%2C4328159%2C4329288%2C4330113%2C4333265%2C4356223%2C4357967%2C4363568%2C4364231%2C4366684%2C4366858%2C4369397%2C4371630%2C4270859%2C4284970%2C4291517%2C4316256%2C4356900&hl=en&gl=ke&un=1&otf=1&dest_mid=%2Fm%2F019rg5&dest_state_type=sattd&tcfs=EgsKCS9tLzAxOXJnNQ&sa=X&utm_campaign=sharing&utm_medium=link&utm_source=htls&rf=EhUKCC9tLzBiM3lyEgdCZWFjaGVzKAE#ttdm=-4.479963_39.557608_9&ttdmf=%2525252525252Fm%2525252525252F09m90j'
}

kid_friendly, outdoors, art_and_culture, museums, beaches = [], [], [], [], []

headers = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36'}


def save_results(filename, fetched_data):
    csv_columns = ['title', 'image_url',
                   'about', 'summary', 'wikipedia_url', 'no_of_reviews', 'review']
    try:
        with open('data/{}.csv'.format(filename), 'w',  encoding='utf-8', newline='') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=csv_columns)
            writer.writeheader()
            for data in fetched_data:
                writer.writerow(data)
    except IOError:
        print("I/O error")


for url in categories_url:
    fetched_images, fetched_titles = [], []
    r = requests.get(categories_url[url], headers=headers)
    soup = BeautifulSoup(r.content, 'html.parser')
    fetched_titles = soup.find_all('div', {'class': 'rbj0Ud'})
    fetched_review_score = soup.find_all('span', {'class': 'KFi5wf lA0BZ'})
    fetched_review_numbers = soup.find_all('span', {'class': 'jdzyld XLC8M'})
    fetched_about = soup.find_all('div', {'class': 'nFoFM'})

    for image in soup.find_all('easy-img', {'class': 'dBuxib SCkDmc'}):
        img_url = image.find(
            'img', {'class': ['R1Ybne YH2pd', 'R1Ybne pzJ1lf']})
        fetched_images.append(img_url['data-src'])

    for title, image, about, review, review_no in zip(fetched_titles, fetched_images, fetched_about, fetched_review_numbers, fetched_review_score):
        wikipediaurl, summary = '', ''
        try:
            summary = wikipedia.summary(title.text.replace(' ', '_'))
            wikipediaurl = wikipedia.page(title.text.replace(' ', '_')).url

        except:
            pass
        if url == 'kid_friendly':
            kid_friendly.append(
                {'title': title.text.strip(), 'image_url': image.strip(),
                 'about': about.text.strip(), 'summary': summary, 'wikipedia_url': wikipediaurl,
                 'no_of_reviews': review.text.replace('(', '').replace(')', '').strip(), 'review': review_no.text.strip(), })
            save_results('kid_friendly', kid_friendly)

        elif url == 'outdoors':
            outdoors.append(
                {'title': title.text.strip(), 'image_url': image.strip(),
                 'about': about.text.strip(), 'summary': summary, 'wikipedia_url': wikipediaurl,
                 'no_of_reviews': review.text.replace('(', '').replace(')', '').strip(), 'review': review_no.text.strip(), })
            save_results('outdoors', outdoors)
        elif url == 'art_and_culture':
            art_and_culture.append(
                {'title': title.text.strip(), 'image_url': image.strip(),
                 'about': about.text.strip(), 'summary': summary, 'wikipedia_url': wikipediaurl,
                 'no_of_reviews': review.text.replace('(', '').replace(')', '').strip(), 'review': review_no.text.strip(), })
            save_results('art_and_culture', art_and_culture)
        elif url == 'museums':
            museums.append(
                {'title': title.text.strip(), 'image_url': image.strip(),
                 'about': about.text.strip(), 'summary': summary, 'wikipedia_url': wikipediaurl,
                 'no_of_reviews': review.text.replace('(', '').replace(')', '').strip(), 'review': review_no.text.strip(), })
            save_results('museums', museums)
        elif url == 'beaches':
            beaches.append(
                {'title': title.text.strip(), 'image_url': image.strip(),
                 'about': about.text.strip(), 'summary': summary, 'wikipedia_url': wikipediaurl,
                 'no_of_reviews': review.text.replace('(', '').replace(')', '').strip(), 'review': review_no.text.strip(), })
            save_results('beaches', beaches)
