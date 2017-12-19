import scrapy
import json
# Infinite scroll usually triggered by an api, inspect network in real time to see it
# underlying APIs mean no need to rely on HTML parsing anymore
# In scrapy shell http://quotes.toscrape.com/api/quotes?page=5
# import json
# data = json.loads(response.text) to read in a dictionary
# data.keys() to inspect keys


class QuotesScrollSpider(scrapy.Spider):

    name = 'infinite'
    # Start from page 1
    api_url = 'http://quotes.toscrape.com/api/quotes?page={}'
    start_urls = [api_url.format(1)]

    def parse(self, response):

        data = json.loads(response.text)
        for quote in data['quotes']:
            yield {

                'author': quote['author']['name'],
                'text': quote['text'],
                'tags': quote['tags']
            }

        if data['has_next']:
            next_page = data['page'] + 1
            yield scrapy.Request(url=self.api_url.format(next_page), callback=self.parse)
