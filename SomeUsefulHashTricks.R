suits <- c('king', 'queen', 'jack','king')
# "suits" is your effective hash key values
key = 'king'
# can fill key in with what you want to match
doesexist <- key %in% suits
# OR doesexist <- any(suits==key)
cond <- match(key,suits)
# match() returns NA if DNE in the list/set
# match() returns only the FIRST one that matches
grep(key, suits)
# grep returns ALL the indices where there is a match
grepl(key, suits)
# grepl returns a logical vector (i.e. TRUE/FALSE list) that can be used for cond