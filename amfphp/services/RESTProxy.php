<?php

class RESTProxy
{
	public function request($uri, $method = "GET", $getVars = array(), $postVars = array(), $headers = array(), $requestId = 0)
	{
		if(count($getVars))
		{
			$uri .= "?";
			$uri .= implode("&", $getVars);
		}
		
		$curl = curl_init($uri);
		
		if($method == "POST")
			curl_setopt($curl, CURLOPT_POST, 1);
		else if($method == "GET")
		{}
		else if($method == "PUT")
		{
			curl_setopt($curl, CURLOPT_PUT, 1);
		}
		else
		{
			curl_setopt($curl, CURLOPT_CUSTOMREQUEST, $method);
		}
		
		//print_r($postVars);
		
		if(($method == "POST" || $method == "PUT") && count($postVars))
		{
			$post = "";
			
			if(is_array($postVars))
			{
				$post = implode("&", $postVars);
			}
			else 
				$post = $postVars;						
			
			curl_setopt($curl, CURLOPT_POSTFIELDS, $post);
		}
		
		curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($curl, CURLOPT_HEADER, 1);
		curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($curl, CURLOPT_USERAGENT, "Shockwave Flash");
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLINFO_HEADER_SIZE, true);
		curl_setopt($curl, CURLINFO_HTTP_CODE, true);
		curl_setopt($curl, CURLINFO_CONTENT_TYPE, true);
		curl_setopt($curl, CURLINFO_HEADER_OUT, true);
		
		$result = curl_exec($curl);
		
		if(!$result)
		{
			return "curl error (".curl_errno($curl)."):".curl_error($curl);
		}
		else 
		{
			$info = curl_getinfo($curl);
		
			$headerSize = curl_getinfo($curl, CURLINFO_HEADER_SIZE);
			$headersIn = substr($result, 0, $headerSize);
			$result = substr($result, $headerSize);
			$code = curl_getinfo($curl, CURLINFO_HTTP_CODE);
			$contentType = curl_getinfo($curl, CURLINFO_CONTENT_TYPE);
			$effectiveUrl = curl_getinfo($curl, CURLINFO_EFFECTIVE_URL);
			$headersOut = curl_getinfo($curl, CURLINFO_HEADER_OUT);
			
			curl_close($curl);
			
			return array("header" => $headersIn,
						 "content" => $result,
						 "httpCode" => $code, 
						 "contentType" => $contentType,
						 "effectiveUrl" => $effectiveUrl, 
						 "sentHeaders" => $headersOut,
						 "requestId" => $requestId);
		}
	}
}
?>