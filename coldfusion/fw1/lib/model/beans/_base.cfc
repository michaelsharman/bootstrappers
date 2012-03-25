component 
{
	
	private numeric function doAudit(required string area, required string action, required string details, string fkid="")
	{
		var user = application.cfcs.AuthLib.authUser();		
		var audit = new lib.model.services.audit.AuditTrail(
						dsn=getConfig().dsn
						, username=user
						, area=arguments.area
						, action=arguments.action
						, fkid=arguments.fkid
						, details=arguments.details 
					);
		writeLog(file="#application.ApplicationName#_audittrail", type="Info", text="~ Audit ~ #user# ~ #arguments.area# ~ #arguments.action# ~ #arguments.fkid# ~ #arguments.details#");
		return audit.save();		
	}

	
	private struct function getConfig()
	{
		return application.config;
	}


	public string function getObjectDisplayName()
	{
		var metadata = GetComponentMetadata(this);
		return ( StructKeyExists(metadata,"displayname") and Len(metadata.displayname) ? metadata.displayname : lcase(listlast(metadata.name, ".")) );
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
	
	
	private query function validateUniqueItem(required string table, required string item, required string value, required numeric id, numeric syllabus_id)
	{
		var q = new Query();
		var sql = "";

		sql = "SELECT * FROM #arguments.table# WHERE #arguments.item# = :value";

		if (arguments.id > 0)
		{
			sql &= " AND id <> :id";
			q.addParam(name="id", value=arguments.id, cfsqltype="cf_sql_integer");
		}
		if (structKeyExists(arguments, "syllabus_id") && val(arguments.syllabus_id) > 0)
		{
			sql &= " AND syllabus_id = :syllabusid";
			q.addParam(name="syllabusid", value=arguments.syllabus_id, cfsqltype="cf_sql_integer");
		}
		q.setDatasource(getConfig().dsn_ro);
		q.addParam(name="value", value=arguments.value, cfsqltype="cf_sql_varchar");
		q.setSQL(sql);

		return q.execute().getResult();
	}

}