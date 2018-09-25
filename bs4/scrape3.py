import requests
from bs4 import BeautifulSoup
import pandas as pd

# data from leaderboard
data = requests.get('https://umggaming.com/leaderboards')

# load it into soup variable

soup = BeautifulSoup(data.text, 'html.parser')

leaderboard = soup.find('table', {'id': 'leaderboard-table'})
tbody = leaderboard.find('tbody')

place = []
username = []
xp = []

for tr in tbody.find_all('tr'):
    # for each row, below returns a list
    # print(tr.find_all('td'))
    place.append(tr.find_all('td')[0].text.strip())
    username.append(tr.find_all('td')[1].find_all('a')[1].text.strip())
    xp.append(tr.find_all('td')[3].text.strip())

df = pd.DataFrame(
    {
        'Rank': place,
        'Username': username,
        'Experience': xp

    }

)

print(df)