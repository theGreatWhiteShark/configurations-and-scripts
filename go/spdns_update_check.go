// A short script, which should check the responsivity of the spdyn.de
// DynDNS service.

package main

import (
	"errors"
	"log"
	"io/ioutil"
	"net"
	"net/http"
	"strings"
	"time"

	"github.com/miekg/dns"
)

// -------------------------------------------------------------------

const (
	
	// Default DNS server used in queryAAAARecord
	dnsServerGoogle = "8.8.8.8"  // Google
	dnsServerLocal = "192.168.178.1" // Local ISP
	dnsServerOpenDNS = "146.112.62.105" // OpenDNS.com

	// Port used during the DNS queries.
	dnsPort = "53"
	
	// Name of the subdomain the dynamic DNS record will be associated
	// with.
	hostname = "thegreatwhiteshark.spdns.de"

	// URL used for the retrieval of the global IPv6 address.
	globalIPv6Server = "https://api6.ipify.org"

	// spDYN credentials and configuration
	// spDynHostname = "thegreatwhiteshark"
	spDynToken = "edvd-jjxn-gbgq"
	spDynBaseURL = "update.spdyn.de"
	spDynURL = "https://update.spdyn.de/nic/update"

	// Temporal distance between successive queries.
	timeSleepSeconds = 60

)

// -------------------------------------------------------------------

// Sends a post request to the spdyn server to update the current IPv6
// address associated with the subdomain.
func updateIPv6(ipv6Address string) error {

	url := strings.Join([]string{
		spDynURL, `?hostname=`, hostname, `&myip=`, ipv6Address}, "")
	
	// ---------------------------------------------------------------
	
	request, err := http.NewRequest("GET", url, nil)
		// strings.NewReader(payload))
	if err != nil {
		return err
	}
	
	// ---------------------------------------------------------------

	request.Host = spDynBaseURL
	request.SetBasicAuth(hostname, spDynToken)
	
	// ---------------------------------------------------------------
	
	response, err := http.DefaultClient.Do(request)
	defer response.Body.Close()
	if err != nil {
		return err
	}
	
	// ---------------------------------------------------------------

	content, err := ioutil.ReadAll(response.Body)

	if err != nil {
		return err
	}

	if string(content) == "" {
		return errors.New("Unable to update IPv6. Response: " + string(content))
	}
	
	return nil
}

// -------------------------------------------------------------------
// Query global IPv6 address of the machine the script is running on.
func queryGlobalIPv6() (ipv6Address string, err error) {

	response, err := http.Get("https://api6.ipify.org")
	if err != nil {
		return "",  err
	}
	
	// ---------------------------------------------------------------

	content, err := ioutil.ReadAll(response.Body)
	response.Body.Close()

	if err != nil {
		return "", err
	}
	
	return string(content), nil
}

// -------------------------------------------------------------------
// Queries the domain information by interrogating a DNS name server
// and returns the AAAA record (IPv6 address) associated with the
// provided domain name.

func queryAAAARecord(client *dns.Client, message *dns.Msg) (AAAARecord string, err error) {

	response, _, err := client.Exchange(message,
		net.JoinHostPort(dnsServerLocal, dnsPort))

	if (response == nil) || (err != nil) {
		return "", err
	}

	if len(response.Answer) == 0 {
		return "", nil
	}

	AAAARecord = response.Answer[0].String()
	
	return AAAARecord, nil
}

// -------------------------------------------------------------------

func aaaaRecord2IPv6Address(aaaaRecord string) (ipv6Address string, err error) {

	if aaaaRecord == "" {
		return "", nil
	}

	recordSplit:= strings.Split(aaaaRecord, "\t")

	if len(recordSplit) < 5 {
		return "", errors.New("Unable to convert AAAA record to IPv6 address: " + aaaaRecord)
	}

	return recordSplit[4], nil

}

// -------------------------------------------------------------------

func main() {

	// ---------------------------------------------------------------
	// Setting up the configuration for the DNS query.
	
	client := new(dns.Client)
	// Suppress multiple outstanding queries with same questions.
	client.SingleInflight = true
	
	message := new(dns.Msg)
	message.SetQuestion(dns.Fqdn(hostname), dns.TypeAAAA)
	message.RecursionDesired = true

	// ---------------------------------------------------------------

	var currentIPv6Address, formerIPv6Address, domainIPv6Address,
	formerDomainIPv6Address string
	var err error

	// In case the DynDNS server is not ready yet, no IPV6 address
	// will be provided in the AAAA record. Therefore, the
	// formerDomainIPv6Address must not be an empty string. Else it
	// will be matched.
	formerDomainIPv6Address = "notAnIPv6Address"
	
	// ---------------------------------------------------------------
	// Go's equivalent of a while true loop.
	
	for {
		
		// -----------------------------------------------------------
		// Query the IPv6 address of the local machine.
		
		currentIPv6Address, err = queryGlobalIPv6()
		if err != nil {
			log.Printf("*** error: Unable to query global IPv6: %s", err.Error())
			continue
		}
		
		// ------------------------------------------------------------
	
		if formerIPv6Address != currentIPv6Address {

			log.Printf("IPv6 address updated.\n\tOld: %s\tNew: %s\n",
				formerIPv6Address, currentIPv6Address)
			
		}
		
		// -----------------------------------------------------------
		// Query the IPv6 address of the domain.

		aaaa, err := queryAAAARecord(client, message)
		if err != nil {
			log.Printf("*** error: Unable to query AAAA record: %s", err.Error())
			continue
		}
		
		domainIPv6Address, err = aaaaRecord2IPv6Address(aaaa)
		if err != nil {
			log.Printf("*** error: %s", err.Error())
			continue
		}

		// -----------------------------------------------------------

		if strings.Compare(domainIPv6Address, currentIPv6Address) != 0 {
			
			// -------------------------------------------------------
			// Check whether the current IP address was already used
			// to update the state of the DynDNS server.
	
			if strings.Compare(domainIPv6Address, formerDomainIPv6Address) != 0 {
			
				// The state of the DynDNS does not reflect the local state.
				err = updateIPv6(currentIPv6Address)
				if err != nil {
					log.Printf("*** error: Unable to update the AAAA record of the DynDNS record: %s",
						err.Error())
					continue
				}

				formerDomainIPv6Address = domainIPv6Address

				log.Printf("Query spDNY service.\n\tDomain (New): %s\tDomain (Old): %s\tLocal: %s",
					domainIPv6Address, formerDomainIPv6Address, currentIPv6Address)

			}
			
		}

		formerIPv6Address = currentIPv6Address
		
		// Sleep
		time.Sleep(time.Second*timeSleepSeconds)
		
	}
	
}
