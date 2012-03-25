component 
{
	
	public any function init(fw)
	{
		variables.fw = fw;
		return this;
	}
	
	public void function default(rc)
	{
		arguments.rc.meta = {
			subTitle = "task view"	
		}
	}

}