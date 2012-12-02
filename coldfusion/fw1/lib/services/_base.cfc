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

}