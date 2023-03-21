BEGIN {
    reg1 = @/@selector\(.+\)/
    reg2 = @/@(interface|implementation)\s+\S+\(.+\)/
}

{
    if ($0 ~ reg1) {
	match($0, reg1)
	before =  substr($0, 0, RSTART - 1)
	body = substr($0, RSTART, RLENGTH)
	after = substr($0, length(before "" body) + 1, length($0) - (RSTART + RLENGTH - 1))
	gsub(/\s+/, "", body)
	debug = "<" before ">" "<" body ">" "<" after ">"
	all =  before  body  after
	print all
    }
    else if ($0 ~ reg2) {
	match($0, reg2)
	before =  substr($0, 0, RSTART - 1)
	body = substr($0, RSTART, RLENGTH)
	after = substr($0, length(before "" body) + 1, length($0) - (RSTART + RLENGTH - 1))
	split(body, items, "(" )
        body = items[1] " (" items[2] 
	debug = "<" before ">" "<" body ">" "<" after ">"
	all =  before  body  after
	print all
    }
    else {
        print;
    }

}
# /@(interface|implementation)\s+\S+\(.+\)/ {
#     print;
# }
