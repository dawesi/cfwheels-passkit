<cfcomponent displayname="Apple Passbook Plugin" output="false">
	<cffunction name="init" output="false">
        <cfscript>
            this.version = "1.1.8";
            return this;
        </cfscript>
    </cffunction>

    <cffunction name="createPassbook" returntype="any" output="false">
        <cfargument name="type" type="string" default="generic"/>
        <cfscript>
            var loc = {};

            loc.returnValue = createObject('component','PassBook').init(arguments.type);

            return loc.returnValue;
        </cfscript>
    </cffunction>

</cfcomponent>