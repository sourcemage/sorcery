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
	exit
}

# add placeholder for unknown predecessor
!/^v/ { sub(/^/, "0-0-g") }

# add timestamp to snapshot
{
	"git log -1 --format=%ct" | getline  t
	sub(/-/, strftime("+%Y%m%d-", t, 1))
}

END { print }
