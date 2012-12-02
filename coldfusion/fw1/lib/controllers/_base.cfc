component
{

	public any function init(fw)
	{
		variables.fw = arguments.fw;
		return this;
	}


	public void function after(rc)
	{
		if (!structKeyExists(arguments.rc.meta, "title"))
		{
			arguments.rc.meta.title = uCase(left(variables.fw.getsection(), 1)) & right(variables.fw.getsection(), len(variables.fw.getsection())-1);
		}
		if (!structKeyExists(arguments.rc.meta, "subTitle"))
		{
			arguments.rc.meta.subTitle = "";
		}
	}


	public void function before(rc)
	{
		param name="arguments.rc.meta" default="#{}#";
	}


	public void function default(rc)
	{
		if (!structKeyExists(arguments.rc.meta, "subTitle"))
		{
			arguments.rc.meta.subTitle = "My view"
		}
	}


	/**
	 * @hint Adds any application messages to a query in the request scope for display in views
	 */
	private void function addMessage(required struct messages)
	{
		var i = 0;
		var item = "";

		param name="arguments.messages.list" default="#[]#";

		do
		{
			i++;
			item = (arrayLen(arguments.messages.list)) ? arguments.messages.list[i] : "";
			request.addMessage(arguments.messages.type, arguments.messages.title, item);
		}
		while (i < arrayLen(arguments.messages.list));
	}


	/**
	* @hint Deserialises data from the browser from JSON into a native CF datatype
	*/
	private struct function deserializeRequestData()
	{
		return isJSON( getHTTPRequestData().content ) ? deserializeJSON( getHTTPRequestData().content ) : {};
	}


	/**
	* @hint Returns either the full application.config, or a specific key from within application.config
	* @param {String} key A specific key referencing a nested struct of config parameters (an exception is thrown if the key doesn't exist)
	*/
	private struct function getConfig(String key)
	{
		if (structKeyExists(arguments, "key") && len(arguments.key))
		{
			return application.config[key];
		}
		else
		{
			return application.config;
		}
	}


	/**
	* @hint Returns a User object (for a logged in user). If called where a user is not logged in, an exception will be thrown
	*/
	private struct function getUser()
	{
		return session.user;
	}


	/**
	* @hint Returns true|false if a request was made asynchronously
	*/
	private any function isAjax()
	{
		var headers = getHttpRequestData().headers;
		return structKeyExists(headers, "X-Requested-With") && (headers["X-Requested-With"] == "XMLHttpRequest");
	}


	/**
	* @hint Returns true|false if the current user is logged in or not
	*/
	private boolean function isLoggedIn()
	{
		return isDefined("session") && structKeyExists(session, "user");
	}


	/**
	* @hint Sets the HTTP status code in the response header
	* @param {Numeric} Status code to set
	*/
	private void function setStatusCode(required Numeric code)
	{
		request.statuscode = arguments.code;
		getPageContext().getResponse().setstatus(arguments.code);
	}

}