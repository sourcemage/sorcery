BEGIN {
	FS="[^0-9]"
	OFS="."
}

# bump stable
/^v/ && !/-[1-9][0-9]*-g[0-9a-f]+$/ {
	++$NF
	for (i = 1; i < NF; i++)
		$i = $(i+1)
	--NF
	print
	exit
}

# bump snapshot
{
	sub(/.*-g/, strftime("%Y%m%d-g", systime(), 1))
	print
}
