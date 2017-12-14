# Multiple pages extraction

# Problem is that multiple quotes are from different quote dividers

# -*- coding: utf-8 -*-
import scrapy


class QuotesSpider(scrapy.Spider):
    name = 'quotes'
    allowed_domains = ['toscrape.com']
    start_urls = ['http://quotes.toscrape.com']

    def parse(self, response):
        self.log('I just visited: ' + response.url)
        for quotes in response.css('.quote'):
            item = {
                'author': quotes.css('.author::text').extract(),
                'text': quotes.css('.text::text').extract(),
                'tags': quotes.css('.tag::text').extract()
            }
            yield item
