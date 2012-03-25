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
			arguments.rc.meta.subTitle = "list view"	
		}
		variables.fw.service("#variables.fw.getsection()#.get", variables.fw.getsection());
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
	
	
	private struct function getConfig()
	{
		return application.config;
	}
	
	
	private void function setStatusCode(code = 500)
	{
		getPageContext().getResponse().setstatus(arguments.code);
	}

}