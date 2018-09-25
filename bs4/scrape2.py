import requests
from bs4 import BeautifulSoup


# get data

data = requests.get('http://localhost:63342/web_scraping/bs4/scrape.html?_ijt=jnv98sbrfeprs7ktj1i88ebttk')

# load data into bs4 using html parser
# soup is entire html document
soup = BeautifulSoup(data.text, 'html.parser')

# get data simply by tr, tr html tag is for rows
# gives all table data

for tr in soup.find_all('tr'):
    for td in tr.find_all('td'):
        print(td.text)

data = []
# using list comprehension
for tr in soup.find_all('tr'):
    values = [td.text for td in tr.find_all('td')]
    data.append(values)

# get data for rows tagged as special

data = []

for tr in soup.find_all('tr', {'class': 'special'}):
    values = [td.text for td in tr.find_all('td')]
    data.append(values)


# extract special data
data = []
# find one element
div = soup.find('div', {'class': 'special_table'})

for tr in div.find_all('tr'):
    values = [td.text for td in tr.find_all('td')]
    data.append(values)

print(data)
