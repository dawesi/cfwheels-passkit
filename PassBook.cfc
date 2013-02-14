<cfcomponent displayname="Apple Passbook" output="false">
	<cffunction name="init" output="false">
		<cfargument name="type" type="string" default="generic"/>
        <cfscript>
        	setType(arguments.type);
            return this;
        </cfscript>
    </cffunction>

    <cffunction name="setTemplate" returntype="any" output="false">
    	<cfargument name="template" type="string" required="true"/>
    	<cfscript>
    		variables.templatePath = expandPath("/passbooks/#template#");
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setType" returntype="any" output="false">
    	<cfargument name="type" type="string" required="true">
    	<cfscript>
    		variables.type = arguments.type;

    		return this;	
    	</cfscript>
    </cffunction>

    <cffunction name="setFields" returntype="any" output="false">
    	<cfargument name="type" type="string" default="primary"/>
    	<cfscript>
    		var loc = {};

    		if(!structKeyExists(variables,'fields')){
    			variables.fields = {};
    		}

    		loc.type = arguments.type;
    		structDelete(arguments,'type');

    		switch(loc.type){
    			case 'secondary':
    				loc.method = 'setSecondaryFields';
    				break;
    			case 'auxiliary':
    				loc.method = 'setAuxiliaryFields';
    				break;
    			case 'back':
    				loc.method = 'setBackFields';
    				break;
    			case 'header':
    				loc.method = 'setHeaderFields';
    				break;
    			default:
    				loc.type = 'primary';
    				loc.method = 'setPrimaryFields';
    				break;
    		}

    		loc.fields = $createJavaObject('java.util.ArrayList').init();

    		//Loop through the rest of the arguments, and them to the list
    		for(loc.key in arguments){
    			loc.item = arguments[loc.key];
				loc.field = $createJavaObject('de.brendamour.jpasskit.PKField').init();
				loc.field.setKey(loc.key);
				if(isStruct(loc.item)){
					//All of the properties have been set in the struct
					if(structKeyExists(loc.item,'label'))
						loc.field.setLabel(loc.item.label);

					if(structKeyExists(loc.item,'value'))
						loc.field.setValue(loc.item.value);

					if(structKeyExists(loc.item,'changeMessage'))
						loc.field.setChangeMessage(loc.item.changeMessage);

					if(structKeyExists(loc.item,'currencyCode'))
						loc.field.setCurrencyCode(loc.item.currencyCode);

					if(structKeyExists(loc.item,'textAlignment'))
						loc.field.setTextAlignment($returnEnumeration(loc.item.textAlignment,$textAlignments()));

					if(structKeyExists(loc.item,'numberStyle'))
						loc.field.setNumberStyle($returnEnumeration(loc.item.numberStyle,$numberStyles()));

					if(structKeyExists(loc.item,'dateStyle'))
						loc.field.setDateStyle($returnEnumeration(loc.item.dateStyle,$dateStyles()));

					if(structKeyExists(loc.item,'timeStyle'))
						loc.field.setTimeStyle($returnEnumeration(loc.item.timeStyle,$dateStyles()));

					if(structKeyExists(loc.item,'relative')){
						if(loc.item.relative){
							loc.field.setIsRelative(true);
						}
						else{
							loc.field.setIsRelative(false);
						}
					}

				}
				else if(isSimpleValue(loc.item) && len(loc.item)){
					loc.field.setValue(loc.item);
				}
				loc.fields.add(loc.field);
			}

			//Store them in variables, we won't set it until we actually build it
			variables.fields[loc.type] = {
				'method' = loc.method,
				'fields' = loc.fields
			};

			return this;
    	</cfscript>
    </cffunction>

    <cffunction name="$setFieldProperty" returntype="any" output="false" access="private">
    	<cfargument name="field" type="any" required="true"/>
    	<cfargument name="method" type="string" required="true"/>
    	<cfargument name="key" type="string" required="true"/>
    	<cfargument name="item" type="struct" required="true"/>
   		<cfscript>
   			if(structKeyExists(arguments.item,arguments.key)){

   			}
   		</cfscript>
    </cffunction>

    <cffunction name="setBarcode" returntype="any" output="false">
    	<cfargument name="message" type="string" required="true"/>
    	<cfargument name="type" type="string" default="qr"/>
    	<cfargument name="format" type="string" default="utf-8"/>
    	<cfargument name="altText" type="string" required="false"/>
    	<cfscript>
    		var loc = {};
    		//Recreate the barcode object
    		loc.barcode = $createJavaObject('de.brendamour.jpasskit.PKBarcode');
    		//Determine the type
    		loc.type = $returnEnumeration(arguments.type,$barcodeFormats());

    		loc.barcode.setFormat(loc.type);
    		loc.barcode.setMessage(arguments.message);
    		loc.barcode.setMessageEncoding($createJavaObject('java.nio.charset.Charset').forName(arguments.format));

    		if(structKeyExists(arguments,'altText') && len(arguments.altText)){
    			loc.barcode.setAltText(arguments.altText);
    		}

    		//Store it in the variables scope
    		variables.barcode = loc.barcode;

    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setSerialNumber" returntype="any" output="false">
    	<cfargument name="serial" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setSerialNumber(arguments.serial);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setPassTypeIdentifier" returntype="any" output="false">
    	<cfargument name="passtype" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setPassTypeIdentifier(arguments.passtype);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setWebServiceUrl" returntype="any" output="false">
    	<cfargument name="url" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setWebServiceURL($createJavaObject('java.net.URL').init(arguments.url));
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setAuthenticationToken" returntype="any" output="false">
    	<cfargument name="token" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setAuthenticationToken(arguments.token);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setFormatVersion" returntype="any" output="false">
    	<cfargument name="version" type="numeric" required="true"/>
    	<cfscript>
    		$getPassBook().setFormatVersion(arguments.version);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setDescription" returntype="any" output="false">
    	<cfargument name="description" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setDescription(arguments.description);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setTeamIdentifier" returntype="any" output="false">
    	<cfargument name="id" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setTeamIdentifier(arguments.id);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setOrganizationName" returntype="any" output="false">
    	<cfargument name="name" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setOrganizationName(arguments.name);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setLogoText" returntype="any" output="false">
    	<cfargument name="text" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setLogotext(arguments.text);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setForegroundColor" returntype="any" output="false">
    	<cfargument name="color" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setForegroundColor(arguments.color);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setBackgroundColor" returntype="any" output="false">
    	<cfargument name="color" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setBackgroundColor(arguments.color);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setLabelColor" returntype="any" output="false">
    	<cfargument name="color" type="string" required="true"/>
    	<cfscript>
    		$getPassBook().setLabelColor(arguments.color);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setSuppressShine" returntype="any" output="false">
    	<cfargument name="suppress" type="boolean" required="true"/>
    	<cfscript>
    		$getPassBook().setSuppressStripShine(arguments.suppress);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setRelevantDate" returntype="any" output="false">
    	<cfargument name="date" type="any" required="true"/>
    	<cfscript>
    		$getPassBook().setRelevantDate(arguments.date);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setAssociatedStoreIdentifiers" returntype="any" output="false">
    	<cfargument name="ids" type="any" required="true"/>
    	<cfscript>
    		var loc = {};

    		loc.identifiers = $createJavaObject('java.util.ArrayList').init();

    		loc.iLen = listLen(arguments.ids);
    		for(loc.i = 1; loc.i <= loc.iLen; loc.i++){
    			loc.identifiers.add(val(listGetAt(arguments.ids,loc.i)).longValue());
    		}

    		$getPassBook().setAssociatedStoreIdentifiers(loc.identifiers);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="setLocations" returntype="any" output="false">
    	<cfargument name="locations" type="any" required="true"/>
    	<cfscript>
    		var loc = {};

    		loc.locations = $createJavaObject('java.util.ArrayList').init();

    		loc.iLen = arrayLen(arguments.locations);
    		for(loc.i = 1; loc.i <= loc.iLen; loc.i++){
    			loc.item = arguments.locations[loc.i];
    			loc.location = $createJavaObject('de.brendamour.jpasskit.PKLocation');
    			if(structKeyExists(loc.item,'latitude'))
    				loc.location.setLatitude(val(loc.item.latitude));
    			if(structKeyExists(loc.item,'longitude'))
    				loc.location.setLongitude(val(loc.item.longitude));
    			if(structKeyExists(loc.item,'altitude'))
    				loc.location.setAltitude(val(loc.item.altitude));
    			if(structKeyExists(loc.item,'text'))
    				loc.location.setRelevantText(loc.item.text);

    			loc.locations.add(loc.location);
    		}

    		$getPassBook().setLocations(loc.locations);
    		return this;
    	</cfscript>
    </cffunction>

    <cffunction name="build" returntype="any" output="false">
    	<cfargument name="file" type="string" required="false"/>
    	<cfargument name="password" type="string" default=""/>
    	<cfscript>
    		var loc = {};

    		//Set things on the passbook at the end
    		if(structKeyExists(variables,'barcode'))
    			$getPassBook().setBarcode(variables.barcode);

    		//Get the correct type that they set it too
    		switch(variables.type){
    			case 'boardingpass':
    				loc.passClass = 'PKBoardingPass';
    				loc.passMethod = 'setBoardingPass';
    				break;
    			case 'coupon':
    				loc.passClass = 'PKCoupon';
    				loc.passMethod = 'setCoupon';
    				break;
    			case 'eventticket':
    				loc.passClass = 'PKEventTicket';
    				loc.passMethod = 'setEventTicket';
    				break;
    			case 'storecard':
    				loc.passClass = 'PKStoreCard';
    				loc.passMethod = 'setStoreCard';
    				break;
    			default:
    				loc.passClass = 'PKGenericPass';
    				loc.passMethod = 'setGeneric';
    				break;
    		}

    		//Create it, and add the fields
    		loc.pass = $createJavaObject('de.brendamour.jpasskit.passes.#loc.passClass#');
    		if(structKeyExists(variables,'fields')){
    			for(loc.type in variables.fields){
    				loc.method = variables.fields[loc.type].method;
    				loc.fields = variables.fields[loc.type].fields;
    				loc.pass[loc.method](loc.fields);
    			}
    		}
    		$getPassBook()[loc.passMethod](loc.pass);

    		//Sign and make the archive
    		loc.signingUtil = $createJavaObject('de.brendamour.jpasskit.signing.PKSigningUtil');
    		loc.signingInfo = loc.signingUtil.loadSigningInformationFromPKCS12FileAndIntermediateCertificateFile(
    				$passBookCertificateLocation(),
    				arguments.password,
    				$intermediateCertificateLocation()
    			);

    		loc.bytes = loc.signingUtil.createSignedAndZippedPkPassArchive(
    				$getPassBook(),
    				variables.templatePath,
    				loc.signingInfo
    			);

    		//See if we are writing this to a file
    		if(structKeyExists(arguments,'file') && len(arguments.file)){
    			loc.file = $createJavaObject('java.io.FileOutputStream').init(arguments.file);
	    		loc.file.write(loc.bytes);
	    		loc.file.close();
    		}

    		return loc.bytes;
    	</cfscript>
    </cffunction>

    <cffunction name="$getPassBook" returntype="any" output="false">
    	<cfscript>
    		if(!structKeyExists(variables,'pkpass')){
    			variables.pkpass = $createJavaObject('de.brendamour.jpasskit.PKPass');
    		}

    		return variables.pkpass;
    	</cfscript>
    </cffunction>

   <cffunction name="$classpath" returntype="any" output="false" access="private">
   		<cfscript>
   			return 'lib/jackson-core-asl-1.9.11.jar,lib/jackson-mapper-asl-1.9.11.jar,lib/guava-14.0-rc1.jar,lib/bcprov-jdk15on-1.47.jar,lib/bcpkix-jdk15on-1.47.jar,lib/bcmail-jdk15on-1.47.jar,lib/jpasskit-0.0.2.jar';
   		</cfscript>
    </cffunction>

    <cffunction name="$createJavaObject" returntype="any" output="false" access="private">
    	<cfargument name="class" type="string" required="true"/>
    	<cfargument name="classpath" type="string" default="#$classpath()#"/>
    	<cfscript>
    		//First see if the class is already on the classpath
    		if($classExists(arguments.class)){
    			return createObject('java',arguments.class);
    		}

    		//Now check if it is railo
    		if(structKeyExists(server,'railo') && len(arguments.classpath)){
    			//We can pass the classpath directly here
    			return createObject('java',arguments.class,arguments.classpath);
    		}

    		//TODO: Check if Adobe Coldfusion here in the future. Either use JavaLoader.cfc or see if CF10's new features will work

    		throw(message="Unable to create the java object with class name: #arguments.class#. You may running on an unsupported engine.");
    	</cfscript>
    </cffunction>

    <cffunction name="$classExists" returntype="boolean" output="false" access="private">
    	<cfargument name="class" type="string" required="true"/>
    	<cfscript>
    		var loc = {};
    		loc.returnValue = true;
			try {
				loc.class = createObject('java','java.lang.Class').forName(arguments.class,false,$null());
			}
			catch(any e){
				loc.returnValue = false;
			}

			return loc.returnValue;
    	</cfscript>
    </cffunction>

    <cffunction name="$null" returntype="any" output="false" access="private">
    	<cfreturn javaCast("null","")/>
    </cffunction>

    <!--- Enumerations --->

    <cffunction name="$returnEnumeration" returntype="any" output="false" access="private">
    	<cfargument name="key" type="string" required="true"/>
    	<cfargument name="enumerator" type="any" required="true"/>
    	<cfscript>
    		var loc = {};
    		loc.enum = '';
    		loc.returnValue = $null();

    		if(structKeyExists(arguments.enumerator,arguments.key)){
    			loc.enum = arguments.enumerator[arguments.key];
    		}
    		else if(structKeyExists(arguments.enumerator,'default')){
    			loc.enum = arguments.enumerator.default;
    		}

    		if(len(loc.enum) && structKeyExists(arguments.enumerator,'class')){
    			loc.returnValue = $createJavaObject('de.brendamour.jpasskit.enums.#arguments.enumerator.class#').valueOf(loc.enum);
    		}

    		return loc.returnValue;
    	</cfscript>
    </cffunction>

    <cffunction name="$barcodeFormats" returntype="any" output="false" access="private">
    	<cfscript>
    		return {
    			'class' = 'PKBarcodeFormat',
    			'default' = 'PKBarcodeFormatQR',
    			'pdf417' = 'PKBarcodeFormatPDF417',
    			'aztec' = 'PKBarcodeFormatPAztec'
    		};
    	</cfscript>
    </cffunction>

    <cffunction name="$dateStyles" returntype="any" output="false" access="private">
    	<cfscript>
    		return {
    			'class' = 'PKDateStyle',
    			'default' = 'PKDateStyleFull',
    			'none' = 'PKDateStyleNone',
    			'short' = 'PKDateStyleShort',
    			'medium' = 'PKDateStyleMedium',
    			'long' = 'PKDateStyleLong'
    		};
    	</cfscript>
    </cffunction>

    <cffunction name="$numberStyles" returntype="any" output="false" access="private">
    	<cfscript>
    		return {
    			'class' = 'PKNumberStyle',
    			'default' = 'PKNumberStyleDecimal',
    			'percent' = 'PKNumberStylePercent',
    			'scientific' = 'PKNumberStyleScientific',
    			'spellout' = 'PKNumberStyleSpellOut'
    		};
    	</cfscript>
    </cffunction>

    <cffunction name="$textAlignments" returntype="any" output="false" access="private">
    	<cfscript>
    		return {
    			'class' = 'PKTextAlignment',
    			'default' = 'PKTextAlignmentNatural',
    			'left' = 'PKTextAlignmentLeft',
    			'center' = 'PKTextAlignmentCenter',
    			'right' = 'PKTextAlignmentRight'
    		};
    	</cfscript>
    </cffunction>

    <cffunction name="$transitTypes" returntype="any" output="false" access="private">
    	<cfscript>
    		return {
    			'class' = 'PKTransitType',
    			'default' = 'PKTransitTypeGeneric',
    			'air' = 'PKTransitTypeAir',
    			'boat' = 'PKTransitTypeBoat',
    			'bus' = 'PKTransitTypeBus',
    			'train' = 'PKTransitTypeTrain'
    		};
    	</cfscript>
    </cffunction>

    <cffunction name="$passBookCertificateLocation" returntype="string" output="false" access="private">
        <cfargument name="file" type="string" default=""/>
        <cfscript>
            var loc = {};

            loc.sys  = createObject("java", "java.lang.System");
            
            return loc.sys.getProperty('PASSKIT.CERTIFICATE_LOCATION');
        </cfscript>
    </cffunction>

    <cffunction name="$intermediateCertificateLocation" returntype="string" output="false" access="private">
        <cfargument name="file" type="string" default=""/>
        <cfscript>
            var loc = {};

            loc.sys  = createObject("java", "java.lang.System");
            
            return loc.sys.getProperty('PASSKIT.INTERMEDIATE_LOCATION');
        </cfscript>
    </cffunction>
</cfcomponent>