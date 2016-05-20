public with sharing class XLR8Utils {
	
	static public String validateId(String Idparam) {
		String id = String.escapeSingleQuotes(Idparam);
		
    	if(id != null && (id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id)) {
    		return id;
    	}
    	
    	return null;
	}
	
}