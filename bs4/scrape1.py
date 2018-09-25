import requests
import re

# get data

data = requests.get('http://localhost:63342/web_scraping/bs4/scrape.html?_ijt=i5i1gh8sov9hk4fqfd31tq7bbq')

# extract the phone numbers, emails, whatever
phones = re.findall(r'(\(?[0-9]{3}\)?(?:\-|\s|\.)?[0-9]{3}(?:\-|\.)[0-9]{4})', data.text)
emails = re.findall(r'([\d\w\.]+@[\d\w\.\-]+\.\w+)', data.text)

print(phones, emails)