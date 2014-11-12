# Add gsed to 'PATH'
PATH=$PATH:/usr/local/bin
todotxt=`cat path | sed "s%~%$HOME%"`
donetxt=${todotxt%/*}/done.txt

echo "Archived:"
gsed -n 's/^x //gp' $todotxt

grep '^x ' $todotxt | gsed 's/@[due|remind][^)]*)//g' >> $donetxt
gsed -i '/^x /d' $todotxt

gsed -n '$p' $todotxt | (gsed -i '$d' $todotxt; xargs echo -n >> $todotxt)
