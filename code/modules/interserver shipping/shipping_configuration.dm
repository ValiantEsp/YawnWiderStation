/datum/configuration
	var/shipping_auth = "memes"
	var/list/authedservers = list()

// Example line in the config: First line should be your shipping_auth password (the one others needs to ship with you)
// The other lines should be what's below this line
// 192.168.1.1:1234 ServerName;ServerPW (The PW of that server, ask them for it)
/datum/configuration/proc/loadshippinglist(filename)
	var/list/L = file2list(filename)
	for(var/i in 1 to L.len)
		var/t = L[i]
		if(i == 1)
			shipping_auth = t
			continue

		if(!t)	continue
		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/ip = null
		var/value = null

		if (pos)
			ip = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			ip = lowertext(t)

		if (!ip)
			continue

		var/name
		var/auth
		pos = findtext(value, ";")
		if (pos)
			name = lowertext(copytext(value, 1, pos))
			auth = copytext(value, pos + 1)

		authedservers[ip] = new /datum/shippingservers(ip, name, auth)
		world << "Added server: [ip] [name] [auth] to list"