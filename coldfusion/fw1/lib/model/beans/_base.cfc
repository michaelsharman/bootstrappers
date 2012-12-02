component
{

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


	public struct function getProperties()
	{
		var properties = getMetaData(this).properties;
		var prop = "";
		var data = {};

		// Load all know properties via implicit setters
		for (var i = 1; i <= arrayLen(properties); i++)
		{
			prop = properties[i]['name'];
			data[prop] = evaluate("get#prop#()");
		}
		return data;
	}


	public void function load(numeric id)
	{
		var q = "";
		var properties = getMetaData(this).properties;
		var prop = "";

		(structKeyExists(arguments, "id"))? setId(arguments.id) : "";

		q = get();

		// Load all know properties via implicit setters
		for (var i = 1; i <= arrayLen(properties); i++)
		{
			prop = properties[i]['name'];
			if (listFindNoCase(q.columnList, prop))
			{
				evaluate("set#prop#(q[prop][1])");
			}
		}
	}

}