
Attention! Don't use 0.0.0.0 as binding-adress fora cluster, but the external IP.
e.g:
JBOSS_OPTS=-Djboss.bind.address=192.168.40.129

Furthermore you have to edit ip-adress and ports in 
	03_set_mod_cluster_httpd.conf
	03_use_tcp_cluster.conf

