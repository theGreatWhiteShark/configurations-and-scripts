BEGIN {
    FS = "/"
};
{ if ( NF > 3 )
	print $1"/.../"$(NF-1)"/"$NF
}
