In order to build the best drum computer possible and to fully explore the huge realm of sound, I need loads of audio samples. But they don't come easy. They are hiding behind (individual) download buttons.

Since I have absolutely no interest in clicking on all those buttons in order to obtain the sound samples, I use web scraping with [scrapy](https://doc.scrapy.org/en/1.3/intro/tutorial.html#) instead.

## Freewavesamples.com

For crawling the (freewavesamples.com)[freewavesamples.com] page and downloading all its .wav samples, run the following command.

```
scrapy crawl freeWaveSamples -o freeWaveSamples.json
```
Note: If the file *freeWaveSamples.json* already exists, this will result in a broken file. So be sure to delete it instead.

In principle there is no need for the additional *-o* argument to scrapy. But the framework will name all the downloaded files in the **samples/full/** folder according to their hash sum. And since those names are not that descriptive, we need the extracted meta data stored in *freeWaveSamples.json* to reconstruct the file names later on.

