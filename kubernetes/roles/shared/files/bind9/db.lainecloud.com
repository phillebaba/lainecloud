$TTL 1D
lainecloud.com.	IN SOA	service	root.service.lainecloud.com. (
		2007111301	; serial
		1D		; refresh
		1H		; retry
		1D		; expire
		1D )		; minimum

		IN NS		service
		IN MX		10 service

; domain to IP mappings
service	IN A		192.168.20.105
