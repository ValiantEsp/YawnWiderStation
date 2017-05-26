/datum/shippingservers
	var/serverip
	var/servername
	var/serverauth
	var/list/allowedshipids
	var/list/chathistory

/datum/shippingservers/New(_serverip, _servername, _serverauth)
	if(!_serverip || !_servername || !_serverauth)
		throw EXCEPTION("Invalid arguments sent to shippingservers/New().")

	serverip = _serverip
	servername = _servername
	serverauth = _serverauth

/**
 * @name	chat_send
 *
 * @desc	Sending chat message to other server.
 *
 * @return	bool	TRUE if everything goes well.
 *					FALSE if something fails.
 */
/datum/shippingservers/proc/chat_send(var/chatmsg, var/senderckey)
	var/out_data = json_encode(list("query" = "ship_msg", "auth" = config.shipping_auth, ckey = senderckey, "msg" = chatmsg))
	var/list/data = json_decode(world.Export("byond://[serverip]?[out_data]"))

	if (!data)
		return FALSE

	if (!data["statuscode"] || data["statuscode"] != 200)
		return FALSE
	chathistory += chatmsg
	return TRUE