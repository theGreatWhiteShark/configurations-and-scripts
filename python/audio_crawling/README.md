In order to build the best drum computer possible and to fully explore the huge realm of sound, I need loads of audio samples. But they don't come easy. They are hiding behind (individual) download buttons.

Since I have absolutely no interest in clicking on all those buttons in order to obtain the sound samples, I use web scraping with [scrapy](https://doc.scrapy.org/en/1.3/intro/tutorial.html#) instead.

## Freewavesamples.com

### Download files

For crawling the [freewavesamples.com](freewavesamples.com) page and downloading all its .wav samples, run the following command.

```
scrapy crawl freeWaveSamples -o freeWaveSamples.json
```
Note: If the file *freeWaveSamples.json* already exists, this will result in a broken file. So be sure to delete it instead.

In principle there is no need for the additional *-o* argument to scrapy. But the framework will name all the downloaded files in the **samples/full/** folder according to their checksum. And since those names are not that descriptive, we need the extracted meta data stored in *freeWaveSamples.json* to reconstruct the file names later on.

### Rename files

As already mentioned, the checksums of the files are not at all descriptive names. Instead we will use the meta data from above to copy the files using the **/scripts/export_samples.py** script.

The files will be copied to the *sample_folder* directory. Be sure to edit this one, since I used an absolute path in here (Python didn't like the relative one at all).

```
cd scripts
python3 export_samples.py -i ../freeWaveSamples.json
```

For each sample having an instrument description field a new folder in *sample_folder* will be created carrying the fields content and the sample will be placed in there. If it doesn't contain any instrument information it will be placed in the 'sample_folder/diverse' directory instead.

In order to preserve some information about the source of the sample, the basename of the .json file ('freeWaveSamples') will be concatenated as well. This will become handy when you pay your tribute to the creative common licence ;)
