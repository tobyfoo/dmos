//FROM: https://github.com/johnlonganecker/go-proxy

// helpful resource with additional content:
// http://stackoverflow.com/questions/21270945/how-to-read-the-response-from-a-newsinglehostreverseproxy

package main

import (
	"net/http"
	"net/http/httputil"
	"net/url"
)

const BaseUrl = "http://localhost:1992"
const ListeningPort = "9992"

func main() {
	http.HandleFunc("/", ProxyFunc)
	http.ListenAndServe(":"+ListeningPort, nil)
}

func ProxyFunc(w http.ResponseWriter, r *http.Request) {
	u, err := url.Parse(BaseUrl)
	if err != nil {
		w.Write([]byte(err.Error()))
		return
	}

	proxy := httputil.NewSingleHostReverseProxy(u)
	proxy.ServeHTTP(w, r)
}
