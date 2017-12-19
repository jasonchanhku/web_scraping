import scrapy


class ListSpider(scrapy.Spider):

    name = 'listings'
    start_urls = ['http://quotes.toscrape.com/']

    def parse(self, response):

        urls = response.css('.quote span a::attr(href)').extract()

        for url in urls:
            url = response.urljoin(url)
            # Specific tailor made callback for this kind of page or each page to parse
            yield scrapy.Request(url=url, callback=self.parse_details)

        next_page_url = response.css('.next a::attr(href)').extract_first()
        if next_page_url:
            next_page_url = response.urljoin(next_page_url)

            # New requests must be created every time there is a next page
            yield scrapy.Request(url=next_page_url, callback=self.parse)

    # For author details, in scrapy shell, use fetch('http://quotes.toscrape.com/author/Albert-Einstein/') to
    # load current shell with new response

    def parse_details(self, response):

        yield{
            'name': response.css('.author-title::text').extract_first(),
            'birth_date': response.css('.author-born-date::text').extract_first()
        }
