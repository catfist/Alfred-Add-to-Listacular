echo "Archived:"
gsed -n 's/^x //gp' $todotxt # echo list of done task
grep '^x ' $todotxt | gsed 's/@[due|remind])]*)//g' >> $donetxt # write done tasks to donetxt without tags
gsed -i '/^x /d' $todotxt # delete done tasks from todotxt
gsed -n '$p' $todotxt | (gsed -i '$d' $todotxt; xargs echo -n >> $todotxt) # delete linebreak of last line from todotxt
