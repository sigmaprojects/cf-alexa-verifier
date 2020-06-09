<cfscript>
// https://github.com/jmding0714/alexa-skills-kit-java-master/blob/master/src/main/java/com/amazon/speech/speechlet/authentication/SpeechletRequestSignatureVerifier.java
// https://stackoverflow.com/questions/3151407/signature-verify-always-returns-false
// https://github.com/mreinstein/alexa-verifier
certHrefs = [
'https://s3.amazonaws.com/echo.api/echo-api-cert.pem',
'https://s3.amazonaws.com/echo.api/echo-api-cert-6-ats.pem'
];
for(href in certHrefs) {
	pemString = fetchCert(href).data;
	res = validateCert(pemString);
	writedump(var=res,label=href);
	validSig = isValidSignature(pemString,'YWJiYw==','abc123');
	writedump(var=validSig,label='isValidSignature');
	writeOutput("<br />");
}

private any function getBytes(str,encoding='UTF-8') {
	return createObject('java', 'java.lang.String').init(JavaCast('string', arguments.str)).getBytes(arguments.encoding);
}

private any function generateCertificateFromString(pem_string) {
	var CertificateFactory = createObject('java','java.security.cert.CertificateFactory');

	var bais = createObject('java','java.io.ByteArrayInputStream').init( getBytes(arguments.pem_string) );
	var bis = createObject('java','java.io.BufferedInputStream').init( bais );

	var cert = CertificateFactory.getInstance("X.509").generateCertificate(bis);
	return cert;
}

public struct function isValidSignature(pem_cert, signatureBase64, requestBody) {
	var result = {
		success = false,
		errors = [],
		data = ''
	};
	try {
    	var requestBodyByteArray = getBytes(arguments.requestBody);

		var certificate = generateCertificateFromString(arguments.pem_cert);

		var signature = createObject('java','java.security.Signature').getInstance('SHA1withRSA');
		signature.initVerify( certificate.getPublicKey() );
		signature.update(requestBodyByteArray);
		var signatureString = toString( toBinary( arguments.signatureBase64 ) );
		var signatureBytes = getBytes(signatureString);

		result.success = signature.verify(signatureBytes);

	} catch(any e) {
		result.success = false;
		arrayAppend(result.errors,e.message);
	}
	return result;
}


public struct function validateCert(pem_cert) {
	var VALID_CERT_SAN = 'echo-api.amazon.com';
	var result = {
		success = true,
		errors = [],
		data = ''
	};
	var domainExists = false;

	var cert = generateCertificateFromString( pemString );

	// this may be a multidimentional array, account for it
	var SANs = cert.getSubjectAlternativeNames().toArray();

	if( !arrayLen(SANs) ) {
		result.success = false;
		arrayAppend(result.errors,'invalid certificate validity (subjectAltName extension not present)');
	}

	for(var SAN in SANs) {
		if( isArray(SAN) ) {
			for(var subSAN in SAN) {
				if(subSAN == VALID_CERT_SAN) {
					domainExists = true;
				}
			}
		} else {
			if(SAN == VALID_CERT_SAN) {
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

}

// fetch cert
public struct function fetchCert(href) {
	// https://s3.amazonaws.com/echo.api/echo-api-cert.pem invalid (expired)
	// https://s3.amazonaws.com/echo.api/echo-api-cert-6-ats.pem valid until 2019-06-13 05:00:00
	var returnObject = {
		success = true,
		errors = [],
		data = ''
	};
	try {
		cfhttp(method="GET", charset="utf-8", url=arguments.href, result="local.result") {
			cfhttpparam(name="q", type="formfield", value="cfml");
		}
	} catch(any e) {
		returnObject.success = false;
		arrayAppend(returnObject.errors,'Failed to download certificate at: #arguments.href#. Error: #e.message#');
	}
	if( left(local.result.Statuscode,3) != 200 ) {
		returnObject.success = false;
		arrayAppend(returnObject.errors,'Failed to download certificate at: #arguments.href#. Response code: #local.result.Statuscode#');
	}
	if( returnObject.success ) {
		returnObject.data = local.result.Filecontent;
	}
	return returnObject;
}


</cfscript>

