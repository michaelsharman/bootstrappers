<cfscript>
	public void function addMessage (required String type, required String title, String detail="")
	{
		if (! isDefined("request.context.messages") || !isQuery(request.context.messages)) 
		{
			request.context.messages = queryNew("type,title,detail");
		}

		queryAddRow(request.context.messages, 1);
		querySetCell(request.context.messages, "type", lCase(arguments.type));
		querySetCell(request.context.messages, "title", arguments.title);
		querySetCell(request.context.messages, "detail", arguments.detail);
	}

	// Place function in request scope so that the app can access it
	request.addMessage = addMessage;
</cfscript>