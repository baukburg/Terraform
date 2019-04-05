mkdir -p /opt/dependencies
for f in /tmp/dependencies/*.tar
do
    tar -xC /opt/dependencies -f $f
done
echo 'loaded all dependencies'
