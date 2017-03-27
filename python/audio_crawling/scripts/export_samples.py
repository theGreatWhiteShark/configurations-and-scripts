# Using Python3.5
# After scraping the web pages, I will get loads of audio files named
# according to their checksum. This is not really useful at all.
# Therefore I will use the meta data extracted during the crawling and
# stored in a .json file to rename those files. The input to this script
# should be the actual .json file.

# Note: Python may has its unique way of documenting etc. but I'm no
# native. So sorry for not sticking to the norm.

import sys, getopt, json, os, shutil

def main( argv ):
  input_file = ''
  # Verify an input file was provided
  try:
    opts, args = getopt.getopt( argv, "hi:", "input=" )
  except getopt.GetoptError:
    print( 'python3 export_samples.py -i <inputfile.json>' )
    sys.exit( 2 )

  for opt, arg in opts:
    # Just print help text and exit
    if opt == '-h':
      print( 'python3 export_samples.py -i <inputfile.json>' )
      sys.exit()
    if opt in ( "-i", "--input" ):
      input_file = arg

  return( input_file )
  
if __name__ == "__main__":
  # Obtains the passed argument
  file_name = main( sys.argv[ 1: ] )
  # In order to make this script relative to the projects root
  # directory
  file_prefix = file_name[ 0 : ( len( file_name ) -
                                   len( os.path.basename( file_name ) ) ) ]
  print( "Passed file: %s" % file_name ) 

  # Obtain the stored data
  json_file = open( file_name )
  json_data = json.load( json_file )

  # Where the renamed files will be stored
  sample_folder = "/home/phil/Music/samples"
  if not os.path.exists( sample_folder ):
    os.makedirs( sample_folder )

  for data in json_data:
    # Find the file corresponding to the checksum in the JSON entry,
    # rename it according to its meta data and store it in the
    # samples_folder
    # If the sample has an instrument assigned, it will be stored in a
    # folder corresponding to the instruments name. Else it will be
    # stored in a folder called 'diverse'
    if len( data[ 'instrument' ] ) != 0:
      # In addition all whitespaces have to be replaced and all '/'
      # removed in the instruments name
      instrument = data[ 'instrument' ][ 0 ]
      instrument = instrument.replace( ' ', '_' ).replace( '/' , '-' )
      instrument_folder = sample_folder + '/' + instrument
    else:
      instrument_folder = sample_folder + '/diverse'

    if not os.path.exists( instrument_folder ):
      os.mkdir( instrument_folder )

    # The name of the sample will be a combination of its actual name
    # and the name of the used input file in order to uniquely identify
    # its source
    shutil.copyfile(
      file_prefix + 'samples/' + data[ 'files' ][ 0 ][ 'path' ],
      instrument_folder + '/' + data[ 'name' ] + '-' +
      os.path.basename( file_name ).split( '.' )[ 0 ] + '.' +
      os.path.basename( data[ 'files' ][ 0 ][ 'path' ].split( '.' )[ 1 ] ) )
                       
