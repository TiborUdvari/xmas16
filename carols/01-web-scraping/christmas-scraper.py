# http://www.paroles.net/chants-de-noel
import scrapy

class TestSpider(scrapy.Spider):
    name = 'test'
    start_urls = ['http://paroles2chansons.lemonde.fr/paroles-chants-de-noel/paroles-joyeux-noel.html']

    def parse(self, response):

        for song in response.css('div.song-text'):
            yield {'song': song.css('::text').extract_first() }

        #next_page = response.css('div.prev-post > a ::attr(href)').extract_first()
        #if next_page:
        #    yield scrapy.Request(response.urljoin(next_page), callback=self.parse)
        #next_page = response.css('td.song-name a::attr(href)').extract_first()
        #if next_page is not None:
        #    next_page = response.urljoin(next_page)
        #    yield scrapy.Request(next_page, callback=self.parse)