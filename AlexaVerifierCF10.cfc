<cfcomponent output=false>

	<cfset variables.TIMESTAMP_TOLERANCE	= 1500000 />
	<cfset variables.VALID_CERT_HOSTNAME	= 's3.amazonaws.com' />
	<cfset variables.VALID_CERT_PATH_START	= '/echo.api/' />
	<cfset variables.VALID_CERT_PORT		= '443' />
	<cfset variables.VALID_CERT_SAN			= 'echo-api.amazon.com' />
	<cfset variables.LOG_REQUESTS			= true />
	<cfset variables.LOG_REQUESTS_DIR		= expandPath('./logs/') />

	<cffunction name="verifier" access="remote" returntype="struct" returnFormat="json">
		<cfscript>
		var result = {
			success = true,
			errors = [],
			data = ''
		};

		try {

			var requestData = getHTTPRequestData();


			if( !structKeyExists(requestData,'headers') || !structKeyExists(requestData.headers,'SignatureCertChainUrl') ) {
				arrayAppend(result.errors,'missing certificate url');
			}
			if( !structKeyExists(requestData,'headers') || !structKeyExists(requestData.headers,'Signature') ) {
				arrayAppend(result.errors,'missing signature');
			}
			if(
				!structKeyExists(requestData,'content') ||
				( isSimpleValue(requestData.content) && !len(trim(requestData.content)) )
			) {
				arrayAppend(result.errors,'missing request (certificate) body');
			}
			if( !isSimpleValue(requestData.content) ) {
				requestData.content = toString( requestData.content );
			}

			// since the above is so crucial to the rest of the processing, return out now.
			if( arrayLen(result.errors) ) {
				result.success = false;
				logRequest(method='verifier',args={requestData=requestData}, result=result);
				return result;
			}


		} catch(any e) {
			arrayAppend(result.errors,'Verifier error: ' & e.message);
			logRequest(method='verifier_error',args={requestData=requestData}, error=e);
			result.success = false;
			return result;
		}

		result = verifierManual(
			requestData.headers.SignatureCertChainUrl,
			requestData.headers.Signature,
			requestData.content
		);

		return result;
		</cfscript>
	</cffunction>


	<cffunction name="verifierManual" access="public" returntype="struct" returnFormat="json">
		<cfargument name="signatureCertChainUrlHeader" type="String" default="" />
		<cfargument name="signatureHeader" type="String" default="" />
		<cfargument name="contentBody" type="String" default="" />
		<cfscript>
		var result = {
			success = true,
			errors = [],
			data = ''
		};

		try {

			var cert_url = arguments.signatureCertChainUrlHeader;
			var signature = arguments.signatureHeader;
			var requestRawBody = arguments.contentBody;

			// validate the certificate URL
			var validateCertUriResult = validateCertUri(cert_url);
			result.errors.addAll( validateCertUriResult.errors );
			
			if( !arrayLen(result.errors) ) {
				// validate the timestamp
				var validateTSResult = validateTimestamp(requestRawBody);
				result.errors.addAll( validateTSResult.errors );
			}

			if( !arrayLen(result.errors) ) {
				// fetch the certificate
				var fetchResult = fetchCert(cert_url);
				result.errors.addAll( fetchResult.errors );
			}

			if( !arrayLen(result.errors) ) {
				// validate the certificate
				var validateResult = validateCert(fetchResult.data);
				result.errors.addAll( validateResult.errors );
			}

			if( !arrayLen(result.errors) ) {
				// validate the signature
				var validSignatureResult = isValidSignature(fetchResult.data, signature, requestRawBody);
				result.errors.addAll( validSignatureResult.errors );
			}

		} catch(any e) {
			arrayAppend(result.errors,'Manual Verifier error: ' & e.message);
			logRequest(method='verifierManual_error',args=arguments, error=e);
		}


		if( arrayLen(result.errors) ) {
			result.success = false;
		}

		logRequest(method='verifierManual',args=arguments, result=result);

		return result;
		</cfscript>
	</cffunction>


	<cffunction name="validateTimestamp" access="public" returntype="struct" returnFormat="json">
		<cfargument name="requestBody" type="String" default="" />
		<cfscript>
		var result = {
			success = true,
			data = '',
			errors = []
		};

		var jsonObj = {};

		try {
			jsonObj = deserializeJSON(arguments.requestBody);
		} catch(any e) {
			result.success = false;
			arrayAppend(result.errors,'Uanble to deserialize json : ' & e.message);
		}

		if( !structKeyExists(jsonObj,'request') || !structKeyExists(jsonObj.request,'timestamp') ) {
			result.success = false;
			arrayAppend(result.errors,'Timestamp field not present in request');
		}

		var d = parseDateTime(jsonObj.request.timestamp);
		var dNow = Now();
		var oldestTime = dNow.getTime() - (variables.TIMESTAMP_TOLERANCE * 1000);
		if (d.getTime() < oldestTime) {
			result.success = false;
			arrayAppend(result.errors,'Request is from more than ' & variables.TIMESTAMP_TOLERANCE & ' seconds ago');
		}
		return result;
		</cfscript>
	</cffunction>


	<cffunction name="isValidSignature" access="public" returntype="struct" returnFormat="json">
		<cfargument name="pem_cert" type="String" default="" />
		<cfargument name="signatureBase64" type="String" default="" />
		<cfargument name="requestBody" type="String" default="" />
		<cfscript>
		var result = {
			success = false,
			errors = [],
			data = ''
		};

		try {
			var certificate = generateCertificateFromString(arguments.pem_cert);

			var signature = createObject('java','java.security.Signature').getInstance('SHA1withRSA');
			signature.initVerify( certificate.getPublicKey() );
			signature.update( arguments.requestBody.getBytes('UTF-8') );
			//var decodedSignature = createObject('java','java.util.Base64').getDecoder().decode( arguments.signatureBase64 );
			var decodedSignature = BinaryDecode( arguments.signatureBase64, 'base64' );
			result.success = signature.verify( decodedSignature );
		
		} catch(any e) {
			result.success = false;
			logRequest(method='isValidSignature_error',error=e,args=arguments);
			arrayAppend(result.errors,e.message);
		}

		if( !result.success ) {
			arrayAppend(result.errors,'Could not verify: invalid signature');
		}

		return result;
		</cfscript>
	</cffunction>


	<cffunction name="validateCertUri" access="public" returntype="struct" returnFormat="json">
		<cfargument name="cert_uri" type="String" default="" />
		<cfscript>
		var result = {
			success = true,
			data = '',
			errors = []
		};

		var jURL = createObject('java','java.net.URL').init(arguments.cert_uri);

		if(jURL.getProtocol() != 'https') {
			result.success = false;
			arrayAppend(result.errors,'Certificate URI MUST be https ' & arguments.cert_uri);
		}

		if (jURL.getPort() != -1 && (jURL.getPort() != variables.VALID_CERT_PORT)) {
			result.success = false;
			arrayAppend(result.errors,'Certificate URI port MUST be ' & variables.VALID_CERT_PORT & ', was: ' & jURL.getPort());
		}

		if (jURL.getHost() != variables.VALID_CERT_HOSTNAME) {
			result.success = false;
			arrayAppend(result.errors,'Certificate URI hostname must be ' & variables.VALID_CERT_HOSTNAME & ': ' & jURL.getHost());
		}

		if (jURL.getPath().indexOf(variables.VALID_CERT_PATH_START) != 0) {
			result.success = false;
			arrayAppend(result.errors,'Certificate URI path must start with ' & variables.VALID_CERT_PATH_START & ': ' & jURL.getPath());
		}

		return result;
		</cfscript>
	</cffunction>


	<cffunction name="validateCert" access="public" returntype="struct" returnFormat="json">
		<cfargument name="pem_cert" type="String" default="" />
		<cfscript>
		var result = {
			success = true,
			errors = [],
			data = ''
		};
		
		var domainExists = false;

		var cert = generateCertificateFromString( arguments.pem_cert );

		// this may be a multidimentional array, account for it
		var SANs = cert.getSubjectAlternativeNames().toArray();

		if( !arrayLen(SANs) ) {
			result.success = false;
			arrayAppend(result.errors,'invalid certificate validity (subjectAltName extension not present)');
		}

		for(var SAN in SANs) {
			if( isArray(SAN) ) {
				for(var subSAN in SAN) {
					if(subSAN == variables.VALID_CERT_SAN) {
						domainExists = true;
					}
				}
			} else {
				if(SAN == variables.VALID_CERT_SAN) {
					domainExists = true;
				}
			}
		}

		if( !domainExists ) {
			result.success = false;
			arrayAppend(result.errors,'invalid certificate validity (correct domain not found in subject alternative names)');
		}


		var currTime = now().getTime();
		var notAfterTime = cert.getNotAfter().getTime();
		if (notAfterTime <= currTime) {
			result.success = false;
			arrayAppend(result.errors,"invalid certificate validity ('#cert.getNotAfter()#' past expired date)");
		}

		var notBeforeTime = cert.getNotBefore().getTime();
		if (currTime <= notBeforeTime) {
			result.success = false;
			arrayAppend(result.errors,"invalid certificate validity (start date '#cert.getNotBefore()#' is in the future)");
		}

		return result;
		</cfscript>
	</cffunction>


	<cffunction name="fetchCert" access="public" returntype="struct" returnFormat="json">
		<cfargument name="href" type="String" default="" />
		<cfscript>
		// https://s3.amazonaws.com/echo.api/echo-api-cert.pem invalid (expired)
		// https://s3.amazonaws.com/echo.api/echo-api-cert-6-ats.pem valid until 2019-06-13 05:00:00
		var returnObject = {
			success = true,
			errors = [],
			data = ''
		};

		try {

			var httpService = new http(method="GET", charset="utf-8", url=arguments.href); 
 			
 			var local.result = httpService.send().getPrefix(); 

		} catch(any e) {
			returnObject.success = false;
			arrayAppend(returnObject.errors,'Failed to download certificate at: #arguments.href#. Error: #e.message#');
		}
		if( left(local.result.Statuscode,3) != 200 ) {
			returnObject.success = false;
			arrayAppend(returnObject.errors,'Failed to download certificate at: #arguments.href#. Response code: #local.result.Statuscode#');
		}
		if( returnObject.success ) {
			if( isSimpleValue(local.result.Filecontent) ) {
				returnObject.data = local.result.Filecontent;
			} else {
				returnObject.data = local.result.Filecontent.toString();
			}
		}

		return returnObject;
		</cfscript>
	</cffunction>
	



	<cffunction name="generateCertificateFromString" access="private" returntype="any">
		<cfargument name="pem_string" type="String" default="" />
		<cfscript>
		var CertificateFactory = createObject('java','java.security.cert.CertificateFactory');

		var bais = createObject('java','java.io.ByteArrayInputStream').init( arguments.pem_string.getBytes('UTF-8') );
		var bis = createObject('java','java.io.BufferedInputStream').init( bais );

		var cert = CertificateFactory.getInstance('X.509').generateCertificate(bis);
		return cert;
		</cfscript>
	</cffunction>

	<cffunction name="logRequest" access="private" returntype="void">
		<cfscript>
		if( !variables.LOG_REQUESTS ) {
			return;
		}
		if( !directoryExists(variables.LOG_REQUESTS_DIR) ) {
			directoryCreate(variables.LOG_REQUESTS_DIR);
		}
		var contentString = '';
		savecontent variable="contentString" {
			writeDump(var=arguments,label='arguments');
			try {
				writeDump(var=GetHttpRequestData(),label='GetHttpRequestData()');
			} catch(any e) {}
		}
		var fileName = "#dateFormat(now(),'mm-dd-yyyy')#_#timeFormat(now(),'hh-nn-ss.l_tt')#";
		if( structKeyExists(arguments,'method') ) {
			fileName = arguments.method & '_' & fileName;
		}
		FileWrite(variables.LOG_REQUESTS_DIR & fileName & '.html', contentString, 'utf-8');
		</cfscript>
	</cffunction>


</cfcomponent>