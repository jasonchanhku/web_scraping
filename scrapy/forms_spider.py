# browser makes a POST request to the server every time we log in
# csrf_token is a hidden input and a hash to something
# token value changes every time you refresh, common practice
# spider needs to extract csrf_token and submit a POST request to the login page

import scrapy


class LoginSpider(scrapy.Spider):

    name = 'login-spider'
    login_url = 'http://quotes.toscrape.com/login'
    start_urls = [login_url]

    # this parse to handle login requests
    def parse(self, response):

        # extract the csrf_token
        # look for an input whose name is csrf_token and take the value attribute
        token = response.css('input[name="csrf_token"]::attr(value)').extract_first()

        # create a python dict with the form items
        # look under 'name' in page source
        data = {
            'csrf_token': token,
            'username': 'abc',
            'password': 'abc'
        }
        yield scrapy.FormRequest(url=self.login_url, formdata=data, callback=self.parse_quotes)

    def parse_quotes(self, response):

        for q in response.css('.quote'):
            yield{

                'author_name': q.css('.author::text').extract_first(),
                'author_url': q.css('span a+ a::attr(href)').extract_first()

            }