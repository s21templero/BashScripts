# proxyListWget.sh
Script that downloads file from remote host using any available proxy from proxies file.  

- **Usage**
```bash
bash proxyListWget [https://Host/DownloadLink] [path/to/proxies_list.txt] [(optional)path/to/last_available_proxy.txt]
```
- **Example**
```bash
bash proxyListWget [https://google.com] [proxies_list.txt] [active_proxies.txt]
```
script will download `index.html` page via any proxy from `proxies_list.txt` file 
that will be available at the moment and add active proxy page was loaded with into the file `active_proxies.txt`.

- **Proxies list text file**
Should have this format:
```Text
IP.ADDR  PORT  INFORMATION  BLOCK  ONE  ...
IP.ADDR2  PORT2  INFORMATION  BLOCK  TWO  ...
IP.ADDR3  PORT3  INFORMATION  BLOCK  THREE  ...
```
- **Example**
```Text
111.111.111.111	8080	VN	Vietnam	elite proxy	no	yes	7 secs ago
222.222.222.222	10008	IN	India	elite proxy	yes	no	7 secs ago
333.333.333.333	8080	SV	El Salvador	elite proxy	no	yes	7 secs ago
444.444.444.444	80	AE	United Arab Emirates	anonymous	no	no	7 secs ago
```

- **Output proxies text file**
Can be used to save active proxies. Use it only if you need to validate your proxies list file.
