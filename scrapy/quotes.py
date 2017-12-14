# -*- coding: utf-8 -*-
import scrapy


class QuotesSpider(scrapy.Spider):
    name = 'quotes'
    allowed_domains = ['toscrape.com']
    start_urls = ['http://quotes.toscrape.com/random']

    def parse(self, response):
        self.log('I just visited: ' + response.url)
        yield{

            'author': response.css('.author::text').extract_first(),
            'text': response.css('.text::text').extract_first(),
            'tag': response.css('.tag::text').extract_first(),


        }
        pass
