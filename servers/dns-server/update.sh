

cp files/bind/* /etc/bind
systemctl restart bind9
named-checkconf
named-checkzone lps.ufrj.br /etc/bind/zones/db.lps.ufrj.br
named-checkzone 1.1.10.in-addr.arpa /etc/bind/zones/db.1.1.10
named-checkzone 147.164.146.in-addr.arpa /etc/bind/zones/db.147.164.146
