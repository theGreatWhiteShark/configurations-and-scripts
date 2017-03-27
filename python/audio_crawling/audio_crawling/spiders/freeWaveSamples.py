## Python3.5 script for crawling a web page containing a lot of audio
## files. The goal is to download all of them without a single click.

## In order to perform the web crawling, I will use scrapy instead of
## the html.parser.HTMLParser class
import scrapy

class FreeWaveSamplesSpider( scrapy.Spider ):
  # Download all the .wav files from freewavesamples.com
  name = "freeWaveSamples"
  start_urls = [ 'http://freewavesamples.com/' ]

  def parse( self, response ):
    # Loop over all the blocks describing one .wav sample
    for sample in response.css( 'div.sample' ):
      # Extract the first link within a sample block. This one is
      # referring to a page containing the desired .wav file
      yield scrapy.Request(
        response.urljoin( sample.xpath( './/a/@href' )[ 0 ].extract() ),
        callback = self.parse_audio )
    # Go on to the next page
    next_page = response.xpath( '//a[@title="Next Page"]/@href').extract_first()
    if next_page is not None:
      next_page = response.urljoin( next_page )
      yield scrapy.Request( next_page, callback = self.parse )

  def parse_audio( self, response ):
    # Link containing the actual wave file
    wav_link = response.xpath( '//a[contains(@href,".wav")]/@href').extract_first()
    wav_title = wav_link.split( '/' )[ -1 ].split( '.' )[ 0 ]

    # I can get the name and (hopefully) the instrument. For everything
    # else the page is not structured nice enough.
    yield {
      'name': wav_title,
      'instrument': response.css( 'div.sample' ).xpath(
        './/a[contains(@href,"instrument")]/text()').extract(),
      'file_urls': [ response.urljoin( wav_link ) ],
    }
