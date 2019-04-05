vmCount=$(/private/var/root/bin/oci compute instance list --compartment-id ocid1.compartment.oc1..aaaaaaaapui4j3qyqji3bdg4vp35bldzpu55eqkfps3a6edu4z7tkonxoo5a --lifecycle-state running --limit 1000 | grep -c ocid1.instance.oc1)
theDate=$( date )
echo $theDate"," $vmCount | tee -a watchResults.txt 
