az network dns record-set list -g BrettPrivateDNSRG -z brett.local -o table
az network dns record-set list -g BrettPrivateDNSRG -z brett.local -o table | grep -c brett.local
