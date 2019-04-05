curl -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" \
| grep -Po 'archive:\K[^;\"]+' \
| xargs wget -O - \
| tar -xz -C /mnt/resource
chown -R ausonia-user /mnt/resource
chmod 755 /mnt/resource/ausonia-run.sh
cd /mnt/resource
su ausonia-user -c 'nohup /mnt/resource/ausonia-run.sh'
